# VueCMF API 文档

## 基础信息
- 基础URL: `/vuecmf`
- 认证方式: JWT Token (Bearer Token)
- 响应格式: JSON

## 公共接口

### 健康检查
- **URL**: `/health`
- **Method**: GET
- **响应示例**:
```json
{
  "status": "success",
  "message": "Backend service running",
  "data": null
}
```

### 登录
- **URL**: `/login`
- **Method**: POST
- **请求体**:
```json
{
  "username": "string",
  "password": "string"
}
```
- **响应示例**:
```json
{
  "status": "success",
  "message": "登录成功",
  "data": {
    "token": "jwt_token_here"
  }
}
```

## 需要认证的接口
> 所有需要认证的接口都需要在请求头中添加: `Authorization: Bearer {token}`

### 获取管理员详情
- **URL**: `/admin/detail`
- **Method**: GET
- **响应示例**:
```json
{
  "status": "success",
  "message": "Admin details retrieved",
  "data": {
    "id": 1,
    "name": "Administrator",
    "email": "admin@example.com"
  }
}
```

### 获取角色列表
- **URL**: `/roles`
- **Method**: GET
- **响应示例**:
```json
{
  "status": "success",
  "message": "Roles retrieved",
  "data": [
    {"id": 1, "name": "Admin"},
    {"id": 2, "name": "Editor"},
    {"id": 3, "name": "Viewer"}
  ]
}
```

### 获取菜单导航
- **URL**: `/menu`
- **Method**: GET
- **响应示例**:
```json
{
  "status": "success",
  "message": "Menu retrieved",
  "data": [
    {
      "id": 1,
      "name": "Dashboard",
      "path": "/dashboard",
      "icon": "dashboard"
    },
    {
      "id": 2,
      "name": "Users",
      "path": "/users",
      "icon": "users"
    },
    {
      "id": 3,
      "name": "Settings",
      "path": "/settings",
      "icon": "settings"
    }
  ]
}
```

## 响应状态码说明
- `200`: 请求成功
- `400`: 请求参数错误
- `401`: 未授权或token无效
- `404`: 接口未找到
- `500`: 服务器内部错误

## 错误响应格式
```json
{
  "status": "error",
  "code": 错误码,
  "message": "错误描述",
  "data": 错误详情
}
```