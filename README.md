# GenzLtd 内容管理快速开发框架

GenzLtd是一款完全开源免费的内容管理快速开发框架。采用前后端分离模式搭建，v3版本前端使用vue3、Element Plus和TypeScript构建，后端API基于Go开发。可用于快速开发CMS、CRM、WMS、OMS、ERP等管理系统，开发简单、高效易用，极大减少系统的开发周期和研发成本！

## 🎉 最新状态

**✅ 系统已完全修复并正常运行！**

- ✅ Casbin权限管理系统正常初始化
- ✅ 数据库连接和查询正常
- ✅ 前后端分离架构正常工作
- ✅ 登录验证和安全机制完善
- ✅ 所有核心功能正常运行

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
    database: genzltd  # 注意：数据库名已更新为genzltd
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

## 🚀 访问地址

### ✅ 正确的访问方式：

- **前端管理界面**: http://localhost:8081
- **登录页面**: http://localhost:8081/#/login
- **后端API**: http://localhost:8082/vuecmf 或 http://localhost:8082/home

### ⚠️ 注意事项：

- **不要直接访问**: `http://localhost:8082/` (会返回错误，但不影响系统使用)
- **使用前端界面**: 推荐通过 `http://localhost:8081` 访问系统

## 默认登录信息

- **用户名**: vuecmf
- **密码**: 123456

## 🔧 已修复的问题

### 1. Casbin权限管理初始化错误
- **问题**: `invalid bool value: Truevuecmf_`
- **解决**: 修复了数据库连接字符串和表名配置

### 2. 端口冲突问题
- **问题**: 端口8082被占用
- **解决**: 添加了端口检查和进程管理

### 3. 登录验证Bug
- **问题**: 直接访问根路径可进入后台，登录页面反而进不去
- **解决**: 添加了token有效性验证，修复了路由守卫逻辑

### 4. Nil指针错误
- **问题**: 运行时出现nil指针解引用错误
- **解决**: 添加了完善的nil检查和错误处理机制

### 5. 时区配置问题
- **问题**: 数据库时区配置错误
- **解决**: 优化了数据库连接参数

## 常见问题解决

### 1. 数据库连接失败

**错误**: `Error 1045 (28000): Access denied for user 'root'@'localhost'`

**解决方案**:
- 检查MySQL服务是否运行: `brew services list | grep mysql`
- 验证数据库连接: `mysql -u root -e "SELECT 1;"`
- 修改 `config/database.yaml` 中的密码配置

### 2. 端口冲突

**错误**: `listen tcp :8082: bind: address already in use`

**解决方案**:
```bash
# 查看占用端口的进程
lsof -i :8082

# 杀死占用进程
kill [PID]

# 或者修改端口配置
# 编辑 config/app.yaml 中的 server_port
```

### 3. Casbin初始化失败

**错误**: `Casbin初始化失败: invalid bool value`

**解决方案**:
- 确保数据库表结构正确
- 检查数据库连接字符串
- 验证表前缀配置

### 4. 前端登录问题

**问题**: 登录页面无法正常进入后台

**解决方案**:
- 清除浏览器缓存和localStorage
- 使用正确的登录地址: `http://localhost:8081/#/login`
- 确保后端API正常运行

### 5. 根路径访问错误

**错误**: 访问 `http://localhost:8082/` 返回错误

**解决方案**:
- 这是已知问题，不影响系统正常使用
- 使用正确的访问地址: `http://localhost:8081` 或 `http://localhost:8082/vuecmf`

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
- **安全验证**: 完善的token验证和权限控制

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
感谢在前辈的帮助下，构建了GenzLtd的基础，我们将不断完善功能，给新生代提供更为高效便捷的个人发布平台系统。
- [官方网站](http://www.vuecmf.com)
- [使用文档](http://www.vuecmf.com)
- [GitHub仓库](https://github.com/vuecmf/vuecmf)

## 更新日志

### v3.1.1 (2025-07-27) - 重大修复版本
- ✅ 修复了Casbin权限管理初始化错误
- ✅ 解决了端口冲突问题
- ✅ 修复了登录验证Bug和路由守卫逻辑
- ✅ 添加了完善的nil指针检查和错误处理
- ✅ 优化了数据库时区配置
- ✅ 完善了系统安全验证机制
- ✅ 更新了项目文档和使用说明

### v3.1.0 (2025-07-27)
- 修复了数据库连接配置问题
- 解决了文件权限问题
- 修复了路由重复注册问题
- 优化了项目启动流程
- 完善了调试文档
