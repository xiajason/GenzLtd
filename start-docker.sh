#!/bin/bash

echo "🐳 启动 VueCMF Docker 服务（本地数据库模式）"
echo "================================================"

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装，请先安装 Docker"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose 未安装，请先安装 Docker Compose"
    exit 1
fi

# 检查本地 MySQL 是否运行
echo "🔍 检查本地 MySQL 服务..."
if ! mysql -u root -p'ServBay.dev' -h 127.0.0.1 -P 3306 -e "SELECT 1;" &> /dev/null; then
    echo "❌ 本地 MySQL 服务未运行或无法连接"
    echo "请确保 MySQL 服务正在运行："
    echo "  brew services start mysql"
    exit 1
fi

echo "✅ 本地 MySQL 服务正常"

# 检查数据库是否存在
echo "🔍 检查数据库..."
if ! mysql -u root -p'ServBay.dev' -h 127.0.0.1 -P 3306 -e "USE genzltd; SELECT 1;" &> /dev/null; then
    echo "⚠️  数据库 'genzltd' 不存在，将自动创建..."
    mysql -u root -p'ServBay.dev' -h 127.0.0.1 -P 3306 -e "CREATE DATABASE IF NOT EXISTS genzltd CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    echo "✅ 数据库创建完成"
else
    echo "✅ 数据库 'genzltd' 已存在"
fi

# 构建并启动服务
echo ""
echo "🔨 构建 Docker 镜像..."
docker-compose build

if [ $? -eq 0 ]; then
    echo "✅ Docker 镜像构建成功"
    
    echo ""
    echo "🚀 启动 Docker 服务..."
    docker-compose up -d
    
    if [ $? -eq 0 ]; then
        echo "✅ Docker 服务启动成功"
        echo ""
        echo "📋 服务地址:"
        echo "   - 前端界面: http://localhost:8081"
        echo "   - 后端 API: http://localhost:8080"
        echo "   - 数据库管理: http://localhost:8082 (可选)"
        echo ""
        echo "⏳ 等待服务启动..."
        sleep 10
        
        # 测试服务
        echo "🧪 测试服务状态..."
        
        # 测试后端
        if curl -s http://localhost:8080/api/health > /dev/null; then
            echo "✅ 后端服务正常"
        else
            echo "❌ 后端服务异常"
        fi
        
        # 测试前端
        if curl -s http://localhost:8081 > /dev/null; then
            echo "✅ 前端服务正常"
        else
            echo "❌ 前端服务异常"
        fi
        
        echo ""
        echo "🎉 Docker 服务启动完成！"
        echo ""
        echo "💡 使用说明:"
        echo "1. 前端界面: http://localhost:8081"
        echo "2. 后端 API: http://localhost:8080"
        echo "3. 数据库管理: http://localhost:8082 (可选)"
        echo "4. 本地数据库: 127.0.0.1:3306"
        echo ""
        echo "📝 管理命令:"
        echo "  - 查看日志: docker-compose logs -f"
        echo "  - 停止服务: docker-compose down"
        echo "  - 重启服务: docker-compose restart"
        
    else
        echo "❌ Docker 服务启动失败"
        exit 1
    fi
else
    echo "❌ Docker 镜像构建失败"
    exit 1
fi 