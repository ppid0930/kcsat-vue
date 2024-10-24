<template>
  <div class="container">
    <!-- 데이터가 있을 때만 출력 -->
    <div v-if="data">
      <h6 class="font-nanum-gothic-regular"><span class="font-nanum-gothic-bold">{{ questionTypes.get(data?.questionType) }}</span> 문제 생성 완료</h6>
      <br>

      <div class="font-roman">
        <h4 class="font-nanum-gothic-bold">{{ data?.title }}</h4>

        <p>{{ data?.mainText }}</p>

        <div v-for="(choice, index) in data?.choices" :key="index">
          {{ choice }}
        </div>

        <br>
        <div class="font-nanum-myeongjo-extrabold">정답: {{ data?.answer }}</div>
      </div>

      <br>

      <!-- 버튼 클릭 시 POST 요청 -->
      <button @click="submitForm" class="submitButton btn btn-primary" :disabled="isLoading" style="background-color: #002c62; border-color: #002c62">
        <span v-if="isLoading">
          <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...
        </span>
        <span v-else>해설 생성</span>
      </button>


      <div v-if="isLoading">
        <div v-if="nowOffset > 0">
          <p><b>현재 앞에 {{nowOffset}}</b>명 대기중입니다.</p>
        </div>
        <div v-else-if="nowOffset <= 0">
          <b style="color: green">해설 생성중입니다!!!!!</b>
        </div>
        <div v-else>
          <p>문제 생성 로딩중.......</p>
        </div>
      </div>

    </div>
    <div v-else>
      <p>No data available</p>
    </div>
  </div>
</template>

<script>
import {onUnmounted, ref} from "vue";
import api from "@/api.js";
import router from "@/router/index.js";

import {useQuestionStorage} from "@/piniaStorage/questionStorage.js";


export default {
  setup() {
    const isLoading = ref(false);
    const nowOffset = ref(null); // nowOffset 값 저장
    let intervalId = null; // setInterval ID 관리

    const questionTypes = new Map([
      ['PURPOSE', '글의 목적'],
      ['MAIN_IDEA', '글의 요지'],
      ['TITLE', '글의 제목 추론'],
      ['TOPIC', '글의 주제'],
      ['TARGET_UNMATCH', '대상 정보 불일치'],
      ['FEELING_CHANGE', '화자 심경 변화'],
      ['UNDERLINE', '밑줄 친 구문 의미'],
      ['BLANK', '빈칸 추론'],
      ['BLANK_AB', '빈칸 A,B 추론'],
      ['INFO_MATCH', '안내문 일치'],
      ['INFO_UNMATCH', '안내문 불일치'],
      ['GRAMMAR', '어법'],
      ['SUMMARIZE_AB', '요약문 A,B 추론'],
      ['ORDERING', '이어질 글의 순서 배열'],
      ['ARGUMENT', '필자가 주장하는 바'],
    ]);

    const firstContact = async () => {
      try {
        console.log("First contact")

        await api.get('/question/firstExplanationContact');

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


    const questionStorage = useQuestionStorage();
    const data = questionStorage.getQuestionData;
    questionStorage.clearQuestionData();



    // POST 요청 함수
    const submitForm = async () => {
      isLoading.value = true;
      try {

        await firstContact()


        startNowOffsetLoop();

        const response = await api.post('/question/explanation/LLaMA', data);

        stopNowOffsetLoop();

        // Pinia 스토어에 데이터 저장
        questionStorage.setQuestionData({
          questionType: response.data.questionType,
          title: response.data.title,
          mainText: response.data.mainText,
          choices: response.data.choices,
          answer: response.data.answer,
          translation: response.data.translation,
          explanation: response.data.explanation,
        });

        // 요청 성공 시 페이지 이동
        await router.replace({
          path: '/question/explanation/result',
        })

        // 성공 후 추가 작업 (예: 결과 페이지로 이동)
      } catch (error) {
        console.error('Error submitting data:', error);
        stopNowOffsetLoop();
      } finally {
        isLoading.value = false;
      }
    };


    // 컴포넌트가 언마운트될 때 루프 정리
    onUnmounted(() => {
      stopNowOffsetLoop();
    });

    return {
      data,
      isLoading,
      submitForm,
      nowOffset,
      questionTypes,
    };
  },
};
</script>

<style scoped>
/* 스타일을 여기에 추가할 수 있습니다. */
</style>
