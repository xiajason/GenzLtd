<template>
  <div class="login-container">
    <h2>用户登录</h2>
    <form @submit.prevent="handleLogin">
      <div class="form-group">
        <label>用户名</label>
        <input 
          v-model="username" 
          type="text" 
          required
          placeholder="请输入用户名"
        >
      </div>
      <div class="form-group">
        <label>密码</label>
        <input 
          v-model="password" 
          type="password" 
          required
          placeholder="请输入密码"
        >
      </div>
      <button type="submit" class="login-btn">登录</button>
      <div v-if="message" class="message">{{ message }}</div>
    </form>
  </div>
</template>

<script>
import { ref } from 'vue';
import axios from 'axios';

export default {
  name: 'Login',
  setup() {
    const username = ref('');
    const password = ref('');
    const message = ref('');

    const handleLogin = async () => {
      try {
        const response = await axios.post('/api/login', {
          username: username.value,
          password: password.value
        });
        
        if (response.data.status === 'success') {
          message.value = '登录成功！';
          // 这里可以添加路由跳转逻辑
        } else {
          message.value = response.data.message || '登录失败';
        }
      } catch (error) {
        message.value = '网络错误，请检查后端服务是否运行';
        console.error('登录请求失败:', error);
      }
    };

    return {
      username,
      password,
      message,
      handleLogin
    };
  }
};
</script>

<style scoped>
.login-container {
  max-width: 300px;
  margin: 50px auto;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 5px;
}
.form-group {
  margin-bottom: 15px;
}
input {
  width: 100%;
  padding: 8px;
  margin-top: 5px;
  border: 1px solid #ddd;
  border-radius: 3px;
}
.login-btn {
  width: 100%;
  padding: 10px;
  background: #42b983;
  color: white;
  border: none;
  border-radius: 3px;
  cursor: pointer;
}
.message {
  margin-top: 15px;
  color: #f56c6c;
  text-align: center;
}
</style>