package middleware

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/vuecmf/vuecmf-go/v3/app/route"
)

func Middleware() []route.MiddlewareGroup {
	return []route.MiddlewareGroup{
		{
			// 全局中间件
			GroupName: "/",
			Middleware: func(ctx *gin.Context) {
				defer func() {
					if err := recover(); err != nil {
						// 使用更安全的错误处理方式
						ctx.JSON(500, gin.H{
							"code": 1003,
							"msg":  "请求失败",
							"data": fmt.Sprintf("%v", err),
						})
						ctx.Abort()
					}
				}()

				// 处理根路径
				if ctx.Request.URL.Path == "/" {
					ctx.JSON(200, gin.H{
						"code": 0,
						"msg":  "欢迎使用VueCMF",
						"data": gin.H{
							"redirect": "/home",
						},
					})
					ctx.Abort()
					return
				}

				fmt.Println("全局中间件")

				url := ctx.Request.URL.String()
				fmt.Println("url:", url)

				token := ctx.Request.Header.Get("token")
				fmt.Println("token:", token)

			},
		},
		{
			// home应用中间件
			GroupName: "/home",
			Middleware: func(ctx *gin.Context) {
				defer func() {
					if err := recover(); err != nil {
						// 使用更安全的错误处理方式
						ctx.JSON(500, gin.H{
							"code": 1003,
							"msg":  "请求失败",
							"data": fmt.Sprintf("%v", err),
						})
						ctx.Abort()
					}
				}()

				fmt.Println("home应用中间件")

				url := ctx.Request.URL.String()
				fmt.Println("url:", url)

				token := ctx.Request.Header.Get("token")
				fmt.Println("token:", token)

			},
		},
	}
}
