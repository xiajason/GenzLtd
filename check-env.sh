#!/bin/bash

echo "🔍 VueCMF 环境检测和配置工具"
echo "================================"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检测操作系统
detect_os() {
    echo -e "${BLUE}📋 检测操作系统...${NC}"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        echo -e "${GREEN}✅ 检测到 Linux 系统${NC}"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        echo -e "${GREEN}✅ 检测到 macOS 系统${NC}"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
        echo -e "${GREEN}✅ 检测到 Windows 系统${NC}"
    else
        OS="unknown"
        echo -e "${YELLOW}⚠️  未知操作系统: $OSTYPE${NC}"
    fi
}

# 检测 Go 版本
check_go() {
    echo -e "${BLUE}🔍 检测 Go 环境...${NC}"
    if command -v go &> /dev/null; then
        GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
        echo -e "${GREEN}✅ Go 已安装: $GO_VERSION${NC}"
        
        # 检查版本是否满足要求
        REQUIRED_GO="1.20"
        if [[ "$(printf '%s\n' "$REQUIRED_GO" "$GO_VERSION" | sort -V | head -n1)" == "$REQUIRED_GO" ]]; then
            echo -e "${GREEN}✅ Go 版本满足要求${NC}"
        else
            echo -e "${YELLOW}⚠️  Go 版本可能过低，建议升级到 1.20+${NC}"
        fi
    else
        echo -e "${RED}❌ Go 未安装${NC}"
        echo "请访问 https://golang.org/dl/ 下载安装"
        return 1
    fi
}

# 检测 Node.js 版本
check_node() {
    echo -e "${BLUE}🔍 检测 Node.js 环境...${NC}"
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version | sed 's/v//')
        echo -e "${GREEN}✅ Node.js 已安装: $NODE_VERSION${NC}"
        
        # 检查版本是否满足要求
        REQUIRED_NODE="16.0"
        if [[ "$(printf '%s\n' "$REQUIRED_NODE" "$NODE_VERSION" | sort -V | head -n1)" == "$REQUIRED_NODE" ]]; then
            echo -e "${GREEN}✅ Node.js 版本满足要求${NC}"
        else
            echo -e "${YELLOW}⚠️  Node.js 版本可能过低，建议升级到 16.0+${NC}"
        fi
    else
        echo -e "${RED}❌ Node.js 未安装${NC}"
        echo "请访问 https://nodejs.org/ 下载安装"
        return 1
    fi
}

# 检测 npm/yarn
check_package_manager() {
    echo -e "${BLUE}🔍 检测包管理器...${NC}"
    if command -v yarn &> /dev/null; then
        YARN_VERSION=$(yarn --version)
        echo -e "${GREEN}✅ Yarn 已安装: $YARN_VERSION${NC}"
        PACKAGE_MANAGER="yarn"
    elif command -v npm &> /dev/null; then
        NPM_VERSION=$(npm --version)
        echo -e "${GREEN}✅ npm 已安装: $NPM_VERSION${NC}"
        PACKAGE_MANAGER="npm"
    else
        echo -e "${RED}❌ 未检测到包管理器${NC}"
        return 1
    fi
}

# 检测 Docker
check_docker() {
    echo -e "${BLUE}🔍 检测 Docker 环境...${NC}"
    if command -v docker &> /dev/null; then
        DOCKER_VERSION=$(docker --version | awk '{print $3}' | sed 's/,//')
        echo -e "${GREEN}✅ Docker 已安装: $DOCKER_VERSION${NC}"
        
        # 检查 Docker 是否运行
        if docker info &> /dev/null; then
            echo -e "${GREEN}✅ Docker 服务正在运行${NC}"
        else
            echo -e "${YELLOW}⚠️  Docker 服务未运行${NC}"
            echo "请启动 Docker Desktop 或 Docker 服务"
        fi
    else
        echo -e "${YELLOW}⚠️  Docker 未安装（可选）${NC}"
        echo "Docker 用于容器化部署，如不需要可跳过"
    fi
}

# 检测 MySQL
check_mysql() {
    echo -e "${BLUE}🔍 检测 MySQL 环境...${NC}"
    if command -v mysql &> /dev/null; then
        echo -e "${GREEN}✅ MySQL 客户端已安装${NC}"
        
        # 尝试连接数据库
        if mysql -u root -p'ServBay.dev' -h 127.0.0.1 -P 3306 -e "SELECT 1;" &> /dev/null; then
            echo -e "${GREEN}✅ MySQL 服务正在运行${NC}"
        else
            echo -e "${YELLOW}⚠️  MySQL 服务未运行或无法连接${NC}"
            echo "请启动 MySQL 服务"
        fi
    else
        echo -e "${YELLOW}⚠️  MySQL 未安装${NC}"
        echo "请安装 MySQL 数据库"
    fi
}

# 检测端口占用
check_ports() {
    echo -e "${BLUE}🔍 检测端口占用...${NC}"
    PORTS=("8080" "8081" "8082" "3306")
    
    for port in "${PORTS[@]}"; do
        if lsof -i :$port &> /dev/null; then
            echo -e "${YELLOW}⚠️  端口 $port 已被占用${NC}"
        else
            echo -e "${GREEN}✅ 端口 $port 可用${NC}"
        fi
    done
}

# 生成环境配置文件
generate_env_config() {
    echo -e "${BLUE}📝 生成环境配置文件...${NC}"
    
    cat > .env.example << EOF
# VueCMF 环境配置
# 复制此文件为 .env 并根据需要修改

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

# Docker 配置
DOCKER_REGISTRY=your-registry.com
DOCKER_NAMESPACE=vuecmf
EOF

    if [ ! -f .env ]; then
        cp .env.example .env
        echo -e "${GREEN}✅ 已生成 .env 配置文件${NC}"
    else
        echo -e "${YELLOW}⚠️  .env 文件已存在，未覆盖${NC}"
    fi
}

# 生成个性化配置
generate_personal_config() {
    echo -e "${BLUE}🎨 生成个性化配置...${NC}"
    
    # 生成用户配置文件
    cat > config/user.yaml << EOF
# 用户个性化配置
user:
  name: "开发者"
  email: "developer@example.com"
  company: "您的公司"

# 项目配置
project:
  name: "VueCMF 项目"
  version: "1.0.0"
  description: "基于 Vue 3 + Go 的现代化管理系统"

# 开发配置
development:
  auto_reload: true
  debug_mode: true
  log_level: "info"

# 部署配置
deployment:
  environment: "development"
  docker_enabled: true
  local_database: true
EOF

    echo -e "${GREEN}✅ 已生成个性化配置文件${NC}"
}

# 主函数
main() {
    detect_os
    echo ""
    
    check_go
    echo ""
    
    check_node
    echo ""
    
    check_package_manager
    echo ""
    
    check_docker
    echo ""
    
    check_mysql
    echo ""
    
    check_ports
    echo ""
    
    generate_env_config
    echo ""
    
    generate_personal_config
    echo ""
    
    echo -e "${GREEN}🎉 环境检测完成！${NC}"
    echo ""
    echo -e "${BLUE}📋 下一步操作：${NC}"
    echo "1. 检查并修改 .env 配置文件"
    echo "2. 运行 ./start-dev.sh 启动开发环境"
    echo "3. 运行 ./start-docker.sh 启动 Docker 环境"
    echo "4. 查看 DEPLOYMENT_GUIDE.md 了解详细部署说明"
}

# 运行主函数
main 