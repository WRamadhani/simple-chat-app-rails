<script setup>
import { computed } from 'vue';

const props = defineProps({
  message: {
    type: Object,
    required: true,
    validator: (value) => {
      return value.id && value.content && value.user.username && value.created_at;
    }
  },
  isCurrentUser: {
    type: Boolean,
    required: false,
    default: false
  }
});

const formattedDate = computed(() => {
  const date = new Date(props.message.created_at);
  return date.toLocaleString([], {
    hour: '2-digit',
    minute: '2-digit'
  });
});

const messageClass = computed(() => {
  return props.isCurrentUser
    ? 'bg-blue-500 text-white self-end rounded-br-none'
    : 'bg-gray-200 text-gray-800 self-start rounded-bl-none';
})
console.log(props.isCurrentUser);
</script>

<template>
  <div class="flex flex-col pb-4" :class="{ 'items-end': isCurrentUser, 'items-start': !isCurrentUser }">
    <div class="max-w-[70%] p-3 rounded-xl shadow-sm break-words" :class="messageClass">
      <div class="flex items-baseline gap-2" :class="{ 'flex-row-reverse': isCurrentUser }">
        <strong class="text-sm font-semibold">{{ message.user.username }}</strong>
        <span class="text-xs opacity-75">{{ formattedDate }}</span>
      </div>
      <p class="text-base pt-2">{{ message.content }}</p>
    </div>
  </div>
</template>
