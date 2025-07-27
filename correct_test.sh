#!/bin/bash

echo "测试登录接口（使用正确的参数）..."

# 测试登录接口 - 使用正确的参数
response=$(curl -s -X POST -H "Content-Type: application/json" -d '{"data":{"login_name":"vuecmf","password":"123456"}}' http://localhost:8082/vuecmf/admin/login)

echo "响应内容: $response"

# 检查响应是否为空
if [ -z "$response" ]; then
    echo "❌ 登录接口返回空响应"
else
    echo "✅ 登录接口有响应"
    echo "响应长度: ${#response}"
    
    # 尝试提取token
    if echo "$response" | grep -q "token"; then
        token=$(echo "$response" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
        echo "✅ 获取到token: ${token:0:20}..."
        
        # 使用token测试其他接口
        echo ""
        echo "使用token测试其他接口..."
        
        # 测试获取管理员详情
        echo "测试获取管理员详情..."
        admin_response=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $token" -d '{"data":{}}' http://localhost:8082/vuecmf/admin/detail)
        echo "管理员详情响应: ${admin_response:0:200}..."
        
        # 测试获取角色列表
        echo "测试获取角色列表..."
        roles_response=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $token" -d '{"data":{}}' http://localhost:8082/vuecmf/roles/)
        echo "角色列表响应: ${roles_response:0:200}..."
        
        # 测试获取菜单
        echo "测试获取菜单..."
        menu_response=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $token" -d '{"data":{}}' http://localhost:8082/vuecmf/menu/nav)
        echo "菜单响应: ${menu_response:0:200}..."
        
        # 测试获取应用配置
        echo "测试获取应用配置..."
        app_config_response=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $token" -d '{"data":{}}' http://localhost:8082/vuecmf/app_config/)
        echo "应用配置响应: ${app_config_response:0:200}..."
        
        # 测试获取模型配置
        echo "测试获取模型配置..."
        model_config_response=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $token" -d '{"data":{}}' http://localhost:8082/vuecmf/model_config/)
        echo "模型配置响应: ${model_config_response:0:200}..."
        
    else
        echo "❌ 响应中没有找到token"
    fi
fi

echo ""
echo "测试完成" 