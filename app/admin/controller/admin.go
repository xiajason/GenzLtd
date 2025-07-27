package controller

import (
	"Demo/app/middleware"

	"github.com/gin-gonic/gin"
)

// AdminController 管理员权限控制器
type AdminController struct {
}

// GetAllRoles 获取所有角色
func (ctrl *AdminController) GetAllRoles(c *gin.Context) {
	// 使用casbin获取所有角色
	roles := middleware.GetAllRoles()

	c.JSON(200, gin.H{
		"code": 0,
		"msg":  "请求成功",
		"data": gin.H{
			"roles": roles,
		},
	})
}

// GetRoles 获取用户角色
func (ctrl *AdminController) GetRoles(c *gin.Context) {
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

	// 获取用户角色
	adminMap := admin.(map[string]interface{})
	username := adminMap["username"].(string)

	roles, err := middleware.GetRolesForUser(username)
	if err != nil {
		c.JSON(500, gin.H{
			"code": 500,
			"msg":  "获取用户角色失败",
			"data": gin.H{},
		})
		return
	}

	c.JSON(200, gin.H{
		"code": 0,
		"msg":  "请求成功",
		"data": gin.H{
			"roles": roles,
		},
	})
}

// GetUserPermission 获取用户权限
func (ctrl *AdminController) GetUserPermission(c *gin.Context) {
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

	// 获取用户角色
	adminMap := admin.(map[string]interface{})
	username := adminMap["username"].(string)

	// 获取用户的所有角色
	roles, err := middleware.GetRolesForUser(username)
	if err != nil {
		c.JSON(500, gin.H{
			"code": 500,
			"msg":  "获取用户角色失败",
			"data": gin.H{},
		})
		return
	}

	// 获取所有角色的权限
	var allPermissions [][]string
	for _, role := range roles {
		permissions := middleware.GetPermissionsForRole(role)
		allPermissions = append(allPermissions, permissions...)
	}

	c.JSON(200, gin.H{
		"code": 0,
		"msg":  "请求成功",
		"data": gin.H{
			"permissions": allPermissions,
		},
	})
}
