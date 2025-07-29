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
