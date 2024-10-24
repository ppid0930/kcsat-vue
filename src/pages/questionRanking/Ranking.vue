<template>
  <div>
    <div class="container">
      <div v-if="questions.length > 0">
        <!-- 인기 문제 리스트 출력 -->
        <div v-for="(question, index) in questions" :key="question.QId">
          <div>인기 문제 {{ index + 1 }}등!!</div>
          <div>문제 ID: {{ question.QId }}</div>
          <div>
            <p @click="questionDetails(question.QId)">{{question.title}}</p>
          </div>
          <div>문제 본문: {{ question.mainText }}</div>
          <div>문제 공유 카운트: {{ question.shareCounter }}</div>
        </div>
      </div>
      <div v-else>
        <div>인기 문제 집계 중</div>
      </div>
    </div>
  </div>
</template>

<script>
import {onMounted, ref} from "vue";
import api from "@/api.js";
import { useQuestionStorage } from '@/piniaStorage/questionStorage';
import router from "@/router/index.js";


export default {
  setup() {
    const questions = ref([]);
    const isLoading = ref(false);
    const questionStorage = useQuestionStorage();

    const rankedQuestions = async () => {
      isLoading.value = true;
      try {
        // GET 요청으로 질문 리스트를 받아옴
        const response = await api.get('/community/open/weekly');

        // 응답 데이터를 questions에 저장
        questions.value = response.data;
      } catch (error) {
        console.error('Error fetching questions:', error);
      } finally {
        isLoading.value = false;
      }
    };
    
    const questionDetails = async (qId) => {
      try {
        const response = await api.get('/community/question', {params: {
          qId: qId
          }});

        // Pinia 스토어에 데이터 저장
        questionStorage.setQuestionData({
          qId: response.data.qId,
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
          path: `/weekly/${qId}`,
        })
      } catch (error) {
        console.error('Error fetching questions:', error);
      } finally {
        isLoading.value = false;
      }
    }

    // 컴포넌트가 마운트될 때 질문 리스트를 가져옴
    onMounted(() => {
      rankedQuestions();
    });

    return {
      questions,
      isLoading,
      questionDetails,
    };
  }
};
</script>

<style scoped>
/* 스타일을 여기에 추가할 수 있습니다. */
</style>
