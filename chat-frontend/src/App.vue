<script setup>
import { RouterLink, RouterView, useRouter } from 'vue-router'
import { useTokenStore } from './stores/tokenStore';
// import HelloWorld from './components/HelloWorld.vue'

const router = useRouter();

const tokenStore = useTokenStore();

const logout = () => {
  tokenStore.removeToken();
  router.push({ name: 'login' });
}
// const currentRoute = computed(() => {
//   return router.currentRoute.value;
// });
</script>

<template>
  <header class="bg-blue-600 text-white p-4 shadow-md">
    <nav class="container mx-auto flex justify-between items-center">
      <RouterLink to="/" class="text-xl font-bold">RailsVueChat</RouterLink>
      <div class="flex space-x-4">
        <template v-if="tokenStore.token">
          <button @click="logout" class="py-2 px-4 bg-red-500 rounded-md hover:bg-red-600 transition-colors">
            Logout
          </button>
        </template>
        <template v-else>
          <RouterLink to="/login" class="py-2 px-4 bg-blue-700 rounded-md hover:bg-blue-800 transition-colors">
            Login
          </RouterLink>
          <RouterLink to="/signup" class="py-2 px-4 bg-green-500 rounded-md hover:bg-green-600 transition-colors">
            Signup
          </RouterLink>
        </template>
      </div>
    </nav>
  </header>

  <main class="container mx-auto p-4 mt-4">
    <RouterView />
  </main>
</template>

<style scoped>
/* header {
  line-height: 1.5;
  max-height: 100vh;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
}

nav {
  width: 100%;
  font-size: 12px;
  text-align: center;
  margin-top: 2rem;
}

nav a.router-link-exact-active {
  color: var(--color-text);
}

nav a.router-link-exact-active:hover {
  background-color: transparent;
}

nav a {
  display: inline-block;
  padding: 0 1rem;
  border-left: 1px solid var(--color-border);
}

nav a:first-of-type {
  border: 0;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }

  nav {
    text-align: left;
    margin-left: -1rem;
    font-size: 1rem;

    padding: 1rem 0;
    margin-top: 1rem;
  }
} */
</style>
