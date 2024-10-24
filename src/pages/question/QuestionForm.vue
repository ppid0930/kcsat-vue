<template>
  <div>
    <div class="container">
      <!-- 문제 유형 선택 -->
      <div class="form-group">
        <label for="type">문제 유형 선택</label>
        <select v-model="selectedType" id="type" class="form-control">
          <option v-for="questionType in questionTypes" :key="questionType.key" :value="questionType.key">
            {{ questionType.value }}
          </option>
        </select>
      </div>

      <br>

      <!-- 지문 입력 -->
      <div class="form-group">
        <label for="mainText">지문 입력</label>
        <textarea
            v-model="mainText"
            class="form-control"
            id="mainText"
            placeholder="생성하고자 하는 영어 지문을 입력하세요. (지문을 입력하지 않는 경우, 무작위 기출 지문으로 문제가 만들어집니다.)"
            rows="8"
        ></textarea>
      </div>

      <div class="container mt-1">
        <!-- AI 문제 생성 버튼 -->
        <button
            type="button"
            class="btn btn-primary mx-1"
            :disabled="loading"
            @click="mainText === '' ? postQuestion('/question/createRandom/LLaMA') : postQuestion('/question/create/LLaMA')"
            style="background-color: #002c62; border-color: #002c62"
        >
          <span v-if="loading">
            <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
            Loading...
          </span>
          <span v-else>AI 문제 생성</span>
        </button>
      </div>
      <div v-if="loading">
        <div v-if="nowOffset > 0">
          <p>현재 앞에 {{nowOffset}}명 대기중입니다.</p>
        </div>
        <div v-else-if="nowOffset <= 0">
          <b style="color: green">문제 생성중입니다!!!!!</b>
        </div>
        <div v-else>
          <p>문제 생성 로딩중.......</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {useRouter} from "vue-router";
import {onUnmounted, ref} from "vue";
import api from "@/api.js"

import { useQuestionStorage } from '@/piniaStorage/questionStorage';


export default {
  setup() {
    const router = useRouter();
    const loading = ref(false);
    const questionStorage = useQuestionStorage();

    const selectedType = ref("PURPOSE");
    const mainText = ref("");

    const nowOffset = ref(null); // nowOffset 값 저장
    let intervalId = null; // setInterval ID 관리



    const questionTypes = [
      { key: "PURPOSE", value: "글의 목적" },
      { key: "MAIN_IDEA", value: "글의 요지" },
      { key: "TITLE", value: "글의 제목 추론" },
      { key: "TOPIC", value: "글의 주제" },
      { key: "TARGET_UNMATCH", value: "대상 정보 불일치" },
      { key: "FEELING_CHANGE", value: "화자 심경 변화" },
      { key: "UNDERLINE", value: "밑줄 친 구문 의미" },
      { key: "BLANK", value: "빈칸 추론" },
      { key: "BLANK_AB", value: "빈칸 A,B 추론" },
      { key: "INFO_MATCH", value: "안내문 일치" },
      { key: "INFO_UNMATCH", value: "안내문 불일치" },
      { key: "GRAMMAR", value: "어법" },
      { key: "SUMMARIZE_AB", value: "요약문 A,B 추론" },
      { key: "ORDERING", value: "이어질 글의 순서 배열" },
      { key: "ARGUMENT", value: "필자가 주장하는 바" }
    ];


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


    const postQuestion = async (url) => {
      try {
        loading.value = true;
        const payload = {
          type: selectedType.value,
          mainText: mainText.value,
        };


        await firstContact()

        console.log("Loading...")

        startNowOffsetLoop();

        // Axios 요청, 취소 토큰을 전달
        const response = await api.post(url, payload);

        stopNowOffsetLoop();


        // Pinia 스토어에 데이터 저장
        questionStorage.setQuestionData({
          questionType: response.data.questionType,
          title: response.data.title,
          mainText: response.data.mainText,
          choices: response.data.choices,
          answer: response.data.answer,
        });

        // 요청 성공 시 페이지 이동
        await router.replace({path: '/question/result'});
      } catch (error) {
        console.log(error);
        stopNowOffsetLoop();
      }
    };

    // 컴포넌트가 언마운트될 때 루프 정리
    onUnmounted(() => {
      stopNowOffsetLoop();
    });

    return {
      selectedType,
      mainText,
      questionTypes,
      postQuestion,
      loading,
      nowOffset
    };
  }
};
</script>

<style scoped>
/* 스타일을 여기에 추가할 수 있습니다. */
</style>
