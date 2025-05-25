import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
// import LoginView from '../views/AboutView.vue'
// import ChatroomView from '../views/ChatroomView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('../views/LoginView.vue'),
    },
    {
      path: '/signup',
      name: 'signup',
      component: () => import('../views/LoginView.vue'),
    },
    {
      path: '/chatroom/:id',
      name: 'chatroom',
      component: () => import('../views/ChatroomView.vue'),
      meta: {
        requiresAuth: true
      },
      props: true
    },
    {
      path: '/:catchAll(.*)',
      name: 'NotFound',
      // component: () => import('../views/NotFound.vue'),
      redirect: { name: 'home' }
    }
    // {
    //   path: '/about',
    //   name: 'about',
    //   // route level code-splitting
    //   // this generates a separate chunk (About.[hash].js) for this route
    //   // which is lazy-loaded when the route is visited.
    //   component: () => import('../views/AboutView.vue'),
    // },
  ],
})

router.beforeEach((to, from, next) => {
  if (to.meta.requiresAuth && !localStorage.getItem('token')) {
    next({ name: 'login' })
  } else if ((to.name === 'login' || to.name === 'signup') && localStorage.getItem('token')) {
    next({ name: 'home' })
  } else {
    next()
  }
})

export default router
