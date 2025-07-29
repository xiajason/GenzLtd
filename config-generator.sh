#!/bin/bash

echo "🎛️  VueCMF 智能配置生成器"
echo "================================"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# 检测 Go 版本
get_go_version() {
    if command -v go &> /dev/null; then
        GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
        echo $GO_VERSION
    else
        echo "unknown"
    fi
}

# 检测 Node.js 版本
get_node_version() {
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version | sed 's/v//')
        echo $NODE_VERSION
    else
        echo "unknown"
    fi
}

# 检测包管理器
get_package_manager() {
    if command -v yarn &> /dev/null; then
        echo "yarn"
    elif command -v npm &> /dev/null; then
        echo "npm"
    else
        echo "unknown"
    fi
}

# 生成 Go 配置
generate_go_config() {
    echo -e "${BLUE}🔧 生成 Go 配置...${NC}"
    
    GO_VERSION=$(get_go_version)
    
    cat > vuecmf-go/go.mod << EOF
module github.com/vuecmf/vuecmf-go

go $GO_VERSION

require (
	github.com/gin-gonic/gin v1.9.1
	github.com/casbin/casbin/v2 v2.77.2
	gorm.io/gorm v1.25.4
	gorm.io/driver/mysql v1.5.2
)
EOF

    echo -e "${GREEN}✅ Go 配置已生成${NC}"
}

# 生成前端配置
generate_frontend_config() {
    echo -e "${BLUE}🎨 生成前端配置...${NC}"
    
    PACKAGE_MANAGER=$(get_package_manager)
    NODE_VERSION=$(get_node_version)
    
    # 更新 package.json
    cat > vuecmf-web/frontend/package.json << EOF
{
  "name": "vuecmf-frontend",
  "version": "1.0.0",
  "description": "VueCMF Frontend Application",
  "main": "src/main.js",
  "engines": {
    "node": ">=16.0.0",
    "npm": ">=8.0.0"
  },
  "scripts": {
    "serve": "vue-cli-service serve",
    "build": "vue-cli-service build",
    "lint": "vue-cli-service lint",
    "test:unit": "vue-cli-service test:unit"
  },
  "dependencies": {
    "vue": "^3.3.0",
    "vue-router": "^4.2.0",
    "vuex": "^4.1.0",
    "axios": "^1.4.0",
    "element-plus": "^2.3.0"
  },
  "devDependencies": {
    "@vue/cli-service": "^5.0.0",
    "@vue/compiler-sfc": "^3.3.0",
    "eslint": "^8.0.0",
    "eslint-plugin-vue": "^9.0.0"
  },
  "browserslist": [
    "> 1%",
    "last 2 versions",
    "not dead"
  ]
}
EOF

    echo -e "${GREEN}✅ 前端配置已生成${NC}"
}

# 生成 Docker 配置
generate_docker_config() {
    echo -e "${BLUE}🐳 生成 Docker 配置...${NC}"
    
    # 根据操作系统生成不同的 Docker 配置
    if [[ "$OS" == "windows" ]]; then
        # Windows 特殊配置
        cat > docker-compose.windows.yml << EOF
version: '3.8'

services:
  frontend-builder:
    build: 
      context: ./vuecmf-web/frontend
      dockerfile: Dockerfile
    ports:
      - "8081:80"
    environment:
      - NODE_ENV=production
    networks:
      - vuecmf-network

  backend-manager:
    build: 
      context: ./vuecmf-go
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    environment:
      - GIN_MODE=release
      - DB_HOST=host.docker.internal
      - DB_PORT=3306
      - DB_USER=root
      - DB_PASSWORD=ServBay.dev
      - DB_NAME=genzltd
    extra_hosts:
      - "host.docker.internal:host-gateway"
    networks:
      - vuecmf-network

networks:
  vuecmf-network:
    driver: bridge
EOF
    else
        # Linux/macOS 配置
        cat > docker-compose.yml << EOF
version: '3.8'

services:
  frontend-builder:
    build: 
      context: ./vuecmf-web/frontend
      dockerfile: Dockerfile
    ports:
      - "8081:80"
    environment:
      - NODE_ENV=production
    networks:
      - vuecmf-network

  backend-manager:
    build: 
      context: ./vuecmf-go
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    environment:
      - GIN_MODE=release
      - DB_HOST=host.docker.internal
      - DB_PORT=3306
      - DB_USER=root
      - DB_PASSWORD=ServBay.dev
      - DB_NAME=genzltd
    extra_hosts:
      - "host.docker.internal:host-gateway"
    networks:
      - vuecmf-network

  db-admin:
    image: phpmyadmin/phpmyadmin:latest
    ports:
      - "8082:80"
    environment:
      - PMA_HOST=host.docker.internal
      - PMA_PORT=3306
      - PMA_USER=root
      - PMA_PASSWORD=ServBay.dev
    extra_hosts:
      - "host.docker.internal:host-gateway"
    networks:
      - vuecmf-network
    profiles:
      - db-admin

networks:
  vuecmf-network:
    driver: bridge
EOF
    fi

    echo -e "${GREEN}✅ Docker 配置已生成${NC}"
}

# 生成环境配置
generate_env_config() {
    echo -e "${BLUE}🌍 生成环境配置...${NC}"
    
    cat > .env << EOF
# VueCMF 环境配置
# 根据您的环境修改以下配置

# 数据库配置
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=root
DB_PASSWORD=ServBay.dev
DB_NAME=genzltd

# 服务配置
BACKEND_PORT=8080
FRONTEND_PORT=8081
DB_ADMIN_PORT=8082

# 开发环境配置
GIN_MODE=debug
NODE_ENV=development

# 操作系统: $OS
# Go 版本: $(get_go_version)
# Node.js 版本: $(get_node_version)
# 包管理器: $(get_package_manager)

# Docker 配置
DOCKER_REGISTRY=your-registry.com
DOCKER_NAMESPACE=vuecmf
EOF

    echo -e "${GREEN}✅ 环境配置已生成${NC}"
}

# 生成 IDE 配置
generate_ide_config() {
    echo -e "${BLUE}💻 生成 IDE 配置...${NC}"
    
    # VS Code 配置
    mkdir -p .vscode
    cat > .vscode/settings.json << EOF
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "files.associations": {
    "*.vue": "vue",
    "*.go": "go"
  },
  "go.useLanguageServer": true,
  "go.gopath": "",
  "go.goroot": "",
  "typescript.preferences.importModuleSpecifier": "relative",
  "vue.codeActions.enabled": true
}
EOF

    # VS Code 扩展推荐
    cat > .vscode/extensions.json << EOF
{
  "recommendations": [
    "Vue.volar",
    "Vue.vscode-typescript-vue-plugin",
    "golang.go",
    "ms-vscode.vscode-typescript-next",
    "esbenp.prettier-vscode",
    "ms-vscode.vscode-eslint"
  ]
}
EOF

    echo -e "${GREEN}✅ IDE 配置已生成${NC}"
}

# 生成 Git 配置
generate_git_config() {
    echo -e "${BLUE}📝 生成 Git 配置...${NC}"
    
    cat > .gitignore << EOF
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build outputs
dist/
build/
*.exe
*.dll
*.so
*.dylib

# Environment files
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Logs
logs
*.log

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/

# Dependency directories
jspm_packages/

# Optional npm cache directory
.npm

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env

# Go specific
*.exe
*.exe~
*.dll
*.so
*.dylib
*.test
*.out
go.work

# Database
*.db
*.sqlite
*.sqlite3

# Docker
.dockerignore
EOF

    echo -e "${GREEN}✅ Git 配置已生成${NC}"
}

# 生成脚本配置
generate_script_config() {
    echo -e "${BLUE}📜 生成脚本配置...${NC}"
    
    # 根据操作系统生成不同的脚本
    if [[ "$OS" == "windows" ]]; then
        # Windows 批处理脚本
        cat > start-dev.bat << EOF
@echo off
echo 🚀 启动 VueCMF 开发环境...
echo ================================

REM 检查依赖
if not exist "vuecmf-web\frontend\node_modules" (
    echo 📦 安装前端依赖...
    cd vuecmf-web\frontend
    npm install
    cd ..\..
)

if not exist "vuecmf-go\go.sum" (
    echo 📦 安装后端依赖...
    cd vuecmf-go
    go mod tidy
    cd ..
)

REM 启动后端服务
echo 🔧 启动后端服务...
cd vuecmf-go
start /B go run main.go
cd ..

REM 启动前端服务
echo 🎨 启动前端服务...
cd vuecmf-web\frontend
start /B npm run serve
cd ..\..

echo ✅ 开发环境启动完成！
echo 📋 服务地址:
echo    - 前端: http://localhost:8081
echo    - 后端: http://localhost:8080
echo.
echo 按任意键停止服务...
pause
EOF
    else
        # Unix/Linux/macOS 脚本
        chmod +x start-dev.sh
        chmod +x check-env.sh
        chmod +x start-docker.sh
    fi

    echo -e "${GREEN}✅ 脚本配置已生成${NC}"
}

# 主函数
main() {
    echo -e "${BLUE}🔍 检测环境信息...${NC}"
    detect_os
    echo "操作系统: $OS"
    echo "Go 版本: $(get_go_version)"
    echo "Node.js 版本: $(get_node_version)"
    echo "包管理器: $(get_package_manager)"
    echo ""

    # 生成各种配置
    generate_go_config
    generate_frontend_config
    generate_docker_config
    generate_env_config
    generate_ide_config
    generate_git_config
    generate_script_config

    echo ""
    echo -e "${GREEN}🎉 配置生成完成！${NC}"
    echo ""
    echo -e "${BLUE}📋 下一步操作：${NC}"
    echo "1. 检查并修改 .env 配置文件"
    echo "2. 运行 ./check-env.sh 检查环境"
    echo "3. 运行 ./start-dev.sh 启动开发环境"
    echo "4. 查看 DEPLOYMENT_GUIDE.md 了解详细说明"
    echo ""
    echo -e "${YELLOW}💡 提示：${NC}"
    echo "- 所有配置文件都已根据您的环境自动生成"
    echo "- 您可以根据需要修改这些配置文件"
    echo "- 建议先运行环境检查确保一切正常"
}

# 运行主函数
main 