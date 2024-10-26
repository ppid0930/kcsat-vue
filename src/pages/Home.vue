<template>
  <div class="container text-center">
    <div class="jumbotron">

      <div class="font-roman-bold">
        <h1 class="nav-item">ETA</h1>
      </div>
      <div class="font-nanum-gothic-regular">
        <h4 class="nav-item font-nanum-myeongjo-extrabold">무료 AI 영어 문제 생성</h4>
        <br>
        <p><span class="font-nanum-gothic-extrabold">ETA(English Test Agent)</span>는 대학수학능력시험 영어 영역 스타일의 문제를 AI를 이용하여 자동으로 생성하고,</p>
        <p>문제에 해당되는 번역과 실질적인 솔루션을 제공해 주는 서비스입니다.</p>
        <p><span class="font-nanum-gothic-extrabold">총 15개 유형</span>의 문제를 제작할 수 있고 문제를 사용자들과 공유함으로써</p>
        <p>영어 실력을 키워나갈 수 있는 커뮤니티입니다.</p>
        <br>

      </div>
      <div class="font-nanum-gothic-extrabold">
        <p>아래 버튼을 눌러 무료로 AI 문제 생성을 해보세요!!</p>
        <p>You can make your own English-Korean AI Questions for FREE!!</p>
      </div>

      <br>

      <button type="button" class="submitButton btn btn-primary btn-lg" style="background-color: #002c62; border-color: #002c62" @click="fetchQuestion" :disabled="loading">
        <span v-if="loading">
          <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
          Loading...
        </span>
        <span v-else>
          GET AI Question
        </span>
      </button>
      <div v-if="loading">
        <div v-if="nowOffset > 0">
          <span>현재 앞에 <b>{{nowOffset}}</b>명 대기중입니다.</span>
        </div>
        <div v-else-if="nowOffset === 0">
          <span><b style="color: green">문제 생성중입니다!!!!!</b></span>
        </div>
        <div v-else>
          <span>문제 생성 로딩중.......</span>
        </div>
      </div>
      <div v-else>
        <br>
      </div>
    </div>
  </div>
</template>

<script>
import api from "@/api.js"
import {computed, onUnmounted, ref} from 'vue';
import { useRouter } from 'vue-router';
import {useQuestionStorage} from "@/piniaStorage/questionStorage.js";

export default {
  setup() {
    const isAuthenticated = computed(() => !!localStorage.getItem("jwt"));
    const router = useRouter();
    const loading = ref(false);
    const questionStorage = useQuestionStorage();

    const nowOffset = ref(null); // nowOffset 값 저장
    let intervalId = null; // setInterval ID 관리

    const firstContact = async () => {
      try {
        console.log("First contact")

        await api.get('/question/firstQuestionContact');

      } catch (error) {
        console.log(error);
      }
    }

    const startNowOffsetLoop = () => {
      // 1초마다 nowOffset 값을 갱신하는 루프 시작
      intervalId = setInterval(async () => {
        try {
          const response = await api.get("/question/questionOffsetGap");
          nowOffset.value = response.data; // API 응답 데이터를 nowOffset에 저장
          console.log("Now Offset:", nowOffset.value);
        } catch (error) {
          console.error("NowOffset 가져오기 실패:", error);
        }
      }, 1000);
    };

    const stopNowOffsetLoop = () => {
      // 루프 정지
      if (intervalId) {
        clearInterval(intervalId);
        intervalId = null;
      }
    };

    const fetchQuestion = async () => {
      try {
        loading.value = true;

        console.log("Loading...")

        await firstContact();

        startNowOffsetLoop();

        // Axios 요청, 취소 토큰을 전달
        const response = await api.post('/question/createQuestionAllRandom/LLaMA');

        stopNowOffsetLoop();

        // Pinia 스토어에 데이터 저장
        questionStorage.setQuestionData({
          questionType: response.data.questionType,
          title: response.data.title,
          mainText: response.data.mainText,
          choices: response.data.choices,
          answer: response.data.answer,
        });

        if (isAuthenticated.value) {
          await router.replace({
            path: '/question/result'
          });
        } else {
          await router.replace({
            path: '/question/demo/result'
          });
        }


      } catch (error) {
        console.log(error);
        stopNowOffsetLoop();
      } finally {
        loading.value = false;
      }
    };


    // 컴포넌트가 언마운트될 때 루프 정리
    onUnmounted(() => {
      stopNowOffsetLoop();
    });


    return {
      fetchQuestion,
      loading,
      nowOffset
    };
  }
}

</script>

<style>

</style>