#!/bin/bash

echo "🧪 VueCMF 项目 API 测试脚本"
echo "================================"

# 配置
BACKEND_URL="http://localhost:8080"
FRONTEND_URL="http://localhost:8081"

# 颜色输出函数
print_success() {
    echo "✅ $1"
}

print_error() {
    echo "❌ $1"
}

print_info() {
    echo "ℹ️  $1"
}

# 测试后端基础 API
echo ""
echo "1. 测试后端基础 API..."

# 测试健康检查
echo "   测试健康检查接口..."
health_response=$(curl -s -X GET "$BACKEND_URL/api/health")
if [ $? -eq 0 ] && [ -n "$health_response" ]; then
    print_success "健康检查接口正常"
    echo "   响应: $health_response"
else
    print_error "健康检查接口失败"
fi

# 测试 Hello API
echo "   测试 Hello API..."
hello_response=$(curl -s -X GET "$BACKEND_URL/api/hello")
if [ $? -eq 0 ] && [ -n "$hello_response" ]; then
    print_success "Hello API 正常"
    echo "   响应: $hello_response"
else
    print_error "Hello API 失败"
fi

# 测试前端服务
echo ""
echo "2. 测试前端服务..."
frontend_response=$(curl -s -I "$FRONTEND_URL" | head -n 1)
if [ $? -eq 0 ] && echo "$frontend_response" | grep -q "200"; then
    print_success "前端服务正常"
else
    print_error "前端服务异常"
fi

# 测试 VueCMF 特定接口（如果服务可用）
echo ""
echo "3. 测试 VueCMF 特定接口..."

# 测试登录接口（端口 8080，如果服务运行）
vuecmf_url="http://localhost:8080"
login_response=$(curl -s -X POST -H "Content-Type: application/json" \
    -d '{"username":"vuecmf","password":"123456"}' \
    "$vuecmf_url/vuecmf/admin/login" 2>/dev/null)

if [ $? -eq 0 ] && [ -n "$login_response" ]; then
    print_success "VueCMF 登录接口正常"
    echo "   响应: ${login_response:0:100}..."
else
    print_info "VueCMF 登录接口未响应（可能服务未启动）"
fi

# 测试管理员详情接口
admin_response=$(curl -s -X POST -H "Content-Type: application/json" \
    -d '{}' "$vuecmf_url/vuecmf/admin/detail" 2>/dev/null)

if [ $? -eq 0 ] && [ -n "$admin_response" ]; then
    print_success "管理员详情接口正常"
    echo "   响应: ${admin_response:0:100}..."
else
    print_info "管理员详情接口未响应"
fi

# 测试角色列表接口
roles_response=$(curl -s -X POST -H "Content-Type: application/json" \
    -d '{}' "$vuecmf_url/vuecmf/roles/" 2>/dev/null)

if [ $? -eq 0 ] && [ -n "$roles_response" ]; then
    print_success "角色列表接口正常"
    echo "   响应: ${roles_response:0:100}..."
else
    print_info "角色列表接口未响应"
fi

# 测试菜单导航接口
menu_response=$(curl -s -X POST -H "Content-Type: application/json" \
    -d '{}' "$vuecmf_url/vuecmf/menu/nav" 2>/dev/null)

if [ $? -eq 0 ] && [ -n "$menu_response" ]; then
    print_success "菜单导航接口正常"
    echo "   响应: ${menu_response:0:100}..."
else
    print_info "菜单导航接口未响应"
fi

echo ""
echo "📊 测试总结"
echo "============"
echo "• 后端基础 API: 端口 8080"
echo "• 前端服务: 端口 8081"
echo "• VueCMF 业务 API: 端口 8080（已集成）"
echo ""
echo "💡 使用说明:"
echo "1. 启动基础服务: ./start-dev.sh"
echo "2. 启动 VueCMF 服务: go run main.go"
echo "3. 运行测试: ./simple_test.sh"
echo ""
echo "🎯 测试完成！" 