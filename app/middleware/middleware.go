package middleware

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/vuecmf/vuecmf-go/v3/app"
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
						app.Response(ctx).SendFailure("请求失败", err, 1003)
						ctx.Abort()
					}
				}()

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
						app.Response(ctx).SendFailure("请求失败", err, 1003)
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
		{
			// home应用中间件
			GroupName: "/home",
			Middleware: func(ctx *gin.Context) {
				defer func() {
					if err := recover(); err != nil {
						app.Response(ctx).SendFailure("请求失败", err, 1003)
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
