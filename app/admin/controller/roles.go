package controller

import (
	"Demo/app/middleware"

	"github.com/gin-gonic/gin"
)

// RolesController 角色管理控制器
type RolesController struct {
}

// GetRoles 获取所有角色
func (ctrl *RolesController) GetRoles(c *gin.Context) {
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

// GetUsers 获取角色下所有用户
func (ctrl *RolesController) GetUsers(c *gin.Context) {
	var params struct {
		Data struct {
			RoleName string `json:"role_name" binding:"required"`
		} `json:"data" binding:"required"`
	}

	if err := c.ShouldBindJSON(&params); err != nil {
		c.JSON(400, gin.H{
			"code": 400,
			"msg":  "参数错误: " + err.Error(),
			"data": gin.H{},
		})
		return
	}

	// 使用casbin获取角色下的用户
	users := middleware.GetAllUsers()
	var roleUsers []string
	for _, user := range users {
		userRoles, _ := middleware.GetRolesForUser(user)
		for _, role := range userRoles {
			if role == params.Data.RoleName {
				roleUsers = append(roleUsers, user)
				break
			}
		}
	}

	c.JSON(200, gin.H{
		"code": 0,
		"msg":  "请求成功",
		"data": gin.H{
			"users": roleUsers,
		},
	})
}

// GetPermission 获取角色下所有权限
func (ctrl *RolesController) GetPermission(c *gin.Context) {
	var params struct {
		Data struct {
			RoleName string `json:"role_name" binding:"required"`
		} `json:"data" binding:"required"`
	}

	if err := c.ShouldBindJSON(&params); err != nil {
		c.JSON(400, gin.H{
			"code": 400,
			"msg":  "参数错误: " + err.Error(),
			"data": gin.H{},
		})
		return
	}

	// 使用casbin获取角色的权限
	permissions := middleware.GetPermissionsForRole(params.Data.RoleName)

	c.JSON(200, gin.H{
		"code": 0,
		"msg":  "请求成功",
		"data": gin.H{
			"permissions": permissions,
		},
	})
}

// GetAllUsers 获取所有用户
func (ctrl *RolesController) GetAllUsers(c *gin.Context) {
	// 使用casbin获取所有用户
	users := middleware.GetAllUsers()

	c.JSON(200, gin.H{
		"code": 0,
		"msg":  "请求成功",
		"data": gin.H{
			"users": users,
		},
	})
}
