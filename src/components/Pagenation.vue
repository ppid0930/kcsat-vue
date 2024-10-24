<template>
  <!-- 페이지네이션 -->
  <div v-if="totalPages">
    <ul class="pagination">
      <li :class="{ disabled: isFirstPage }" class="page-item">
        <a class="page-link" @click.prevent="prevPage" aria-label="Previous">
          <span aria-hidden="true">&lt;</span>
        </a>
      </li>

      <li v-for="page in totalPages" :key="page" :class="{ active: page === nowPage }" class="page-item">
        <a class="page-link" @click.prevent="goToPage(page)">{{ page }}</a>
      </li>

      <li :class="{ disabled: isLastPage }" class="page-item">
        <a class="page-link" @click.prevent="nextPage" aria-label="Next">
          <span aria-hidden="true">&gt;</span>
        </a>
      </li>
    </ul>
  </div>
</template>

<script>
import {ref} from "vue";

export default {
  props: {
    totalPages: Number,
    isFirstPage: Boolean,
    isLastPage: Boolean,
  },
  setup() {
    const nowPage = ref(0);


    return {
      
    }
  }
}
</script>

<style lang="scss" scoped>

</style>