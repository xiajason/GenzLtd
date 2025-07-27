package route

import (
	homeCtrl "Demo/app/home/controller"

	"github.com/vuecmf/vuecmf-go/v3/app/route"
)

func Config() []route.RoutesGroup {
	// 配置路由
	return []route.RoutesGroup{
		{
			GroupName: "/home",
			//Get请求路由
			Get: []route.Route{
				{
					Path:       "",
					Controller: homeCtrl.Index(),
				},
			},
			//Post请求路由
			Post: []route.Route{
				{
					Path:       "/index/*action",
					Controller: homeCtrl.Index(),
				},
			},
		},
	}
}
