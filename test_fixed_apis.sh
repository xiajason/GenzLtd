#!/bin/bash

echo "测试修复后的权限管理接口..."

# 测试登录接口
echo "1. 测试登录接口..."
login_response=$(curl -s -X POST -H "Content-Type: application/json" -d '{"data":{"login_name":"vuecmf","password":"123456"}}' http://localhost:8082/vuecmf/admin/login)

echo "登录响应: $login_response"

# 提取token
if echo "$login_response" | grep -q "token"; then
    token=$(echo "$login_response" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
    echo "✅ 获取到token: ${token:0:20}..."
else
    echo "❌ 登录失败"
    exit 1
fi

echo ""
echo "2. 测试修复后的管理员权限接口..."

# 测试获取所有角色
echo "测试获取所有角色..."
response=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $token" -d '{"data":{}}' http://localhost:8082/api/admin/get_all_roles)
echo "响应: ${response:0:200}..."

# 测试获取用户角色
echo "测试获取用户角色..."
response=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $token" -d '{"data":{}}' http://localhost:8082/api/admin/get_roles)
echo "响应: ${response:0:200}..."

# 测试获取用户权限
echo "测试获取用户权限..."
response=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $token" -d '{"data":{}}' http://localhost:8082/api/admin/get_user_permission)
echo "响应: ${response:0:200}..."

echo ""
echo "3. 测试修复后的角色管理接口..."

# 测试获取角色下所有用户
echo "测试获取角色下所有用户..."
response=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $token" -d '{"data":{"role_name":"admin"}}' http://localhost:8082/api/roles/get_users)
echo "响应: ${response:0:200}..."

# 测试获取角色下所有权限
echo "测试获取角色下所有权限..."
response=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $token" -d '{"data":{"role_name":"admin"}}' http://localhost:8082/api/roles/get_permission)
echo "响应: ${response:0:200}..."

# 测试获取所有用户
echo "测试获取所有用户..."
response=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $token" -d '{"data":{}}' http://localhost:8082/api/roles/get_all_users)
echo "响应: ${response:0:200}..."

echo ""
echo "4. 测试修复后的菜单导航接口..."

# 测试获取导航菜单
echo "测试获取导航菜单..."
response=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $token" -d '{"data":{}}' http://localhost:8082/api/menu/nav)
echo "响应: ${response:0:200}..."

echo ""
echo "测试完成！" 