#!/bin/bash

echo "🚀 启动 VueCMF 开发环境..."
echo "================================"

# 检测操作系统
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
    else
        OS="unknown"
    fi
}

# 检测包管理器
detect_package_manager() {
    if command -v yarn &> /dev/null; then
        PACKAGE_MANAGER="yarn"
    elif command -v npm &> /dev/null; then
        PACKAGE_MANAGER="npm"
    else
        echo "❌ 未检测到包管理器 (npm 或 yarn)"
        exit 1
    fi
}

# 检查依赖是否已安装
check_dependencies() {
    echo "📦 检查依赖..."
    
    # 检查前端依赖
    if [ ! -d "vuecmf-web/frontend/node_modules" ]; then
        echo "📦 安装前端依赖..."
        cd vuecmf-web/frontend
        $PACKAGE_MANAGER install
        cd ../..
    fi

    # 检查后端依赖
    if [ ! -f "vuecmf-go/go.sum" ]; then
        echo "📦 安装后端依赖..."
        cd vuecmf-go
        go mod tidy
        cd ..
    fi
}

# 启动后端服务
start_backend() {
    echo "🔧 启动后端服务..."
    cd vuecmf-go
    
    # 根据操作系统设置环境变量
    if [[ "$OS" == "windows" ]]; then
        set GIN_MODE=debug
        go run main.go &
    else
        GIN_MODE=debug go run main.go &
    fi
    
    BACKEND_PID=$!
    cd ..
}

# 启动前端服务
start_frontend() {
    echo "🎨 启动前端服务..."
    cd vuecmf-web/frontend
    
    # 根据包管理器启动服务
    if [[ "$PACKAGE_MANAGER" == "yarn" ]]; then
        yarn serve &
    else
        npm run serve &
    fi
    
    FRONTEND_PID=$!
    cd ../..
}

# 等待服务启动
wait_for_services() {
    echo "⏳ 等待服务启动..."
    sleep 5
    
    # 检查后端服务
    if curl -s http://localhost:8080/api/health > /dev/null; then
        echo "✅ 后端服务已启动"
    else
        echo "❌ 后端服务启动失败"
    fi
    
    # 检查前端服务
    if curl -s http://localhost:8081 > /dev/null; then
        echo "✅ 前端服务已启动"
    else
        echo "❌ 前端服务启动失败"
    fi
}

# 显示服务信息
show_services() {
    echo ""
    echo "✅ 开发环境启动完成！"
    echo "📋 服务地址:"
    echo "   - 前端: http://localhost:8081"
    echo "   - 后端: http://localhost:8080"
    echo "   - API 测试: http://localhost:8080/api/hello"
    echo ""
    echo "按 Ctrl+C 停止所有服务"
}

# 清理函数
cleanup() {
    echo ""
    echo "🛑 停止服务..."
    
    # 停止后端服务
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
    fi
    
    # 停止前端服务
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID 2>/dev/null
    fi
    
    # 清理可能的残留进程
    if [[ "$OS" == "windows" ]]; then
        taskkill /F /IM "go.exe" 2>/dev/null
        taskkill /F /IM "node.exe" 2>/dev/null
    else
        pkill -f "go run main.go" 2>/dev/null
        pkill -f "npm run serve" 2>/dev/null
        pkill -f "yarn serve" 2>/dev/null
    fi
    
    echo "✅ 服务已停止"
    exit 0
}

# 主函数
main() {
    # 检测操作系统
    detect_os
    echo "🖥️  操作系统: $OS"
    
    # 检测包管理器
    detect_package_manager
    echo "📦 包管理器: $PACKAGE_MANAGER"
    
    # 检查依赖
    check_dependencies
    
    # 启动服务
    start_backend
    sleep 2
    start_frontend
    
    # 等待服务启动
    wait_for_services
    
    # 显示服务信息
    show_services
    
    # 设置清理函数
    trap cleanup INT TERM
    
    # 等待用户中断
    wait
}

# 运行主函数
main
