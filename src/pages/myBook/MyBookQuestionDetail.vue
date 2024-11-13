<template>
  <div>
    <div class="container font-nanum-gothic-regular">
      <p class="text-xl-left">{{ questionTypes.get(data?.questionType) }}</p>

      <div class="form-group font-roman">
        <h3 class="text-xl-left font-nanum-gothic-bold">{{ data.title }}</h3>
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
        <p class="text-xl-left font-nanum-myeongjo-extrabold">정답 : {{ data.answer }}</p>
        <p class="text-xl-left"><span class="font-nanum-myeongjo-extrabold">번역 : </span>{{ data.translation }}</p>
        <p class="text-xl-left"><span class="font-nanum-myeongjo-extrabold">해설 : </span>{{ data.explanation }}</p>
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

    // onMounted(() => {
    //   data.value = ;
    // })

    return {
      showAnswer,
      data,
      questionTypes,
    }
  }
};
</script>

<style scoped>
/* 스타일 정의 가능 */
</style>
