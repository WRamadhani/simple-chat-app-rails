<script setup>
import { ref, onMounted, onUnmounted, nextTick } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import api from '../api';
import { createChatConsumer } from '../cable';

import ChatMessage from '../components/ChatMessage.vue';

const route = useRoute();
const router = useRouter();

const chatroom = ref(null);
const messages = ref([]);
const newMessageContent = ref('');
const loading = ref(true);
const error = ref(null);
const currentUser = ref(null);

let chatChannel = null;

const messagesContainer = ref(null);

const fetchCurrentUser = async () => {
  try {
    const response = await api.get('/profile');
    currentUser.value = response.data;
  } catch (e) {
    console.log('Error fetching current user', e);
    error.value = e;
    router.push({ name: 'login' });
  }
}

const fetchChatroomDetails = async () => {
  try {
    loading.value = true;
    error.value = null;
    const response = await api.get(`/chatrooms/${route.params.id}`);
    chatroom.value = response.data.chatroom;
    messages.value = response.data.messages;
    await nextTick();
    scrollToBottom();
  } catch (e) {
    console.log('Error fetching chatroom details', e);
    error.value = e;
    router.push({ name: 'home' });
  } finally {
    loading.value = false;
  }
}

const subscribeToChatroom = () => {
  const consumer = createChatConsumer();
  if (!consumer) {
    router.push({ name: 'login' });
    return;
  }

  chatChannel = consumer.subscriptions.create(
    { channel: 'ChatChannel', id: route.params.id },
    {
      received: (data) => {
        console.log('Received real-time message: ', data);
        messages.value.push(data.message);
        nextTick(() => scrollToBottom());
      },
      initialized: () => {
        console.log('Chat channel initialized');
      },
      connected: () => {
        console.log('Chat channel connected', consumer);
      },
      disconnected: () => {
        console.log('Chat channel disconnected');
      },
      rejected: () => {
        console.log('Chat channel rejected');
        error.value = 'Failed to join chatroom';
        router.push({ name: 'home' });
      }
    }
  );
}

const sendMessage = () => {
  console.log('clicked');
  console.log(newMessageContent.value);
  if (newMessageContent.value.trim() === '') return;

  if (chatChannel) {
    chatChannel.perform('speak', { message: newMessageContent.value });
    newMessageContent.value = '';
  } else {
    console.error('Chat channel not connected');
    alert('Failed to send message');
  }
}

const scrollToBottom = () => {
  if (messagesContainer.value) {
    messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight;
  }
};

onMounted(async () => {
  await fetchCurrentUser();
  if (!currentUser.value) {
    router.push({ name: 'login' });
    return;
  }
  await fetchChatroomDetails();
  subscribeToChatroom();
});

onUnmounted(() => {
  if (chatChannel) {
    chatChannel.unsubscribe();
    console.log('Chat channel unsubscribed');
  }
});
</script>

<template>
  <div class="max-w-2xl mx-auto bg-white rounded-lg shadow-lg flex flex-col h-[80vh]">
    <div class="p-4 border-b border-gray-200 bg-blue-600 text-white rounded-t-lg">
      <h1 class="text-2xl font-bold">{{ chatroom ? chatroom.name : 'Loading Chat...' }}</h1>
      <p>{{ currentUser ? currentUser.username : 'Loading User...' }}</p>
    </div>

    <div v-if="loading" class="flex-grow flex items-center justify-center text-gray-500">
      Loading messages...
    </div>
    <div v-else-if="error" class="flex-grow flex items-center justify-center text-red-600 p-4">
      {{ error }}
    </div>
    <div v-else class="p-4 overflow-y-auto flex-grow" ref="messagesContainer">
      <ChatMessage v-for="message in messages" :key="message.id" :message="message"
        :isCurrentUser="currentUser.user.id === message.user.id" />
      <div v-if="messages.length === 0" class="text-center text-gray-500 py-10">
        No messages yet. Be the first to say hi!
      </div>
    </div>

    <form @submit.prevent="sendMessage" class="p-4 border-t border-gray-200 flex gap-4">
      <input type="text" v-model="newMessageContent" placeholder="Type your message..." required
        class="flex-grow px-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-blue-500" />
      <button type="submit"
        class="bg-blue-600 cursor-pointer hover:bg-blue-700 text-white py-2 px-5 ml-2 rounded-full font-semibold transition-colors">
        Send
      </button>
    </form>
  </div>
</template>

<style scoped>
.h-80vh {
  height: 80vh;
}
</style>
