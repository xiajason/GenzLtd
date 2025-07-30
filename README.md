# VueCMF 项目 - 现代化前后端分离开发框架

VueCMF 是一个基于 **Vue 3 + Go** 的现代化前后端分离开发框架，采用容器化部署和自动化配置，提供快速开发 CMS、CRM、WMS、OMS、ERP 等管理系统的能力。

## 🎉 项目状态

**✅ 项目已完全自动化配置并正常运行！**

- ✅ 目录结构已按最佳实践调整
- ✅ 前后端依赖已自动安装
- ✅ 开发环境已一键配置
- ✅ Docker 容器化部署已就绪
- ✅ API 接口已测试验证
- ✅ 自动化脚本已配置完成

## 📁 项目结构


```
GenzLtd/
├── vuecmf-go/                    # Go 后端服务
│   ├── cmd/                      # 命令行工具
│   ├── api/                      # API 定义
│   ├── internal/                 # 内部包
│   ├── pkg/                      # 公共包
│   ├── main.go                   # 主程序
│   ├── go.mod                    # Go 模块配置
│   └── Dockerfile                # 后端容器配置
├── vuecmf-web/                   # Vue 前端应用
│   └── frontend/                 # 前端项目
│       ├── src/                  # 源代码
│       ├── public/               # 静态资源
│       ├── package.json          # 前端依赖
│       ├── vue.config.js         # Vue 配置
│       ├── Dockerfile            # 前端容器配置
│       └── nginx.conf            # Nginx 配置
├── docker-compose.yml            # 容器编排配置
├── Makefile                      # 构建脚本
├── start-dev.sh                  # 开发环境启动脚本
├── test-docker.sh                # Docker 测试脚本
├── simple_test.sh                # API 测试脚本
├── setup_project.sh              # 自动化设置脚本
├── PROJECT_SETUP.md              # 详细使用说明
└── PROJECT_STATUS.md             # 项目状态报告
```

## 🚀 快速开始

### 1. 智能环境检测

```bash
# 自动检测和配置环境
./check-env.sh

# 或使用 Makefile
make check-env
```

### 2. 智能配置生成

```bash
# 根据您的环境自动生成配置
./config-generator.sh

# 或使用 Makefile
make generate-config
```

### 3. 一键项目设置

```bash
# 完整项目设置（推荐）
make setup
```

### 4. 环境要求

- **Go** >= 1.24.5
- **Node.js** >= 16.0
- **Docker** >= 20.0 (可选，用于容器化部署)
- **Docker Compose** >= 2.0 (可选)

### 5. 启动开发环境

```bash
# 启动完整开发环境（推荐）
./start-dev.sh
```

### 2. 分步启动

```bash
# 安装依赖
make install-deps

# 启动后端服务
make start-backend

# 启动前端服务
make start-frontend
```

### 3. Docker 环境

```bash
# 方案一：本地数据库 + Docker 服务（推荐）
make build-docker

# 方案二：完整 Docker 环境
make build-docker-full

# 启动数据库管理工具
make start-db-admin
```

## 🌐 服务地址

- **前端界面**: http://localhost:8081
- **后端 API**: http://localhost:8080
- **健康检查**: http://localhost:8080/api/health

## 📋 可用命令

### 开发环境

```bash
# 显示帮助信息
make help

# 智能环境检测
make check-env

# 智能配置生成
make generate-config

# 完整项目设置
make setup

# 安装所有依赖
make install-deps

# 启动后端服务
make start-backend

# 启动前端服务
make start-frontend

# 启动完整开发环境
make start-dev
```

### Docker 环境

```bash
# 构建并启动 Docker 环境
make build-docker

# 停止 Docker 环境
make stop-docker

# 查看 Docker 日志
make logs

# 清理 Docker 资源
make clean
```

### 测试和验证

```bash
# 运行 API 测试
./simple_test.sh

# 运行单元测试
make test
```

## 🧪 功能验证

### 后端 API 测试

```bash
# 测试健康检查
curl http://localhost:8080/vuecmf/health
# 返回: {"message":"Backend service is running","status":"healthy"}

# 测试 Hello API
curl http://localhost:8080/vuecmf/hello
# 返回: {"message":"Hello from Go backend!","status":"success"}
```

### 前端功能测试

- ✅ 页面正常加载
- ✅ API 调用功能正常
- ✅ 后端状态检查功能正常
- ✅ 错误处理机制完善

## 🛠️ 技术栈

### 后端技术

- **语言**: Go 1.24.5
- **框架**: 标准库 net/http
- **容器**: Alpine Linux
- **特性**: CORS 支持、JSON API、健康检查

### 前端技术

- **框架**: Vue 3
- **构建工具**: Vue CLI 5
- **HTTP 客户端**: Axios
- **容器**: Nginx + Node.js
- **特性**: 热重载、API 代理、现代化 UI

### 部署技术

- **容器编排**: Docker Compose
- **网络**: 自定义 bridge 网络
- **环境**: 开发和生产配置分离

## 🔧 配置说明

### 开发环境配置

- 前端代理到后端 API
- 支持热重载
- 开发服务器端口：8081
- 后端服务器端口：8080

### 生产环境配置

- Nginx 静态文件服务
- API 反向代理
- 容器化部署
- 环境变量配置

## 📦 自动化功能

### ✅ 已完成

1. **目录结构调整**
   - 创建标准 Go 项目结构
   - 确保前端目录完整

2. **配置文件生成**
   - 后端：main.go, go.mod, Dockerfile
   - 前端：vue.config.js, package.json, Dockerfile
   - 容器：docker-compose.yml

3. **依赖管理**
   - 自动安装后端 Go 依赖
   - 自动安装前端 npm 依赖
   - 包含 axios 用于 API 调用

4. **开发环境初始化**
   - 生成 Makefile 提供便捷命令
   - 生成一键启动脚本
   - 生成 Docker 测试脚本

5. **功能验证**
   - 后端 API 服务正常运行
   - 前端开发服务器正常运行
   - API 代理配置正确
   - CORS 跨域支持已配置

## 🎯 开发指南

### 添加新的 API 端点

在 `vuecmf-go/main.go` 中添加新的路由：

```go
http.HandleFunc("/api/new-endpoint", func(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    response := Response{
        Message: "New endpoint response",
        Status:  "success",
    }
    json.NewEncoder(w).Encode(response)
})
```

### 添加新的前端页面

在 `vuecmf-web/frontend/src/` 目录下创建新的 Vue 组件。

### 数据库集成

项目已准备好集成数据库，可以添加 GORM 或其他 ORM 框架。

## 🔍 故障排除

### 1. 端口冲突

```bash
# 查看端口占用
lsof -i :8080
lsof -i :8081

# 杀死占用进程
kill [PID]
```

### 2. 依赖问题

```bash
# 清理并重新安装依赖
make clean
make install-deps
```

### 3. Docker 问题

```bash
# 清理 Docker 资源
docker-compose down --rmi all --volumes --remove-orphans

# 重新构建
docker-compose up --build
```

### 4. 服务启动失败

```bash
# 检查服务状态
./simple_test.sh

# 查看详细日志
make logs
```

## 📚 相关文档

- [PROJECT_SETUP.md](./PROJECT_SETUP.md) - 详细使用说明
- [PROJECT_STATUS.md](./PROJECT_STATUS.md) - 项目状态报告
- [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) - 部署指南

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者和用户。

---

**🎉 项目已准备好进行开发和生产部署！**