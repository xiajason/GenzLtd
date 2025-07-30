#!/bin/bash
set -e

# 加载环境变量
if [ -f .env ]; then
  export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
fi

# 检查环境变量
check_env() {
  if [ -z "$1" ]; then
    echo "错误: 环境变量 $2 未设置"
    exit 1
  fi
}
check_env "$BACKEND_PORT" "BACKEND_PORT"  # 添加这一行
check_env "$DB_HOST" "DB_HOST"
check_env "$DB_PORT" "DB_PORT"
check_env "$DB_USER" "DB_USER"
check_env "$DB_NAME" "DB_NAME"

# 启动后端服务
start_backend() {
  echo "🔧 启动后端服务..."
  cd vuecmf-go || exit 1
  
  # 检查依赖
  if [ ! go mod verify ]; then # {{ edit_1: 修复条件判断语法 }}
    go mod tidy
  fi
  
  # 启动服务（使用空气实时重载）
  if [ -n "$(command -v air)" ]; then
    # 添加端口环境变量 -检查air配置文件
    if [ -f ".air.toml" ]; then  # {{ edit_2: 添加air配置文件检查 }}
      BACKEND_PORT=$BACKEND_PORT air -c .air.toml &
    else
      echo "⚠️ .air.toml文件不存在，使用默认配置启动air"
      # 添加端口参数
      BACKEND_PORT=$BACKEND_PORT air &  # {{ edit_3: 不指定配置文件启动air }}
    fi
  else
    # 添加端口参数
    BACKEND_PORT=$BACKEND_PORT go run main.go &
  fi
  BACKEND_PID=$!
  cd .. || exit 1

  # 添加后端启动检查
  sleep 2
  if [ -z "$(ps -p $BACKEND_PID)" ]; then
    echo "❌ 后端服务启动失败，请检查日志"
    exit 1
  fi
}

# 启动前端服务
start_frontend() {
  echo "🎨 启动前端服务..."
  cd vuecmf-web/frontend || exit 1
  
  # 安装依赖
  if [ ! -d "node_modules" ]; then
    yarn install  # {{ edit_1: Replace npm install with yarn install }}
  fi
  
  yarn serve &  # {{ edit_2: Replace npm run serve with yarn serve }}
  FRONTEND_PID=$!
  cd ../../ || exit 1
}

# 等待服务启动
wait_for_service() {
  local port=$1
  local name=$2
  local timeout=30
  local interval=2
  local count=0
  
  echo "⏳ 等待$name启动..."
  while ! nc -z localhost $port; do
    count=$((count + interval))
    if [ $count -ge $timeout ]; then
      echo "❌ $name启动超时"
      exit 1
    fi
    sleep $interval
  done
  echo "✅ $name启动成功"
}

# 清理函数
cleanup() {
  echo "🛑 停止所有服务..."
  if [ -n "$BACKEND_PID" ]; then
    kill $BACKEND_PID 2>/dev/null || true
  fi
  if [ -n "$FRONTEND_PID" ]; then
    kill $FRONTEND_PID 2>/dev/null || true
  fi
  echo "✅ 所有服务已停止"
  exit 0
}

# 捕获退出信号
trap cleanup SIGINT SIGTERM

# 主流程
echo "🚀 启动 VueCMF 开发环境..."

start_backend
start_frontend

wait_for_service $BACKEND_PORT "后端服务"
wait_for_service $FRONTEND_PORT "前端服务"

echo "✅ 开发环境启动完成！"
echo "📋 服务地址:"
echo "   - 前端: http://localhost:$FRONTEND_PORT"
echo "   - 后端: http://localhost:$BACKEND_PORT"
echo "   - API 测试: http://localhost:$BACKEND_PORT/api/hello"
echo "按 Ctrl+C 停止所有服务"

# 等待所有后台进程
wait