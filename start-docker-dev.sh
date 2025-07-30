#!/bin/bash

echo "🐳 启动 VueCMF Docker 开发环境 (Node.js 22 + Go 1.24.5)..."

# 检查 Docker 是否运行
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker 未运行，请先启动 Docker"
    exit 1
fi

# 构建并启动开发环境
echo "🔨 构建开发环境镜像..."
docker-compose -f docker-compose.dev.yml build

echo "🚀 启动开发服务..."
docker-compose -f docker-compose.dev.yml up -d

echo "⏳ 等待服务启动..."
sleep 5

# 检查服务状态
echo "📊 服务状态检查:"
echo "----------------------------------------"
echo "🌐 前端服务: http://localhost:8081"
echo "🔧 后端服务: http://localhost:8080"
echo "🗄️  数据库管理: http://localhost:8082 (可选)"
echo "----------------------------------------"

# 测试后端健康检查
echo "🔍 测试后端服务..."
if curl -s http://localhost:8080/vuecmf/health > /dev/null; then
    echo "✅ 后端服务运行正常"
else
    echo "⚠️  后端服务可能还在启动中，请稍等..."
fi

echo ""
echo "🎉 Docker 开发环境启动完成！"
echo ""
echo "📝 常用命令:"
echo "  查看日志: docker-compose -f docker-compose.dev.yml logs -f"
echo "  停止服务: docker-compose -f docker-compose.dev.yml down"
echo "  重启服务: docker-compose -f docker-compose.dev.yml restart"
echo "  查看状态: docker-compose -f docker-compose.dev.yml ps"
echo ""
echo "💡 提示: 代码修改会自动热重载，无需重启容器" 