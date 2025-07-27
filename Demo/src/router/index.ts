// +----------------------------------------------------------------------
// | Copyright (c) 2019~2024 http://www.vuecmf.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://github.com/vuecmf/vuecmf-web/blob/main/LICENSE )
// +----------------------------------------------------------------------
// | Author: vuecmf.com <tulihua2004@126.com>
// +----------------------------------------------------------------------

import {createRouter, createWebHashHistory, createWebHistory} from 'vue-router'
import type {RouteRecordRaw} from 'vue-router'
import { useStore } from '@/stores';
import LayoutService from "@/service/LayoutService"
import { ElMessage } from 'element-plus'


const service = new LayoutService()

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'home',
    component: () => import('@/views/Layout.vue'),
    redirect: 'welcome',
    children: [
      {
        path: 'welcome',
        component: () => import('@/views/Welcome.vue'),
        name: 'welcome',
        meta: { breadcrumb_list: ['欢迎页'], title: 'welcome! - Powered by www.vuecmf.com', icon: 'welcome', noCache: true,topId:0, id:0, token:'123'}
      },
    ]
  },
  {
    path: '/login',
    component: () => import('@/views/Login.vue'),
    name: 'login',
    meta: { title: '登录系统 - Powered by www.vuecmf.com', icon: 'welcome', noCache: true,topId:0, id:0}
  },
  {
    path:'/refresh',
    component: () => import('@/views/Refresh.vue'),
  },
]

/**
 * 创建路由
 */
const router = createRouter({
  history: import.meta.env.MODE === 'production' ? createWebHistory(import.meta.env.BASE_URL) : createWebHashHistory(import.meta.env.BASE_URL),
  routes
})

/**
 * 进入路由前
 */
router.beforeEach( async (to,from, next) => {
  const token = localStorage.getItem('vuecmf_token')
  const store = useStore()
  
  if(to.name == 'login'){
    // 如果已经登录，访问登录页面时重定向到首页
    if(token && token !== '' && token !== null){
      next({name:'welcome'});
      return;
    }
    next()
    return;
  }
  
  // 检查是否有token
  if(token == '' || token == null){
    ElMessage.error('还没有登录或登录超时,请先登录！')
    next({name:'login'});
    return;
  }
  
  // 验证token有效性 - 使用admin列表API来验证token
  try {
    const response = await fetch(`${import.meta.env.VITE_APP_BASE_API}/vuecmf/admin/`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'token': token
      },
      body: `action=index`
    });
    
    const result = await response.json();
    
    if(result.code !== 0){
      // token无效，清除本地存储并跳转到登录页
      localStorage.clear();
      ElMessage.error('登录已过期，请重新登录！')
      next({name:'login'});
      return;
    }
    
    // token有效，继续处理路由
    if(to.name !== 'welcome' && store.nav_menu_list.length == 0){
      service.loadMenu().then((res:string|void)=> {
        res === 'router loaded' ? next({ path: to.path, query: to.query }) : next()
      })
    }else{
      next()
    }
    
  } catch (error) {
    // 网络错误或其他错误，清除本地存储并跳转到登录页
    localStorage.clear();
    ElMessage.error('网络错误，请重新登录！')
    next({name:'login'});
  }
})


export default router
