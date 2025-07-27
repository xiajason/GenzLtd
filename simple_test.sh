#!/bin/bash

echo "测试登录接口..."

# 测试登录接口
response=$(curl -s -X POST -H "Content-Type: application/json" -d '{"username":"vuecmf","password":"123456"}' http://localhost:8082/vuecmf/admin/login)

echo "响应内容: $response"

# 检查响应是否为空
if [ -z "$response" ]; then
    echo "❌ 登录接口返回空响应"
else
    echo "✅ 登录接口有响应"
    echo "响应长度: ${#response}"
fi

# 测试其他接口
echo ""
echo "测试其他接口..."

# 测试获取管理员详情
echo "测试获取管理员详情..."
admin_response=$(curl -s -X POST -H "Content-Type: application/json" -d '{}' http://localhost:8082/vuecmf/admin/detail)
echo "管理员详情响应: ${admin_response:0:100}..."

# 测试获取角色列表
echo "测试获取角色列表..."
roles_response=$(curl -s -X POST -H "Content-Type: application/json" -d '{}' http://localhost:8082/vuecmf/roles/)
echo "角色列表响应: ${roles_response:0:100}..."

# 测试获取菜单
echo "测试获取菜单..."
menu_response=$(curl -s -X POST -H "Content-Type: application/json" -d '{}' http://localhost:8082/vuecmf/menu/nav)
echo "菜单响应: ${menu_response:0:100}..."

echo ""
echo "测试完成" 