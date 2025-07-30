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
