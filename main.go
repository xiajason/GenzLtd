package main

import (
	"github.com/gin-gonic/gin"
	"github.com/vuecmf/vuecmf-go/v3/app"
	sysRoute "github.com/vuecmf/vuecmf-go/v3/app/route"
	"log"
    "Demo/app/middleware"
	"Demo/app/route"
)

func main() {
	cfg := app.Config()

	if cfg.Debug == false {
		gin.SetMode(gin.ReleaseMode)
	}

	engine := gin.Default()

	//注册中间件及路由
	sysRoute.Register(engine, cfg, middleware.Middleware(), route.Config())

	err := engine.Run(":" + cfg.ServerPort)
	if err != nil {
		log.Fatal("服务启动失败！", err)
	}

}
