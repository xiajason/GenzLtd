import { createApp } from 'vue';
import App from './App.vue';
import router from './router'; // {{ edit_1: Import the router }}

createApp(App)
  .use(router) // {{ edit_2: Use the router }}
  .mount('#app');