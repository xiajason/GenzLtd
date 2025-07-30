package routes

import (
	"net/http"

	"github.com/vuecmf/vuecmf-go/middleware"
	"github.com/vuecmf/vuecmf-go/services"

	"github.com/gin-gonic/gin"
)

// 定义路由处理函数（分离路由定义和实现）
func healthHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status":  "success",
		"message": "Backend service running",
		"data":    nil,
	})
}

// 登录接口处理函数
func loginHandler(c *gin.Context) {
	// 移除单独的CORS设置

	// 解析请求参数
	var loginData struct {
		Username string `json:"username" binding:"required"`
		Password string `json:"password" binding:"required"`
	}

	if err := c.ShouldBindJSON(&loginData); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"status":  "error",
			"code":    400,
			"message": "无效的请求参数",
			"data":    err.Error(),
		})
		return
	}

	// 这里应该有实际的用户验证逻辑
	// 为演示，我们假设用户名和密码正确
	userID := uint(1)
	username := loginData.Username

	// 生成JWT令牌
	token, err := services.GenerateToken(userID, username)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"status":  "error",
			"code":    500,
			"message": "生成令牌失败",
			"data":    err.Error(),
		})
		return
	}

	// 返回令牌
	c.JSON(http.StatusOK, gin.H{
		"status":  "success",
		"message": "登录成功",
		"data": gin.H{
			"token": token,
		},
	})
}

// 管理员详情接口处理函数
func adminDetailHandler(c *gin.Context) {
	// 移除单独的CORS设置

	response := gin.H{
		"status":  "success",
		"message": "Admin details retrieved",
		"data": gin.H{
			"id":    1,
			"name":  "Administrator",
			"email": "admin@example.com",
		},
	}
	c.JSON(http.StatusOK, response)
}

// 角色列表接口处理函数
func rolesHandler(c *gin.Context) {
	// 移除单独的CORS设置

	response := gin.H{
		"status":  "success",
		"message": "Roles retrieved",
		"data": []gin.H{
			{"id": 1, "name": "Admin"},
			{"id": 2, "name": "Editor"},
			{"id": 3, "name": "Viewer"},
		},
	}
	c.JSON(http.StatusOK, response)
}

// 菜单导航接口处理函数
func menuHandler(c *gin.Context) {
	// 移除单独的CORS设置

	response := gin.H{
		"status":  "success",
		"message": "Menu retrieved",
		"data": []gin.H{
			{
				"id":   1,
				"name": "Dashboard",
				"path": "/dashboard",
				"icon": "dashboard",
			},
			{
				"id":   2,
				"name": "Users",
				"path": "/users",
				"icon": "users",
			},
			{
				"id":   3,
				"name": "Settings",
				"path": "/settings",
				"icon": "settings",
			},
		},
	}
	c.JSON(http.StatusOK, response)
}

func helloHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "Hello from Go backend!",
		"status":  "success",
	})
}

func rootHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status":  "success",
		"message": "VueCMF API 服务",
		"data":    "running",
	})
}

// RegisterRoutes 注册所有路由
func RegisterRoutes(r *gin.Engine) {
	// 基础API路由组
	api := r.Group("/vuecmf")
	{
		// 公开路由
		api.GET("/", rootHandler)
		api.GET("/health", healthHandler)
		api.GET("/hello", helloHandler)
		api.POST("/login", loginHandler)

		// 需要认证的路由组
		auth := api.Group("")
		auth.Use(middleware.AuthMiddleware())
		{
			auth.GET("/admin/detail", adminDetailHandler)
			auth.GET("/roles", rolesHandler)
			auth.GET("/menu", menuHandler)
		}
	}

	// 添加 /api 路由组
	apiGroup := r.Group("/api")
	{
		apiGroup.GET("/health", healthHandler)
		apiGroup.GET("/hello", helloHandler)
	}

	// 注册404路由（放在最后，捕获所有未匹配的路由）
	r.NoRoute(func(c *gin.Context) {
		c.JSON(http.StatusNotFound, gin.H{
			"error": "接口未找到",
			"code":  404,
		})
	})
}