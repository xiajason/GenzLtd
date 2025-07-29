# VueCMF 部署指南

## 🎯 部署方案概述

本项目提供两种部署方案：

### 方案一：本地数据库 + Docker 服务（推荐）
- **数据库**：本地 MySQL（127.0.0.1:3306）
- **前端**：Docker 容器（localhost:8081）
- **后端**：Docker 容器（localhost:8080）
- **数据库管理**：可选 phpMyAdmin（localhost:8082）

### 方案二：完整 Docker 环境
- **所有服务**：Docker 容器化部署
- **数据库**：Docker MySQL 容器
- **前端**：Docker 容器
- **后端**：Docker 容器

## 🚀 快速部署（方案一：推荐）

### 1. 环境准备

```bash
# 安装 MySQL（如果未安装）
brew install mysql
brew services start mysql

# 安装 Docker（如果未安装）
brew install docker docker-compose
```

### 2. 数据库配置

```bash
# 设置 MySQL 密码
mysql -u root -p
# 输入密码后执行：
ALTER USER 'root'@'localhost' IDENTIFIED BY 'ServBay.dev';
FLUSH PRIVILEGES;
EXIT;
```

### 3. 启动服务

```bash
# 一键启动（推荐）
./start-docker.sh

# 或使用 Makefile
make build-docker
```

### 4. 验证部署

```bash
# 测试服务
./simple_test.sh

# 访问服务
# 前端：http://localhost:8081
# 后端：http://localhost:8080
# 数据库管理：http://localhost:8082
```

## 🐳 完整 Docker 部署（方案二）

### 1. 启动完整环境

```bash
make build-docker-full
```

### 2. 访问服务

- 前端：http://localhost:8081
- 后端：http://localhost:8080
- 数据库：通过 Docker 内部网络访问

## 📊 服务架构对比

| 组件 | 方案一（推荐） | 方案二 |
|------|---------------|--------|
| 数据库 | 本地 MySQL | Docker MySQL |
| 数据库访问 | 直接访问 127.0.0.1 | Docker 内部网络 |
| 数据持久化 | 本地文件系统 | Docker Volume |
| 开发调试 | 方便直接访问 | 需要进入容器 |
| 性能 | 最佳 | 良好 |
| 部署复杂度 | 简单 | 中等 |

## 🔧 配置说明

### 环境变量配置

```bash
# 数据库配置
DB_HOST=host.docker.internal  # Docker 访问宿主机
DB_PORT=3306
DB_USER=root
DB_PASSWORD=ServBay.dev
DB_NAME=genzltd

# 服务配置
GIN_MODE=release
NODE_ENV=production
```

### 网络配置

```yaml
# docker-compose.yml
extra_hosts:
  - "host.docker.internal:host-gateway"  # 允许容器访问宿主机
```

## 🛠️ 管理命令

### 服务管理

```bash
# 启动服务
./start-docker.sh

# 停止服务
make stop-docker

# 查看日志
docker-compose logs -f

# 重启服务
docker-compose restart
```

### 数据库管理

```bash
# 启动数据库管理工具
make start-db-admin

# 直接连接数据库
mysql -u root -p'ServBay.dev' -h 127.0.0.1 -P 3306 genzltd

# 备份数据库
mysqldump -u root -p'ServBay.dev' genzltd > backup.sql

# 恢复数据库
mysql -u root -p'ServBay.dev' genzltd < backup.sql
```

### 开发调试

```bash
# 本地开发模式
./start-dev.sh

# 测试 API
./simple_test.sh

# 查看服务状态
docker-compose ps
```

## 🔍 故障排除

### 1. 数据库连接失败

```bash
# 检查 MySQL 服务
brew services list | grep mysql

# 重启 MySQL
brew services restart mysql

# 测试连接
mysql -u root -p'ServBay.dev' -e "SELECT 1;"
```

### 2. Docker 服务启动失败

```bash
# 检查端口占用
lsof -i :8080
lsof -i :8081

# 清理 Docker 资源
docker-compose down --rmi all --volumes

# 重新构建
docker-compose build --no-cache
```

### 3. 容器无法访问宿主机

```bash
# 检查 Docker 网络
docker network ls

# 重建网络
docker-compose down
docker-compose up -d
```

## 📈 性能优化

### 1. 数据库优化

```sql
-- 优化 MySQL 配置
SET GLOBAL innodb_buffer_pool_size = 1073741824;  -- 1GB
SET GLOBAL max_connections = 200;
```

### 2. Docker 优化

```bash
# 增加 Docker 资源限制
# 在 Docker Desktop 设置中调整内存和 CPU 限制
```

### 3. 应用优化

```bash
# 启用生产模式
export GIN_MODE=release
export NODE_ENV=production
```

## 🔐 安全配置

### 1. 数据库安全

```sql
-- 创建专用用户
CREATE USER 'vuecmf'@'localhost' IDENTIFIED BY 'strong_password';
GRANT ALL PRIVILEGES ON genzltd.* TO 'vuecmf'@'localhost';
FLUSH PRIVILEGES;
```

### 2. 网络安全

```bash
# 限制网络访问
# 在防火墙中只开放必要端口
```

## 📝 监控和日志

### 1. 服务监控

```bash
# 查看服务状态
docker-compose ps

# 查看资源使用
docker stats

# 查看日志
docker-compose logs -f backend-manager
docker-compose logs -f frontend-builder
```

### 2. 数据库监控

```bash
# 查看数据库连接
mysql -u root -p'ServBay.dev' -e "SHOW PROCESSLIST;"

# 查看数据库状态
mysql -u root -p'ServBay.dev' -e "SHOW STATUS;"
```

## 🎯 最佳实践

1. **开发环境**：使用方案一，便于调试和数据管理
2. **生产环境**：根据需求选择方案一或方案二
3. **数据备份**：定期备份数据库
4. **版本控制**：使用 Docker 标签管理版本
5. **监控告警**：设置服务监控和告警

---

**推荐使用方案一（本地数据库 + Docker 服务），既保证了性能，又便于数据管理和开发调试。** 