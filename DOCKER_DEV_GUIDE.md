# VueCMF Docker 开发环境指南

## 🚀 快速启动

### 方式一：使用启动脚本（推荐）
```bash
./start-docker-dev.sh
```

### 方式二：手动启动
```bash
# 构建镜像
docker-compose -f docker-compose.dev.yml build

# 启动服务
docker-compose -f docker-compose.dev.yml up -d
```

## 📋 环境配置

### 技术栈
- **前端**: Node.js 22 + Vue 3 + 热重载
- **后端**: Go 1.24.5 + Gin + 热重载
- **数据库**: 本地 MySQL (通过 host.docker.internal 连接)

### 服务端口
- **前端**: http://localhost:8081
- **后端**: http://localhost:8080
- **数据库管理**: http://localhost:8082 (可选)

## 🔧 开发特性

### 热重载支持
- 前端代码修改自动刷新
- 后端代码修改自动重启
- 无需手动重启容器

### 数据库连接
- 使用 `host.docker.internal` 连接本地 MySQL
- 默认配置：
  - 主机: host.docker.internal
  - 端口: 3306
  - 用户: root
  - 密码: ServBay.dev
  - 数据库: genzltd

## 📝 常用命令

```bash
# 查看服务状态
docker-compose -f docker-compose.dev.yml ps

# 查看日志
docker-compose -f docker-compose.dev.yml logs -f

# 查看特定服务日志
docker-compose -f docker-compose.dev.yml logs -f frontend-dev
docker-compose -f docker-compose.dev.yml logs -f backend-dev

# 停止服务
docker-compose -f docker-compose.dev.yml down

# 重启服务
docker-compose -f docker-compose.dev.yml restart

# 重新构建并启动
docker-compose -f docker-compose.dev.yml up --build -d
```

## 🐛 故障排除

### 1. 端口冲突
```bash
# 检查端口占用
lsof -i :8080
lsof -i :8081

# 停止占用进程
kill [PID]
```

### 2. 数据库连接失败
- 确保本地 MySQL 服务正在运行
- 检查数据库配置是否正确
- 验证防火墙设置

### 3. 容器启动失败
```bash
# 查看详细错误信息
docker-compose -f docker-compose.dev.yml logs

# 清理并重新构建
docker-compose -f docker-compose.dev.yml down
docker-compose -f docker-compose.dev.yml build --no-cache
docker-compose -f docker-compose.dev.yml up -d
```

## 🔄 与本地开发对比

| 特性 | Docker 开发 | 本地开发 |
|------|-------------|----------|
| 环境一致性 | ✅ 完全一致 | ⚠️ 可能差异 |
| 启动速度 | ⚠️ 稍慢 | ✅ 快速 |
| 热重载 | ✅ 支持 | ✅ 支持 |
| 资源占用 | ⚠️ 较高 | ✅ 较低 |
| 隔离性 | ✅ 完全隔离 | ❌ 依赖本地环境 |

## 💡 最佳实践

1. **首次启动**: 使用 `./start-docker-dev.sh` 脚本
2. **日常开发**: 直接修改代码，容器会自动热重载
3. **调试问题**: 使用 `docker-compose logs` 查看日志
4. **清理环境**: 定期运行 `docker system prune` 清理无用镜像

## 📞 支持

如遇问题，请检查：
1. Docker 是否正常运行
2. 本地 MySQL 是否可访问
3. 端口是否被占用
4. 网络连接是否正常 