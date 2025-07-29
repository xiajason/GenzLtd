# VueCMF 个性化开发模板

## 🎨 模板概述

本目录包含用于个性化开发的模板文件，帮助开发者快速定制和扩展 VueCMF 项目。

## 📁 模板结构

```
templates/
├── components/          # Vue 组件模板
├── pages/              # 页面模板
├── api/                # API 接口模板
├── database/           # 数据库模板
├── docker/             # Docker 配置模板
└── config/             # 配置文件模板
```

## 🚀 快速开始

### 1. 使用组件模板

```bash
# 创建新组件
cp templates/components/VueComponent.vue vuecmf-web/frontend/src/components/MyComponent.vue

# 创建新页面
cp templates/pages/VuePage.vue vuecmf-web/frontend/src/views/MyPage.vue
```

### 2. 使用 API 模板

```bash
# 创建新 API 接口
cp templates/api/GoAPI.go vuecmf-go/api/myapi.go
```

### 3. 使用数据库模板

```bash
# 创建数据库迁移
cp templates/database/migration.sql migrations/my_migration.sql
```

## 📋 可用模板

### Vue 组件模板

- `VueComponent.vue` - 基础 Vue 3 组件
- `VueForm.vue` - 表单组件
- `VueTable.vue` - 表格组件
- `VueModal.vue` - 模态框组件

### 页面模板

- `VuePage.vue` - 基础页面
- `VueListPage.vue` - 列表页面
- `VueDetailPage.vue` - 详情页面
- `VueFormPage.vue` - 表单页面

### API 接口模板

- `GoAPI.go` - 基础 API 接口
- `GoCRUD.go` - CRUD 操作接口
- `GoAuth.go` - 认证接口

### 数据库模板

- `migration.sql` - 数据库迁移
- `seed.sql` - 数据种子
- `schema.sql` - 数据库结构

### Docker 模板

- `Dockerfile.dev` - 开发环境 Dockerfile
- `Dockerfile.prod` - 生产环境 Dockerfile
- `docker-compose.dev.yml` - 开发环境配置
- `docker-compose.prod.yml` - 生产环境配置

## 🛠️ 自定义模板

### 1. 创建新模板

```bash
# 创建组件模板
cat > templates/components/MyCustomComponent.vue << 'EOF'
<template>
  <div class="my-custom-component">
    <!-- 你的组件内容 -->
  </div>
</template>

<script>
export default {
  name: 'MyCustomComponent',
  // 组件逻辑
}
</script>

<style scoped>
/* 组件样式 */
</style>
EOF
```

### 2. 使用模板变量

模板支持以下变量替换：

- `{{COMPONENT_NAME}}` - 组件名称
- `{{AUTHOR_NAME}}` - 作者名称
- `{{PROJECT_NAME}}` - 项目名称
- `{{DATE}}` - 当前日期

### 3. 批量生成

```bash
# 生成多个组件
for component in Button Card Input; do
  sed "s/{{COMPONENT_NAME}}/$component/g" templates/components/VueComponent.vue > vuecmf-web/frontend/src/components/${component}.vue
done
```

## 📝 最佳实践

### 1. 组件开发

- 使用 Composition API
- 添加 TypeScript 支持
- 包含单元测试
- 添加文档注释

### 2. API 开发

- 遵循 RESTful 规范
- 添加参数验证
- 包含错误处理
- 添加日志记录

### 3. 数据库设计

- 使用合适的字段类型
- 添加索引优化
- 包含外键约束
- 添加注释说明

## 🔧 工具脚本

### 1. 模板生成器

```bash
# 生成组件
./scripts/generate-component.sh MyComponent

# 生成页面
./scripts/generate-page.sh MyPage

# 生成 API
./scripts/generate-api.sh MyAPI
```

### 2. 代码格式化

```bash
# 格式化 Vue 文件
npm run format:vue

# 格式化 Go 文件
npm run format:go

# 格式化所有文件
npm run format:all
```

## 📚 示例项目

### 1. 博客系统

```bash
# 创建博客相关组件
cp templates/components/VueForm.vue vuecmf-web/frontend/src/components/BlogForm.vue
cp templates/pages/VueListPage.vue vuecmf-web/frontend/src/views/BlogList.vue
cp templates/api/GoCRUD.go vuecmf-go/api/blog.go
```

### 2. 用户管理系统

```bash
# 创建用户管理相关文件
cp templates/components/VueTable.vue vuecmf-web/frontend/src/components/UserTable.vue
cp templates/pages/VueDetailPage.vue vuecmf-web/frontend/src/views/UserDetail.vue
cp templates/api/GoAuth.go vuecmf-go/api/user.go
```

## 🎯 扩展建议

### 1. 添加新模板类型

- 移动端组件模板
- 管理后台模板
- 数据可视化模板
- 第三方集成模板

### 2. 模板管理系统

- 在线模板编辑器
- 模板版本控制
- 模板分享平台
- 模板评分系统

### 3. 自动化工具

- 代码生成器
- 脚手架工具
- 插件系统
- 热重载支持

## 📞 支持

如有问题或建议，请：

1. 查看 [DEPLOYMENT_GUIDE.md](../DEPLOYMENT_GUIDE.md)
2. 提交 Issue 到 GitHub
3. 参与社区讨论

---

**让开发更简单，让创意更自由！** 🚀 