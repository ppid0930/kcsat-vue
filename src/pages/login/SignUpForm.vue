<template>
  <div>
    <div class="container">
      <form @submit.prevent="submitForm">
        <!-- 이메일 입력 -->
        <div class="form-group">
          <label for="email" class="form-label mt-4">이메일 입력</label>
          <input
              type="text"
              v-model="email"
              class="form-control"
              id="email"
              placeholder="이메일을 입력하세요."
          />

          <!-- 닉네임 입력 -->
          <label for="username" class="form-label mt-4">닉네임 입력</label>
          <input
              type="text"
              v-model="username"
              class="form-control"
              id="username"
              placeholder="닉네임을 입력하세요."
          />

          <!-- 비밀번호 입력 -->
          <label for="password" class="form-label mt-4">비밀번호 입력</label>
          <input
              type="password"
              v-model="password"
              class="form-control"
              id="password"
              placeholder="비밀번호를 입력하세요."
          />
        </div>

        <!-- 제출 버튼 -->
        <button type="submit" class="btn btn-primary">Submit</button>
      </form>
      <br />
    </div>
  </div>
</template>

<script>
import {ref} from "vue";
import api from "@/api.js";

export default {
  setup() {
    const email = ref("");
    const username = ref("");
    const password = ref("");
    const error = ref(false);

    const submitForm = async () => {
      try {
        const payload = {
          email: email.value,
          username: username.value,
          password: password.value,
        };

        await api.post("/community/open/signUp", payload);

        alert("회원가입 되었습니다 :)");

        // 페이지를 완전히 새로고침하여 헤더/푸터 포함 모든 것을 리셋
        window.location.href = '/login';
      } catch (error) {
        error.value = true;
      }
    }

    return {
      email,
      username,
      password,
      error,
      submitForm
    }
  }
};
</script>

<style scoped>
/* 필요한 스타일을 여기에 추가할 수 있습니다. */
</style>
