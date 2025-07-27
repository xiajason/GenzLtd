package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/vuecmf/vuecmf-go/v3/app/vuecmf/service"
)

// MenuController 菜单导航控制器
type MenuController struct {
}

// GetNav 获取导航菜单
func (ctrl *MenuController) GetNav(c *gin.Context) {
	// 从token中获取用户信息
	admin, exists := c.Get("admin")
	if !exists {
		c.JSON(401, gin.H{
			"code": 1003,
			"msg":  "您还没有登录，请先登录！",
			"data": gin.H{},
		})
		return
	}
	
	// 获取用户信息
	adminMap := admin.(map[string]interface{})
	username := adminMap["username"].(string)
	isSuper := adminMap["is_super"].(uint16)
	
	// 使用vuecmf-go的菜单服务获取导航菜单
	menuService := service.Menu()
	
	// 获取菜单列表
	menus, err := menuService.Nav(username, isSuper)
	if err != nil {
		c.JSON(500, gin.H{
			"code": 500,
			"msg":  "获取菜单失败: " + err.Error(),
			"data": gin.H{},
		})
		return
	}
	
	c.JSON(200, gin.H{
		"code": 0,
		"msg":  "请求成功",
		"data": gin.H{
			"menus": menus,
		},
	})
}
