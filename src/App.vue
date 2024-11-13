<template>
  <div class="min-vh-85 bg-light" style="border-bottom: 1px solid #ddd;">
    <div style="border-bottom: 1px solid #ddd;">
      <div class="container-fluid">
        <Header></Header>
      </div>
    </div>
    <div class="container-fluid">

      <br>
      <div class="container custom-container" style="max-width: 1100px">
        <router-view></router-view>
      </div>
      <br>
      <br>


    </div>


  </div>
  <div class="container-fluid">
    <Footer></Footer>
  </div>


</template>

<script>
import Header from "@/components/Header.vue";
import Footer from "@/components/Footer.vue";

export default {
  components: {Footer, Header},
  setup() {
    return {
    }
  }
}
</script>

<style scoped>
.min-vh-85 {
  min-height: 85vh; /* 화면 높이의 80% */
}
.custom-container {
  border: 2px solid #ddd; /* 테두리 색상 */
  border-radius: 10px; /* 곡선 정도 */
  padding: 50px; /* 내부 여백 */
  background-color: #f2f2f2; /* 배경 색상 */
  //box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
}
.container-fluid {
  max-width: 1150px;
}
</style>