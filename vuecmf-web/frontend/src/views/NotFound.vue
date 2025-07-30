<template>
  <div class="not-found">
    <h1>404 - Page Not Found</h1>
    <p>The requested page does not exist.</p>
    <router-link to="/">Return to Home</router-link>
  </div>
</template>

<script>
export default {
  name: 'NotFoundView'
}
</script>

<style scoped>
.not-found {
  text-align: center;
  padding: 2rem;
}

.not-found a {
  color: #42b983;
  text-decoration: none;
}

.not-found a:hover {
  text-decoration: underline;
}
</style>
