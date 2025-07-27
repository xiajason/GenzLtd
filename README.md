# VueCMF 内容管理快速开发框架

VueCMF是一款完全开源免费的内容管理快速开发框架。采用前后端分离模式搭建，v3版本前端使用vue3、Element Plus和TypeScript构建，后端API基于Go开发。可用于快速开发CMS、CRM、WMS、OMS、ERP等管理系统，开发简单、高效易用，极大减少系统的开发周期和研发成本！

## 项目结构

```
GenzLtd/
├── main.go                 # Go后端主程序
├── config/                 # 配置文件目录
│   ├── app.yaml           # 应用配置
│   ├── database.yaml      # 数据库配置
│   └── ...
├── app/                    # 应用代码目录
│   ├── home/              # 首页模块
│   ├── middleware/        # 中间件
│   └── route/             # 路由配置
├── views/                  # 模板文件目录
├── static/                 # 静态资源目录
├── uploads/                # 上传文件目录
├── Demo/                   # Vue.js前端项目
│   ├── src/               # 源代码
│   ├── package.json       # 依赖配置
│   └── ...
└── vuecmf-go/             # VueCMF Go框架源码
```

## 环境要求

- **MySQL** >= 5.7
- **Go** >= 1.19
- **Node.js** >= 16.0
- **npm** 或 **yarn**

## 快速开始

### 1. 安装 govuecmf 命令行工具

```bash
go install github.com/vuecmf/govuecmf@latest
```

将Go二进制路径添加到PATH环境变量：

```bash
echo 'export PATH=$PATH:/Users/jason/go/bin' >> ~/.zshrc
source ~/.zshrc
```

### 2. 数据库配置

确保MySQL服务正在运行，然后修改 `config/database.yaml` 文件中的数据库连接信息：

```yaml
connect:
  dev:
    type: mysql
    host: 127.0.0.1
    port: 3306
    user: root
    password: ""  # 根据你的MySQL密码设置
    database: demo
    charset: utf8
    prefix: vuecmf_
```

### 3. 初始化数据库

```bash
govuecmf migrate init
```

这将创建所有必要的数据库表并插入初始数据。

### 4. 修复文件权限（如需要）

如果遇到权限问题，运行以下命令：

```bash
sudo chown -R jason:staff app/ views/ config/
sudo chmod -R 755 app/ views/ config/
```

### 5. 启动后端服务

```bash
go run main.go
```

后端服务将在 `http://localhost:8082` 启动。

### 6. 启动前端服务

```bash
cd Demo
npm run dev
```

前端服务将在 `http://localhost:8081` 启动。

## 访问地址

- **前端管理界面**: http://localhost:8081
- **后端API**: http://localhost:8082

## 默认登录信息

- **用户名**: vuecmf
- **密码**: 123456

## 常见问题解决

### 1. 数据库连接失败

**错误**: `Error 1045 (28000): Access denied for user 'root'@'localhost'`

**解决方案**:
- 检查MySQL服务是否运行: `brew services list | grep mysql`
- 验证数据库连接: `mysql -u root -e "SELECT 1;"`
- 修改 `config/database.yaml` 中的密码配置

### 2. 文件权限问题

**错误**: `permission denied`

**解决方案**:
```bash
sudo chown -R jason:staff app/ views/ config/
sudo chmod -R 755 app/ views/ config/
```

### 3. 路由重复注册

**错误**: `panic: handlers are already registered for path '/home'`

**解决方案**: 检查 `app/route/config.go` 文件中是否有重复的路由组配置。

### 4. 模板文件路径错误

**错误**: `html/template: pattern matches no files: 'views/**/**/*'`

**解决方案**: 确保 `views/` 目录存在且有正确的文件结构。

### 5. 端口冲突

**错误**: 端口被占用

**解决方案**: 修改 `config/app.yaml` 中的 `server_port` 配置。

## 开发命令

### 数据库操作

```bash
# 初始化数据库
govuecmf migrate init

# 升级数据库
govuecmf migrate up

# 回滚数据库
govuecmf migrate down -v [version]
```

### 代码生成

```bash
# 生成应用模块
govuecmf make app -n [app_name]

# 生成控制器
govuecmf make controller -n [name] -m [app_module]

# 生成模型
govuecmf make model -n [name] -m [app_module]

# 生成服务
govuecmf make service -n [name] -m [app_module]
```

### 项目构建

```bash
# 构建前端
cd Demo
npm run build

# 构建后端
go build -o vuecmf-server
```

## 项目特性

- **系统授权**: 多级管理员、多级角色、多级权限
- **应用管理**: 灵活的应用配置和管理
- **模型配置**: 字段、索引、动作、表单的灵活配置
- **菜单配置**: 动态菜单管理
- **前后端分离**: Vue3 + Go的现代化架构
- **快速开发**: 无需编写代码即可构建管理系统

## 技术栈

### 后端
- **Go** >= 1.19
- **Gin** Web框架
- **GORM** ORM框架
- **MySQL** 数据库
- **Casbin** 权限管理

### 前端
- **Vue 3** 框架
- **TypeScript** 语言
- **Element Plus** UI组件库
- **Vite** 构建工具
- **Pinia** 状态管理

## 许可证

MIT License

## 相关链接

- [官方网站](http://www.vuecmf.com)
- [使用文档](http://www.vuecmf.com)
- [GitHub仓库](https://github.com/vuecmf/vuecmf)

## 更新日志

### v3.1.0 (2025-07-27)
- 修复了数据库连接配置问题
- 解决了文件权限问题
- 修复了路由重复注册问题
- 优化了项目启动流程
- 完善了调试文档 