<template>
  <div>
    <div class="container">
      <!-- 문제 정보 표시 -->
      <div class="form-group">
        <p class="text-xl-left">{{ data.type }}</p>
        <h3 class="text-xl-left">{{ data.title }}</h3>
        <p class="text-xl-left">{{ data.mainText }}</p>

        <div v-for="(choice, index) in data.choices" :key="index">
          <b class="text-xl-left">{{ choice }}</b>
        </div>
      </div>

      <br>

      <div class="container">
        <!-- 버튼 -->
        <button class="btn btn-info btn-sm mx-1" @click="showAnswer = !showAnswer">
          {{ showAnswer ? '정답 감추기' : '정답 확인하기' }}
        </button>

        <!-- 저장 및 목록으로 돌아가기 -->
        <button v-if="savedQuestion" class="btn btn-success" disabled>저장 완료</button>
        <button v-else type="button" class="btn btn-outline-warning" @click="saveQuestion()">Save Question</button>
        <router-link to="/weekly" class="btn btn-secondary btn-sm">목록으로 돌아가기</router-link>
      </div>

      <br>

      <!-- 정답 및 해설 -->
      <div class="form-group" v-show="showAnswer">
        <p class="text-xl-left">정답: {{ data.answer }}</p>
        <p class="text-xl-left">해석: {{ data.translation }}</p>
        <p class="text-xl-left">해설: {{ data.explanation }}</p>
      </div>

      <br>


    </div>
  </div>
</template>

<script>
import { useQuestionStorage } from '@/piniaStorage/questionStorage';
import {ref} from "vue";
import api from "@/api.js";

export default {
  setup() {
    const showAnswer = ref(false);
    const savedQuestion = ref(false);

    const questionStorage = useQuestionStorage();
    const data = questionStorage.getQuestionData;
    questionStorage.clearQuestionData();

    const saveQuestion = async () => {
      try {
        console.log("Loading...")
        await api.post(`/weekly/${data.qId}/save`);

        savedQuestion.value = true;
      } catch (error) {
        console.log(error);
      }
    }

    return {
      showAnswer,
      savedQuestion,
      data,
      saveQuestion,
    }
  }
};
</script>

<style scoped>
/* 스타일 정의 가능 */
</style>
