# 创建主应用文件
<template>
  <div id="app">
    <h1>VueCMF 前端应用</h1>
    <p>后端 API 状态: {{ apiStatus }}</p>
    <p v-if="apiMessage" :class="apiStatus === '异常' ? 'error' : ''">{{ apiMessage }}</p>
    <router-view />
  </div>
</template>

<script>
import { ref, onMounted, watchEffect } from 'vue';
import axios from 'axios';
import { useRouter } from 'vue-router';
import { useRoute } from 'vue-router'; // {{ edit_3: Import useRoute }}

export default {
  name: 'App',
  setup() {
    const apiStatus = ref('loading...');
    const apiMessage = ref('');
    const router = useRouter();
    
    // 封装API请求
    const checkBackendStatus = async () => {
      try {
        const response = await axios.get('/vuecmf/hello', { 
          timeout: 5000  // 添加超时处理
        });
        apiStatus.value = '正常';
        apiMessage.value = response.data.message;
      } catch (error) {
        apiStatus.value = '异常';
        apiMessage.value = error.response?.data?.message || '无法连接到后端服务';
        console.error('后端连接错误:', error);
      }
    };
    
    // 组件挂载时检查后端状态
    onMounted(() => {
      checkBackendStatus();
      
      // 添加定期检查机制
      const interval = setInterval(checkBackendStatus, 30000);
      
      // 组件卸载时清理
      return () => clearInterval(interval);
    });
    
    // 添加路由守卫，未登录时重定向到登录页
    watchEffect(() => {
      const isAuthenticated = localStorage.getItem('token');
      const currentPath = router.currentRoute.value.path;
      
      if (!isAuthenticated && currentPath !== '/login') {
        router.push('/login');
      }
    });

    return {
      apiStatus,
      apiMessage
    };
  }
};
</script>

<style scoped>
.error {
  color: #f56c6c;
}
</style>

<script setup>
import { ref, watch } from 'vue';
import { useRoute } from 'vue-router'; // {{ edit_3: Import useRoute }}

// {{ edit_4: Get route using composable }}
const route = useRoute();

// Replace any direct router access with route
watch(
  () => route.path, // {{ edit_5: Watch route.path instead of router.currentRoute }}
  (newPath) => {
    console.log('Route changed to:', newPath);
    // Update your logic accordingly
  }
);
</script>