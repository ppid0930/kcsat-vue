<template>
  <div>
    <div class="container font-nanum-gothic-regular">
      <!-- 검색 폼 -->
<!--      <form @submit.prevent="searchMyBook" class="d-flex">-->
<!--        <input v-model="keyword" class="form-control me-sm-2" type="text" placeholder="Search" />-->
<!--        <button class="btn btn-secondary my-2 my-sm-0" type="submit">Search</button>-->
<!--      </form>-->

      <!-- 게시글 테이블 -->
      <div class="table-responsive">
        <table class="table table-striped table-hover custom-table">
          <thead>
          <tr>
            <th class="col-md-1">번호</th>
            <th class="col-md-2">문제 타입</th>
            <th class="col-md-4">문제 본문</th>
            <th class="col-md-2">저장일</th>
            <th class="col-md-1">퍼간 횟수</th>
          </tr>
          </thead>
          <tbody>
          <tr v-if="book" v-for="(myQuestion, index) in book.question" :key="index">
            <td class="text-center align-middle">{{ index + 1 }}</td>
            <td class="text-center align-middle">{{ myQuestion.questionType }}</td>
            <td>
              <div @click="questionDetails(myQuestion.qid)">{{ truncateText(myQuestion.mainText, 150) }}</div>
            </td>
            <td class="text-center align-middle">{{ formatDate(myQuestion.createdDate) }}</td>
            <td class="text-center align-middle">{{ myQuestion.shareCounter }}</td>
          </tr>
          </tbody>
        </table>
      </div>

      <br>
    </div>
  </div>
</template>

<script>
import api from "@/api.js";
import router from "@/router/index.js";
import {onMounted, ref} from "vue";
import {useBookStorage} from "@/piniaStorage/bookStorage.js";
import {useQuestionStorage} from "@/piniaStorage/questionStorage.js";

export default {
  setup() {
    const bookStorage = useBookStorage();
    const book = ref(null);

    const questionStorage = useQuestionStorage();


    // 문제 제목을 30자까지만 표시하고 '...'을 붙이는 함수
    const truncateText = (text, maxLength) => {
      return text.length > maxLength ? text.slice(0, maxLength) + '...' : text;
    };

    const getMyBook = async () => {
      try {
        const response = await api.get('/community/myBook');
        book.value = response.data;

        bookStorage.setBookData(book.value);

      } catch (error) {

      }
    }

    const questionDetails = async (qid) => {
      try {
        const response = await api.get('/community/question', {params: {
            qId: qid
          }});

        // Pinia 스토어에 데이터 저장
        questionStorage.setQuestionData({
          qid: response.data.qid,
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
          path: `/myBook/${qid}`,
        })
      } catch (error) {
        console.error('Error fetching questions:', error);
      }
    }

    const formatDate = (dateString) => {
      const date = new Date(dateString);
      return date.toLocaleDateString('ko-KR'); // 한국식 연-월-일 형식
    }

    // 컴포넌트가 마운트될 때 질문 리스트를 가져옴
    onMounted(() => {
      if (book.value === null) {
        getMyBook(); // 초기 값이 null일 때 데이터 가져오기
      } else {
        book.value = bookStorage.getBookData;
      }
    });

    return {
      book,
      truncateText,
      questionDetails,
      formatDate
    }
  }
};
</script>

<style scoped>
.custom-table th {
  background-color: #000000; /* 헤더 배경색 */
  color: white; /* 헤더 글자 색 */
  text-align: center; /* 중앙 정렬 */
}

.custom-table tbody tr:hover {
  background-color: #f2f4f8; /* 행 호버 효과 */
}

.custom-table td {
  vertical-align: middle; /* 텍스트 수직 정렬 */
  padding: 12px; /* 여백 조정 */
}

.custom-table {
  border-radius: 10px; /* 테이블 모서리 곡선 */
  overflow: hidden; /* 둥근 모서리에서 테두리가 넘치지 않게 */
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
}
</style>
