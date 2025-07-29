package main

import (
	"log"
	"fmt"
	"os"

	"github.com/casbin/casbin/v2"
	"github.com/gin-gonic/gin"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

type Response struct {
	Message string      `json:"message"`
	Status  string      `json:"status"`
	Data    interface{} `json:"data,omitempty"`
}

type LoginRequest struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

type Admin struct {
	ID       uint   `json:"id"`
	Username string `json:"username"`
	Email    string `json:"email"`
	Status   int    `json:"status"`
}

func initCasbin() *casbin.Enforcer {
	e, err := casbin.NewEnforcer("config/tauthz-rbac-model.conf", "path/to/policy.csv")
	if err != nil {
		log.Printf("Warning: Failed to initialize Casbin: %v", err)
		return nil
	}
	return e
}

func initDB() *gorm.DB {
	// 从环境变量获取数据库配置
	dbHost := getEnv("DB_HOST", "127.0.0.1")
	dbPort := getEnv("DB_PORT", "3306")
	dbUser := getEnv("DB_USER", "root")
	dbPassword := getEnv("DB_PASSWORD", "ServBay.dev")
	dbName := getEnv("DB_NAME", "genzltd")
	
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		dbUser, dbPassword, dbHost, dbPort, dbName)
	
	log.Printf("Connecting to database: %s:%s/%s", dbHost, dbPort, dbName)
	
	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Printf("Warning: Failed to connect to database: %v", err)
		return nil
	}
	
	log.Printf("Database connected successfully")
	return db
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

func main() {
	// 初始化数据库
	db := initDB()

	// 初始化 Casbin
	_ = initCasbin()

	// 初始化 Gin 引擎
	r := gin.Default()

	// 添加 CORS 中间件
	r.Use(func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Content-Type, Authorization")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	})

	// 基础路由
	r.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "Welcome to VueCMF API!",
		})
	})

	// 健康检查端点
	r.GET("/api/health", func(c *gin.Context) {
		c.JSON(200, Response{
			Message: "Backend service is running",
			Status:  "healthy",
		})
	})

	// Hello API 端点
	r.GET("/api/hello", func(c *gin.Context) {
		c.JSON(200, Response{
			Message: "Hello from Go backend!",
			Status:  "success",
		})
	})

	// VueCMF API 路由组
	vuecmf := r.Group("/vuecmf")
	{
		// 管理员登录
		vuecmf.POST("/admin/login", func(c *gin.Context) {
			var req LoginRequest
			if err := c.ShouldBindJSON(&req); err != nil {
				c.JSON(400, Response{
					Message: "Invalid request format",
					Status:  "error",
				})
				return
			}

			// 简单的用户验证（实际项目中应该查询数据库）
			if req.Username == "vuecmf" && req.Password == "123456" {
				c.JSON(200, Response{
					Message: "Login successful",
					Status:  "success",
					Data: gin.H{
						"token": "mock-jwt-token-12345",
						"user": gin.H{
							"id":       1,
							"username": "vuecmf",
							"email":    "admin@vuecmf.com",
						},
					},
				})
			} else {
				c.JSON(401, Response{
					Message: "Invalid credentials",
					Status:  "error",
				})
			}
		})

		// 管理员详情
		vuecmf.POST("/admin/detail", func(c *gin.Context) {
			if db != nil {
				var admin Admin
				result := db.Table("vuecmf_admin").Where("username = ?", "vuecmf").First(&admin)
				if result.Error == nil {
					c.JSON(200, Response{
						Message: "Admin details retrieved",
						Status:  "success",
						Data:    admin,
					})
				} else {
					c.JSON(500, Response{
						Message: "Failed to retrieve admin details",
						Status:  "error",
					})
				}
			} else {
				c.JSON(200, Response{
					Message: "Admin details retrieved",
					Status:  "success",
					Data: gin.H{
						"id":       1,
						"username": "vuecmf",
						"email":    "admin@vuecmf.com",
						"status":   1,
					},
				})
			}
		})

		// 角色列表
		vuecmf.POST("/roles/", func(c *gin.Context) {
			if db != nil {
				var roles []gin.H
				result := db.Table("vuecmf_roles").Find(&roles)
				if result.Error == nil {
					c.JSON(200, Response{
						Message: "Roles retrieved",
						Status:  "success",
						Data:    roles,
					})
				} else {
					c.JSON(500, Response{
						Message: "Failed to retrieve roles",
						Status:  "error",
					})
				}
			} else {
				c.JSON(200, Response{
					Message: "Roles retrieved",
					Status:  "success",
					Data: []gin.H{
						{"id": 1, "name": "超级管理员", "status": 1},
						{"id": 2, "name": "普通管理员", "status": 1},
					},
				})
			}
		})

		// 菜单导航
		vuecmf.POST("/menu/nav", func(c *gin.Context) {
			if db != nil {
				var menus []gin.H
				result := db.Table("vuecmf_menu").Where("status = ?", 1).Find(&menus)
				if result.Error == nil {
					c.JSON(200, Response{
						Message: "Menu navigation retrieved",
						Status:  "success",
						Data:    menus,
					})
				} else {
					c.JSON(500, Response{
						Message: "Failed to retrieve menu navigation",
						Status:  "error",
					})
				}
			} else {
				c.JSON(200, Response{
					Message: "Menu navigation retrieved",
					Status:  "success",
					Data: []gin.H{
						{"id": 1, "name": "首页", "url": "/", "status": 1},
						{"id": 2, "name": "用户管理", "url": "/users", "status": 1},
						{"id": 3, "name": "系统设置", "url": "/settings", "status": 1},
					},
				})
			}
		})
	}

	// 启动服务
	log.Println("🚀 VueCMF server running on :8080")
	log.Println("📋 Available endpoints:")
	log.Println("   - GET  /")
	log.Println("   - POST /vuecmf/admin/login")
	log.Println("   - POST /vuecmf/admin/detail")
	log.Println("   - POST /vuecmf/roles/")
	log.Println("   - POST /vuecmf/menu/nav")

	if err := r.Run(":8080"); err != nil {
		log.Fatal("Failed to start server:", err)
	}
}
