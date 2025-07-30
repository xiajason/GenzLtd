package main

import (
	"log"
	"os"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"

	// {{ edit_1: Update import paths to match your module name }}
	"github.com/vuecmf/vuecmf-go/config" // Use full module path
	"github.com/vuecmf/vuecmf-go/routes" // Use full module path
)

func main() {
	// 初始化配置
	config.InitDB()
	defer func() {
		sqlDB, _ := config.DB.DB()
		sqlDB.Close()
	}()

	// 设置GIN模式
	ginMode := os.Getenv("GIN_MODE")
	if ginMode == "" {
		ginMode = gin.DebugMode
	}
	gin.SetMode(ginMode)

	// 初始化GIN引擎
	r := gin.Default()

	// 配置CORS
	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"http://localhost:8081"},
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Accept", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}))

	// 注册路由
	routes.RegisterRoutes(r)

	// 启动服务
	port := os.Getenv("BACKEND_PORT")
	if port == "" {
		port = "8080" // 默认端口修改为8080
	}
	log.Printf("后端服务启动: http://localhost:%s", port)
	if err := r.Run(":" + port); err != nil {
		log.Fatalf("服务启动失败: %v", err)
	}
}

// DELETE THESE LINES AT THE BOTTOM OF THE FILE
// 正确导入方式（使用本地模块路径）
