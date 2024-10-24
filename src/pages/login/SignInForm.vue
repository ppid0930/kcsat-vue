<template>
  <div>
    <div class="container">
      <form @submit.prevent="signIn">
        <div class="form-group">
          <label class="form-label mt-4">로그인</label>

          <!-- 이메일 입력 -->
          <div class="form-floating mb-3" :class="{ 'has-danger': error }">
            <input
                type="email"
                v-model="email"
                class="form-control"
                :class="{ 'is-invalid': error }"
                id="floatingInput"
                placeholder="name@example.com"
            />
            <label for="floatingInput">Email address</label>
            <div v-if="error" class="invalid-feedback">
              이메일 혹은 비밀번호가 잘못 되었습니다.
            </div>
          </div>

          <!-- 비밀번호 입력 -->
          <div class="form-floating mb-4">
            <input
                type="password"
                v-model="password"
                class="form-control"
                id="floatingPassword"
                placeholder="Password"
            />
            <label for="floatingPassword">Password</label>
          </div>
        </div>

        <!-- 로그인 및 회원 가입 버튼 -->
        <button type="submit" class="btn btn-primary">Log in</button>
        <button
            type="button"
            class="btn btn-outline-primary"
        >
          <router-link to="/signup" style="text-decoration: none">회원 가입</router-link>
        </button>
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
    const password = ref("");
    const error = ref(false);


    const signIn = async () => {
      try {
        const payload = {
          userEmail: email.value,
          password: password.value,
        };

        const response = await api.post("/community/open/signIn", payload);

        const token = response.data;

        localStorage.setItem('jwt', token);

        // 페이지를 완전히 새로고침하여 헤더/푸터 포함 모든 것을 리셋
        window.location.href = '/';
      } catch (error) {
        error.value = true;
      }
    };

    return {
      error,
      email,
      password,
      signIn
    }
  }
};
</script>

<style scoped>
/* 스타일을 여기에 추가할 수 있습니다. */
</style>
