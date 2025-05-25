<script setup>
import { ref, onMounted } from 'vue';
import api from '../api';
import { useRouter } from 'vue-router';

const router = useRouter();
const chatrooms = ref([]);
const newChatroomName = ref('');
const loading = ref(true);
const error = ref(null);

const fetchChatrooms = async () => {
  try {
    const response = await api.get('/chatrooms');
    chatrooms.value = response.data;
    loading.value = true;
    error.value = null;
  } catch (e) {
    console.log('Error fetching chatrooms', e);
    error.value = e;
  } finally {
    loading.value = false;
  }
};

const createChatroom = async () => {
  if (!newChatroomName.value.trim()) {
    alert('Please enter a chatroom name');
    return;
  };

  try {
    const response = await api.post('/chatrooms', {
      name: newChatroomName.value,
    });
    chatrooms.value.push(response.data);
    newChatroomName.value = '';
    router.push({ name: 'chatroom', params: { id: response.data.id } });
  } catch (e) {
    console.log('Error creating chatroom', e);
    error.value = 'Failed to create chatroom';
  }
}

const joinChatroom = (id) => {
  router.push({ name: 'chatroom', params: { id } });
  // console.log(id);
}

onMounted(fetchChatrooms);
</script>

<template>
  <div class="max-w-xl mx-auto bg-white p-8 rounded-lg shadow-lg">
    <h1 class="text-3xl font-bold text-center mb-6 text-blue-600">Chatrooms</h1>

    <div v-if="loading" class="text-center text-gray-500">Loading chatrooms...</div>
    <div v-if="error" class="text-center text-red-600">{{ error }}</div>

    <div v-if="!loading && !error">
      <ul class="space-y-4">
        <li v-for="room in chatrooms" :key="room.id"
          class="bg-gray-50 p-4 rounded-md shadow-sm flex justify-between items-center">
          <span class="text-lg font-medium text-gray-800">{{ room.name }}</span>
          <button @click="joinChatroom(room.id)"
            class="bg-blue-500 hover:bg-blue-600 text-white py-2 px-4 rounded-md transition-colors">
            Join
          </button>
        </li>
      </ul>

      <div class="mt-8 pt-6 border-t border-gray-200">
        <h2 class="text-2xl font-bold mb-4 text-blue-600">Create New Chatroom</h2>
        <form @submit.prevent="createChatroom" class="flex space-x-2">
          <input type="text" v-model="newChatroomName" placeholder="Enter new chatroom name" required
            class="flex-grow px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" />
          <button type="submit"
            class="bg-green-500 hover:bg-green-600 text-white py-2 px-4 rounded-md transition-colors">
            Create
          </button>
        </form>
      </div>
    </div>
  </div>
</template>
