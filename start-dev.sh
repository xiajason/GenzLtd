#!/bin/bash

# 开发环境启动脚本
# 同时启动前端和后端服务

echo "=== 启动后端服务 ==="
make start-backend &
BACKEND_PID=$!

echo "=== 启动前端服务 ==="
make start-frontend &
FRONTEND_PID=$!

echo "开发环境服务已启动:"
echo "- 后端 API: http://localhost:8080"
echo "- 前端界面: http://localhost:8081"

echo "按 Ctrl+C 停止所有服务"

# 等待所有后台进程
wait $BACKEND_PID $FRONTEND_PID