#!/bin/bash

echo "🧪 测试GenzLtd项目服务..."
echo "=========================="

# 测试后端API
echo "1. 测试后端API..."
echo "   测试登录接口..."
login_response=$(curl -s -X POST -H "Content-Type: application/json" -d '{"data":{"login_name":"vuecmf","password":"123456"}}' http://localhost:8082/vuecmf/admin/login)
if echo "$login_response" | grep -q "token"; then
    echo "   ✅ 登录接口正常"
    token=$(echo "$login_response" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
    echo "   🔑 获取到token: ${token:0:20}..."
else
    echo "   ❌ 登录接口异常"
    echo "   响应: ${login_response:0:100}..."
fi

echo ""

# 测试前端页面
echo "2. 测试前端页面..."
echo "   测试首页访问..."
if curl -s -I http://localhost:8081 | grep -q "200 OK"; then
    echo "   ✅ 前端页面正常"
else
    echo "   ❌ 前端页面异常"
fi

echo ""

# 测试数据库连接
echo "3. 测试数据库连接..."
if mysql -u root -e "USE genzltd; SELECT COUNT(*) FROM vuecmf_admin;" >/dev/null 2>&1; then
    echo "   ✅ 数据库连接正常"
    admin_count=$(mysql -u root -e "USE genzltd; SELECT COUNT(*) FROM vuecmf_admin;" 2>/dev/null | tail -1)
    echo "   👥 管理员数量: $admin_count"
else
    echo "   ❌ 数据库连接异常"
fi

echo ""
echo "🎉 服务测试完成！"
echo ""
echo "📋 访问地址:"
echo "   前端: http://localhost:8081"
echo "   后端: http://localhost:8082" 