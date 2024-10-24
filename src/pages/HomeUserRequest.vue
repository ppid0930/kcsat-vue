<template>
  <div>
    <div class="container">
      <div class="jumbotron">
        <h3 class="nav-item">운영자에게 건의 사항</h3>
        <form>
          <!-- 건의 사항 입력 -->
          <div class="form-group">
            <textarea
                v-model="content"
                class="form-control"
                id="content"
                placeholder="개선하면 좋아질 부분을 적어 주세요! ❤️"
                rows="5"
            ></textarea>
          </div>
          <!-- 제출 버튼 -->
          <button type="button" class="btn btn-primary" @click="postRequest()">제출</button>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import api from "@/api.js"
import {ref} from "vue";
import router from "@/router/index.js";

export default {
  setup() {
    const content = ref("");

    const postRequest = async () => {
      try {
        const payload = {
          content: content.value,
        };

        await api.post("/community/improving", payload);

        alert("의견 감사합니다 :)\n앞으로 더욱 발전된 모습 보여드리겠습니다.")

        // 요청 성공 시 페이지 이동
        await router.replace({path: '/'});
      } catch (error) {
        console.log(error);
      }
    };

    return {
      content,
      postRequest
    }
  }
};
</script>

<style scoped>
/* 스타일을 여기에 추가할 수 있습니다. */
</style>
