package main

import (
	"Demo/app/middleware"
	"Demo/app/route"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/vuecmf/vuecmf-go/v3/app"
	sysRoute "github.com/vuecmf/vuecmf-go/v3/app/route"
)

func main() {
	cfg := app.Config()

	if cfg.Debug == false {
		gin.SetMode(gin.ReleaseMode)
	}

	// 初始化Casbin权限管理器
	err := middleware.InitCasbin()
	if err != nil {
		log.Printf("Casbin初始化失败: %v", err)
	} else {
		log.Println("Casbin权限管理器初始化成功")
	}

	engine := gin.Default()

	//注册中间件及路由
	sysRoute.Register(engine, cfg, middleware.Middleware(), route.Config())

	// 在VueCMF框架注册路由后添加根路径重定向
	engine.GET("/", func(c *gin.Context) {
		c.Redirect(http.StatusMovedPermanently, "/home")
	})

	// 注意：权限管理接口已通过vuecmf-go框架提供
	// 修复方案：使用casbin进行权限管理，但保持原有路由结构

	err = engine.Run(":" + cfg.ServerPort)
	if err != nil {
		log.Fatal("服务启动失败！", err)
	}

}


