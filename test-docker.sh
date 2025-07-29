#!/bin/bash

echo "🐳 测试 Docker 环境..."

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装，请先安装 Docker"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose 未安装，请先安装 Docker Compose"
    exit 1
fi

echo "✅ Docker 环境检查通过"

# 构建并启动 Docker 环境
echo "🔨 构建 Docker 镜像..."
docker-compose build

if [ $? -eq 0 ]; then
    echo "✅ Docker 镜像构建成功"
    
    echo "🚀 启动 Docker 服务..."
    docker-compose up -d
    
    if [ $? -eq 0 ]; then
        echo "✅ Docker 服务启动成功"
        echo ""
        echo "📋 服务地址:"
        echo "   - 前端: http://localhost:8081"
        echo "   - 后端: http://localhost:8080"
        echo ""
        echo "⏳ 等待服务启动..."
        sleep 10
        
        # 测试后端
        echo "🧪 测试后端服务..."
        if curl -s http://localhost:8080/api/hello > /dev/null; then
            echo "✅ 后端服务正常"
        else
            echo "❌ 后端服务异常"
        fi
        
        # 测试前端
        echo "🧪 测试前端服务..."
        if curl -s http://localhost:8081 > /dev/null; then
            echo "✅ 前端服务正常"
        else
            echo "❌ 前端服务异常"
        fi
        
        echo ""
        echo "🎉 Docker 环境测试完成！"
        echo "使用 'docker-compose logs -f' 查看日志"
        echo "使用 'docker-compose down' 停止服务"
    else
        echo "❌ Docker 服务启动失败"
        exit 1
    fi
else
    echo "❌ Docker 镜像构建失败"
    exit 1
fi 