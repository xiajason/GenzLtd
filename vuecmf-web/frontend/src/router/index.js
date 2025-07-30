import { createRouter, createWebHistory } from 'vue-router';
import Home from '../views/Home.vue';

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  // {{ edit_3: Add other routes your app needs }}
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('../views/NotFound.vue') // Create this component
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

export default router;
