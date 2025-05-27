import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useTokenStore = defineStore('token', {
  state: () => ({
    token: ref(localStorage.getItem('token')),
  }),
  getters: {
    getToken: (state) => state.token,
  },
  actions: {
    setToken(token) {
      this.token = token
      localStorage.setItem('token', token)
    },
    removeToken() {
      this.token = null
      localStorage.removeItem('token')
    },
  },
})

// useTokenStore().$watch(
//   (state) => state.token,
//   (newToken) => {
//     console.log(newToken)
//   },
// )
