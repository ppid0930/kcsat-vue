<template>
  <div>
    <div class="container">
      <!-- 문제 업로드 버튼 -->
      <button type="button" @click="getMyBook">문제 업로드</button>

      <!-- 문제 선택 여부에 따른 조건부 렌더링 -->
      <div v-if="questionData">
        <p>{{ questionData.qid }}</p>
        <p>{{ questionData.questionType }}</p>
        <p>{{ questionData.title }}</p>
        <p>{{ questionData.mainText }}</p>
        <div v-for="choice in questionData.choices" :key="choice">
          <p>{{ choice }}</p>
        </div>
        <p>{{ questionData.shareCounter }}</p>
      </div>

      <!-- 게시글 작성 폼 -->
      <form @submit.prevent="newPost">
        <div class="form-group">
          <label class="form-label mt-4">게시글 작성</label>

          <div class="form-floating mb-3">
            <label for="title">제목</label>
            <input type="text" v-model.trim="title" class="form-control" id="title" required />
          </div>

          <div class="form-floating mb-3">
            <label for="content">내용</label>
            <textarea v-model="content" class="form-control" id="content" rows="3" style="height: 500px;" required></textarea>
          </div>
        </div>

        <button type="submit" class="btn btn-primary">등록</button>
      </form>
    </div>

    <br />
  </div>
</template>

<script>
import {ref} from "vue";
import {useQuestionSelectStorage} from "@/piniaStorage/questionSelectStorage.js";
import api from "@/api.js";
import {usePostStorage} from "@/piniaStorage/postStorage.js";
import router from "@/router/index.js";
import {useBookStorage} from "@/piniaStorage/bookStorage.js";

export default {
  setup() {
    const questionSelectStorage = useQuestionSelectStorage();
    const postStorage = usePostStorage();
    const bookStorage = useBookStorage();
    const questionData = questionSelectStorage.getQuestionSelectData;
    const qId = questionData === null ? null : questionData.qid;
    const title = ref("");
    const content = ref("");


    const newPost = async () => {

      const data = {
        title: title.value,
        content: content.value,
        qid: qId === null ? null : qId,
      }

      console.log(data)

      try {
        const response = await api.post("/community/board/post/new", data);
        questionSelectStorage.clearQuestionSelectData();

        postStorage.setPostData(response.data);


        // 요청 성공 시 페이지 이동
        await router.replace({
          path: `/board/post/${response.data.post.pid}`,
        })
      } catch (error) {
        console.log(error);
      }
    }

    const getMyBook = async () => {
      try {
        const response = await api.get('/community/myBook');

        if (!response.data || !response.data.question || response.data.question.length === 0) {
          alert("저장된 문제가 없습니다.");
          return;
        }

        bookStorage.setBookData(response.data);

        // 요청 성공 시 페이지 이동
        await router.replace({
          path: "/board/post/myQuestions",
        })
      } catch (error) {
        console.log(error);
      }
    }

    return {
      questionData,
      title,
      content,
      newPost,
      getMyBook,
    }
  }
};
</script>

<style scoped>
/* 스타일을 여기에 추가할 수 있습니다. */
</style>
