<script setup>
import { ref, watch, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import api from '../api';

const router = useRouter();
const route = useRoute();

const isLogin = computed(() => {
  return route.name === 'login';
});

const username = ref('');
const password = ref('');
const passwordConfirmation = ref('');
const errors = ref([]);
const successMessage = ref('');

watch(isLogin, () => {
  username.value = '';
  password.value = '';
  passwordConfirmation.value = '';
  errors.value = [];
  successMessage.value = '';
});

// const login = async () => {
//   try {
//     const response = await api.login(username.value, password.value);
//     localStorage.setItem('token', response.data.token);
//     router.push({ name: 'home' });
//   } catch (error) {
//     errors.value = error.response.data.errors;
//   }
// };

const handleSubmit = async () => {
  errors.value = [];
  successMessage.value = '';
  try {
    let response;
    if (isLogin.value) {
      response = await api.post('/login', {
        username: username.value,
        password: password.value
      });
      successMessage.value = response.data.message;
    } else {
      response = await api.post('/signup', {
        username: username.value,
        password: password.value,
        password_confirmation: passwordConfirmation.value
      });
      successMessage.value = response.data.message;
      // router.push({ name: 'login' });
    }
    localStorage.setItem('token', response.data.token);
    router.push({ name: 'home' });
  } catch (error) {
    errors.value = error.response.data.errors;
  }
}
</script>

<template>
  <div class="max-w-md mx-auto bg-white p-8 rounded-lg shadow-lg">
    <h1 class="text-3xl font-bold text-center mb-6 text-blue-600">
      {{ isLogin ? 'Login' : 'Signup' }}
    </h1>

    <form @submit.prevent="handleSubmit" class="space-y-4">
      <div>
        <label for="username" class="block text-sm font-medium text-gray-700 mb-1">Username:</label>
        <input type="text" id="username" v-model="username" required
          class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" />
      </div>

      <div>
        <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password:</label>
        <input type="password" id="password" v-model="password" required
          class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" />
      </div>

      <div v-if="!isLogin">
        <label for="password_confirmation" class="block text-sm font-medium text-gray-700 mb-1">Confirm
          Password:</label>
        <input type="password" id="password_confirmation" v-model="passwordConfirmation" required
          class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" />
      </div>

      <button type="submit" class="w-full py-3 px-6 rounded-md text-white font-semibold transition-colors duration-200"
        :class="isLogin ? 'bg-blue-600 hover:bg-blue-700' : 'bg-green-600 hover:bg-green-700'">
        {{ isLogin ? 'Login' : 'Signup' }}
      </button>
    </form>

    <div v-if="errors.length" class="mt-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded-md">
      <p class="font-bold">Errors:</p>
      <ul class="list-disc pl-5">
        <li v-for="error in errors" :key="error">{{ error }}</li>
      </ul>
    </div>

    <div v-if="successMessage" class="mt-4 p-3 bg-green-100 border border-green-400 text-green-700 rounded-md">
      {{ successMessage }}
    </div>

    <div class="mt-6 text-center text-gray-600">
      <template v-if="isLogin">
        Don't have an account?
        <router-link to="/signup" class="text-blue-600 hover:underline font-medium">Sign up here</router-link>
      </template>
      <template v-else>
        Already have an account?
        <router-link to="/login" class="text-blue-600 hover:underline font-medium">Login here</router-link>
      </template>
    </div>
  </div>
</template>
