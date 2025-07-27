#!/bin/bash

echo "🔍 检查GenzLtd项目服务状态..."
echo "=================================="

# 检查MySQL数据库
echo "1. 检查MySQL数据库..."
if mysql -u root -e "SELECT 1;" >/dev/null 2>&1; then
    echo "✅ MySQL数据库运行正常"
    mysql -u root -e "SHOW DATABASES;" | grep genzltd >/dev/null && echo "✅ genzltd数据库存在"
else
    echo "❌ MySQL数据库连接失败"
fi

echo ""

# 检查后端服务
echo "2. 检查后端服务 (端口8082)..."
if curl -s http://localhost:8082/home >/dev/null 2>&1; then
    echo "✅ 后端服务运行正常"
    echo "   📍 访问地址: http://localhost:8082"
else
    echo "❌ 后端服务未运行"
fi

echo ""

# 检查前端服务
echo "3. 检查前端服务 (端口8081)..."
if curl -s http://localhost:8081 >/dev/null 2>&1; then
    echo "✅ 前端服务运行正常"
    echo "   📍 访问地址: http://localhost:8081"
else
    echo "❌ 前端服务未运行"
fi

echo ""

# 检查端口占用
echo "4. 端口占用情况..."
echo "   8081端口: $(lsof -i :8081 2>/dev/null | wc -l | tr -d ' ') 个进程"
echo "   8082端口: $(lsof -i :8082 2>/dev/null | wc -l | tr -d ' ') 个进程"

echo ""
echo "🎉 服务状态检查完成！"
echo ""
echo "📋 访问地址汇总:"
echo "   前端界面: http://localhost:8081"
echo "   后端API:  http://localhost:8082"
echo "   数据库:   MySQL (localhost:3306)"
echo ""
echo "🔧 如果需要启动服务:"
echo "   后端: cd /Users/jason/Genz.,Ltd/GenzLtd && go run main.go"
echo "   前端: cd /Users/jason/Genz.,Ltd/GenzLtd/Demo && npm run dev" 