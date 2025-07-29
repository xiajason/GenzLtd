#!/bin/bash

echo "开始自动化项目结构调整..."

# 1. 目录结构调整
echo "1. 调整目录结构..."
mkdir -p vuecmf-go/cmd vuecmf-go/api vuecmf-go/internal vuecmf-go/pkg
mkdir -p vuecmf-web/frontend/src

echo "目录结构调整完成！"

# 2. 生成后端配置文件
echo "2. 生成后端配置文件..."

# 生成 vuecmf-go 的 main.go
cat > vuecmf-go/main.go << 'EOF'
package main

import (
    "fmt"
    "net/http"
    "log"
    "encoding/json"
)

type Response struct {
    Message string `json:"message"`
    Status  string `json:"status"`
}

func main() {
    // API 路由
    http.HandleFunc("/api/hello", func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        w.Header().Set("Access-Control-Allow-Origin", "*")
        w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
        
        response := Response{
            Message: "Hello from Go backend!",
            Status:  "success",
        }
        
        json.NewEncoder(w).Encode(response)
    })

    // 健康检查端点
    http.HandleFunc("/api/health", func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        response := Response{
            Message: "Backend service is running",
            Status:  "healthy",
        }
        json.NewEncoder(w).Encode(response)
    })

    fmt.Println("🚀 Backend server running on http://localhost:8080")
    fmt.Println("📋 Available endpoints:")
    fmt.Println("   - GET /api/hello")
    fmt.Println("   - GET /api/health")
    
    log.Fatal(http.ListenAndServe(":8080", nil))
}
EOF

# 生成 go.mod
cat > vuecmf-go/go.mod << 'EOF'
module github.com/genzltd/vuecmf-go

go 1.20

require (
    github.com/gorilla/mux v1.8.0
    github.com/rs/cors v1.8.3
)
EOF

# 3. 生成前端配置文件
echo "3. 生成前端配置文件..."

# 更新 vue.config.js
cat > vuecmf-web/frontend/vue.config.js << 'EOF'
const { defineConfig } = require('@vue/cli-service')

module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    port: 8081,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false,
        pathRewrite: {
          '^/api': '/api'
        }
      },
    },
  },
  outputDir: 'dist',
  publicPath: process.env.NODE_ENV === 'production' ? './' : '/'
})
EOF

# 更新 package.json
cat > vuecmf-web/frontend/package.json << 'EOF'
{
  "name": "vuecmf-frontend",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "serve": "vue-cli-service serve",
    "build": "vue-cli-service build",
    "lint": "vue-cli-service lint"
  },
  "dependencies": {
    "axios": "^1.6.0",
    "core-js": "^3.8.3",
    "vue": "^3.2.13",
    "vue-router": "^4.0.3",
    "vuex": "^4.0.0"
  },
  "devDependencies": {
    "@babel/core": "^7.12.16",
    "@babel/eslint-parser": "^7.12.16",
    "@vue/cli-plugin-babel": "~5.0.0",
    "@vue/cli-plugin-eslint": "~5.0.0",
    "@vue/cli-plugin-router": "~5.0.0",
    "@vue/cli-plugin-vuex": "~5.0.0",
    "@vue/cli-service": "~5.0.0",
    "eslint": "^7.32.0",
    "eslint-plugin-vue": "^8.0.3"
  },
  "eslintConfig": {
    "root": true,
    "env": {
      "node": true
    },
    "extends": [
      "plugin:vue/vue3-essential",
      "eslint:recommended"
    ],
    "parserOptions": {
      "parser": "@babel/eslint-parser"
    },
    "rules": {}
  },
  "browserslist": [
    "> 1%",
    "last 2 versions",
    "not dead",
    "not ie 11"
  ]
}
EOF

# 4. 生成 Docker 配置文件
echo "4. 生成 Docker 配置文件..."

# 后端 Dockerfile
cat > vuecmf-go/Dockerfile << 'EOF'
FROM golang:1.20-alpine as builder

WORKDIR /app

# 复制 go mod 文件
COPY go.mod go.sum ./
RUN go mod download

# 复制源代码
COPY . .

# 构建应用
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# 运行阶段
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# 从构建阶段复制二进制文件
COPY --from=builder /app/main .

EXPOSE 8080

CMD ["./main"]
EOF

# 前端 Dockerfile
cat > vuecmf-web/frontend/Dockerfile << 'EOF'
# 构建阶段
FROM node:18-alpine as build-stage

WORKDIR /app

# 复制 package 文件
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制源代码
COPY . .

# 构建应用
RUN npm run build

# 生产阶段
FROM nginx:stable-alpine as production-stage

# 复制构建产物
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 复制 nginx 配置
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOF

# nginx 配置文件
cat > vuecmf-web/frontend/nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    server {
        listen 80;
        server_name localhost;

        root /usr/share/nginx/html;
        index index.html;

        # API 代理
        location /api/ {
            proxy_pass http://backend:8080/api/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # 静态文件
        location / {
            try_files $uri $uri/ /index.html;
        }
    }
}
EOF

# 5. 生成 docker-compose.yml
echo "5. 生成 docker-compose.yml..."

cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  frontend:
    build: 
      context: ./vuecmf-web/frontend
      dockerfile: Dockerfile
    ports:
      - "8081:80"
    depends_on:
      - backend
    networks:
      - vuecmf-network
    environment:
      - NODE_ENV=production

  backend:
    build: 
      context: ./vuecmf-go
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    networks:
      - vuecmf-network
    environment:
      - GIN_MODE=release

networks:
  vuecmf-network:
    driver: bridge
EOF

# 6. 生成 Makefile
echo "6. 生成 Makefile..."

cat > Makefile << 'EOF'
.PHONY: help install-deps start-backend start-frontend start-dev build-docker clean

help: ## 显示帮助信息
	@echo "可用的命令:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install-deps: ## 安装所有依赖
	@echo "📦 安装后端依赖..."
	cd vuecmf-go && go mod tidy
	@echo "📦 安装前端依赖..."
	cd vuecmf-web/frontend && npm install

start-backend: ## 启动后端服务
	@echo "🚀 启动后端服务..."
	cd vuecmf-go && go run main.go

start-frontend: ## 启动前端服务
	@echo "🎨 启动前端服务..."
	cd vuecmf-web/frontend && npm run serve

start-dev: ## 启动开发环境（后台运行）
	@echo "🚀 启动开发环境..."
	@make start-backend &
	@sleep 3
	@make start-frontend &

build-docker: ## 构建并启动 Docker 环境
	@echo "🐳 构建并启动 Docker 环境..."
	docker-compose up --build

stop-docker: ## 停止 Docker 环境
	@echo "🛑 停止 Docker 环境..."
	docker-compose down

clean: ## 清理构建文件
	@echo "🧹 清理构建文件..."
	rm -rf vuecmf-web/frontend/dist
	rm -rf vuecmf-go/main
	docker-compose down --rmi all --volumes --remove-orphans

logs: ## 查看 Docker 日志
	docker-compose logs -f

test: ## 运行测试
	@echo "🧪 运行测试..."
	cd vuecmf-go && go test ./...
EOF

# 7. 生成开发环境启动脚本
echo "7. 生成开发环境启动脚本..."

cat > start-dev.sh << 'EOF'
#!/bin/bash

echo "🚀 启动 VueCMF 开发环境..."

# 检查依赖是否已安装
if [ ! -d "vuecmf-web/frontend/node_modules" ]; then
    echo "📦 安装前端依赖..."
    cd vuecmf-web/frontend && npm install && cd ../..
fi

if [ ! -f "vuecmf-go/go.sum" ]; then
    echo "📦 安装后端依赖..."
    cd vuecmf-go && go mod tidy && cd ..
fi

# 启动后端服务（后台运行）
echo "🔧 启动后端服务..."
cd vuecmf-go
go run main.go &
BACKEND_PID=$!
cd ..

# 等待后端启动
echo "⏳ 等待后端服务启动..."
sleep 3

# 启动前端服务
echo "🎨 启动前端服务..."
cd vuecmf-web/frontend
npm run serve &
FRONTEND_PID=$!
cd ../..

echo "✅ 开发环境启动完成！"
echo "📋 服务地址:"
echo "   - 前端: http://localhost:8081"
echo "   - 后端: http://localhost:8080"
echo "   - API 测试: http://localhost:8080/api/hello"
echo ""
echo "按 Ctrl+C 停止所有服务"

# 等待用户中断
trap "echo '🛑 停止服务...'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit" INT
wait
EOF

chmod +x start-dev.sh

# 8. 生成项目说明文档
echo "8. 生成项目说明文档..."

cat > PROJECT_SETUP.md << 'EOF'
# VueCMF 项目自动化设置

## 项目结构

```
GenzLtd/
├── vuecmf-go/           # Go 后端
│   ├── cmd/             # 命令行工具
│   ├── api/             # API 定义
│   ├── internal/        # 内部包
│   ├── pkg/             # 公共包
│   ├── main.go          # 主程序
│   ├── go.mod           # Go 模块
│   └── Dockerfile       # 后端容器配置
├── vuecmf-web/          # Vue 前端
│   └── frontend/        # 前端应用
│       ├── src/         # 源代码
│       ├── public/      # 静态资源
│       ├── package.json # 前端依赖
│       ├── vue.config.js # Vue 配置
│       └── Dockerfile   # 前端容器配置
├── docker-compose.yml   # 容器编排
├── Makefile            # 构建脚本
└── start-dev.sh        # 开发环境启动脚本
```

## 快速开始

### 1. 安装依赖
```bash
make install-deps
```

### 2. 启动开发环境
```bash
# 方式一：使用启动脚本
./start-dev.sh

# 方式二：使用 Makefile
make start-dev
```

### 3. 启动 Docker 环境
```bash
make build-docker
```

## 可用命令

- `make help` - 显示帮助信息
- `make install-deps` - 安装所有依赖
- `make start-backend` - 启动后端服务
- `make start-frontend` - 启动前端服务
- `make start-dev` - 启动开发环境
- `make build-docker` - 构建并启动 Docker 环境
- `make stop-docker` - 停止 Docker 环境
- `make clean` - 清理构建文件
- `make logs` - 查看 Docker 日志
- `make test` - 运行测试

## 服务地址

- 前端: http://localhost:8081
- 后端: http://localhost:8080
- API 测试: http://localhost:8080/api/hello
- 健康检查: http://localhost:8080/api/health

## 开发说明

1. 后端使用 Go 1.20，支持热重载
2. 前端使用 Vue 3 + Vue CLI
3. 支持 CORS 跨域请求
4. 包含完整的 Docker 容器化配置
5. 提供开发和生产环境配置

## 故障排除

1. 端口冲突：修改 vue.config.js 和 main.go 中的端口配置
2. 依赖问题：运行 `make clean && make install-deps`
3. Docker 问题：运行 `docker-compose down && docker-compose up --build`
EOF

echo ""
echo "✅ 项目自动化设置完成！"
echo ""
echo "📋 下一步操作："
echo "1. 安装依赖: make install-deps"
echo "2. 启动开发环境: ./start-dev.sh"
echo "3. 或启动 Docker 环境: make build-docker"
echo ""
echo "📖 详细说明请查看 PROJECT_SETUP.md" 