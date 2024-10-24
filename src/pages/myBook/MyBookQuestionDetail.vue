<template>
  <div>
    <div class="container">
      <div class="form-group">
        <p class="text-xl-left">{{ data.questionType }}</p>
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

        <router-link class="btn btn-secondary btn-sm" to="/myBook">목록으로 돌아가기</router-link>
      </div>

      <br>

      <!-- 정답 및 해설을 보여주는 부분 -->
      <div class="form-group" v-show="showAnswer">
        <p class="text-xl-left">정답 : {{ data.answer }}</p>
        <p class="text-xl-left">해석 : {{ data.translation }}</p>
        <p class="text-xl-left">해설 : {{ data.explanation }}</p>
      </div>
    </div>
  </div>
</template>

<script>
import { useQuestionStorage } from '@/piniaStorage/questionStorage';
import {ref} from "vue";

export default {
  setup() {
    const showAnswer = ref(false);

    const questionStorage = useQuestionStorage();
    const data = questionStorage.getQuestionData;
    questionStorage.clearQuestionData();

    // onMounted(() => {
    //   data.value = ;
    // })

    return {
      showAnswer,
      data
    }
  }
};
</script>

<style scoped>
/* 스타일 정의 가능 */
</style>
