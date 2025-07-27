package middleware

import (
	"fmt"
	"net/http"
	"strings"

	"github.com/casbin/casbin/v2"
	"github.com/casbin/casbin/v2/model"
	gormadapter "github.com/casbin/gorm-adapter/v3"
	"github.com/gin-gonic/gin"
	"github.com/vuecmf/vuecmf-go/v3/app/vuecmf/service"
)

var enforcer *casbin.Enforcer

// InitCasbin 初始化Casbin权限管理器
func InitCasbin() error {
	// 创建GORM适配器，指定正确的表名
	adapter, err := gormadapter.NewAdapter("mysql", "root:@tcp(127.0.0.1:3306)/genzltd?charset=utf8&parseTime=True", "vuecmf_", "casbin_rule")
	if err != nil {
		return err
	}

	// 创建RBAC模型 - 使用4参数模型匹配配置文件
	text := `
[request_definition]
r = sub, dom, obj, act

[policy_definition]
p = sub, dom, obj, act

[role_definition]
g = _, _, _

[policy_effect]
e = some(where (p.eft == allow))

[matchers]
m = g(r.sub, p.sub, r.dom) && r.dom == p.dom && r.obj == p.obj && r.act == p.act
`
	m, err := model.NewModelFromString(text)
	if err != nil {
		return err
	}

	// 创建enforcer
	enforcer, err = casbin.NewEnforcer(m, adapter)
	if err != nil {
		return err
	}

	// 加载策略
	err = enforcer.LoadPolicy()
	if err != nil {
		return err
	}

	return nil
}

// AuthMiddleware Casbin权限验证中间件
func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 检查enforcer是否已初始化
		if enforcer == nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"code": 500,
				"msg":  "权限管理器未初始化",
				"data": gin.H{},
			})
			c.Abort()
			return
		}

		// 获取token
		token := c.GetHeader("token")
		if token == "" {
			c.JSON(http.StatusUnauthorized, gin.H{
				"code": 1003,
				"msg":  "您还没有登录，请先登录！",
				"data": gin.H{},
			})
			c.Abort()
			return
		}

		// 验证token并获取用户信息
		adminService := service.Admin()
		admin, err := adminService.IsLogin(token, c.ClientIP())
		if err != nil || admin == nil {
			c.JSON(http.StatusUnauthorized, gin.H{
				"code": 1003,
				"msg":  "登录已过期，请重新登录！",
				"data": gin.H{},
			})
			c.Abort()
			return
		}

		// 超级管理员跳过权限验证
		if admin.IsSuper == 10 {
			c.Set("admin", admin)
			c.Next()
			return
		}

		// 获取请求的路径和方法
		obj := c.Request.URL.Path
		act := strings.ToLower(c.Request.Method)
		dom := "genzltd" // 使用默认域名

		// 检查权限
		ok, err := enforcer.Enforce(admin.Username, dom, obj, act)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"code": 500,
				"msg":  "权限验证失败",
				"data": gin.H{},
			})
			c.Abort()
			return
		}

		if !ok {
			c.JSON(http.StatusForbidden, gin.H{
				"code": 1004,
				"msg":  "没有访问权限",
				"data": gin.H{},
			})
			c.Abort()
			return
		}

		// 将用户信息存储到上下文中
		c.Set("admin", admin)
		c.Next()
	}
}

// GetEnforcer 获取Casbin enforcer实例
func GetEnforcer() *casbin.Enforcer {
	return enforcer
}

// AddRoleForUser 为用户添加角色
func AddRoleForUser(username, role string) error {
	if enforcer == nil {
		return fmt.Errorf("enforcer not initialized")
	}
	dom := "genzltd" // 使用默认域名
	_, err := enforcer.AddGroupingPolicy(username, role, dom)
	return err
}

// RemoveRoleForUser 移除用户角色
func RemoveRoleForUser(username, role string) error {
	if enforcer == nil {
		return fmt.Errorf("enforcer not initialized")
	}
	dom := "genzltd" // 使用默认域名
	_, err := enforcer.RemoveFilteredGroupingPolicy(0, username, role, dom)
	return err
}

// GetRolesForUser 获取用户的所有角色
func GetRolesForUser(username string) ([]string, error) {
	if enforcer == nil {
		return nil, fmt.Errorf("enforcer not initialized")
	}
	dom := "genzltd" // 使用默认域名
	roles := enforcer.GetRolesForUserInDomain(username, dom)
	return roles, nil
}

// AddPermissionForRole 为角色添加权限
func AddPermissionForRole(role, obj, act string) error {
	if enforcer == nil {
		return fmt.Errorf("enforcer not initialized")
	}
	dom := "genzltd" // 使用默认域名
	_, err := enforcer.AddPolicy(role, dom, obj, act)
	return err
}

// RemovePermissionForRole 移除角色权限
func RemovePermissionForRole(role, obj, act string) error {
	if enforcer == nil {
		return fmt.Errorf("enforcer not initialized")
	}
	dom := "genzltd" // 使用默认域名
	_, err := enforcer.RemovePolicy(role, dom, obj, act)
	return err
}

// GetPermissionsForRole 获取角色的所有权限
func GetPermissionsForRole(role string) [][]string {
	if enforcer == nil {
		return nil
	}
	policies, _ := enforcer.GetPolicy()
	var rolePolicies [][]string
	dom := "genzltd" // 使用默认域名
	for _, policy := range policies {
		if len(policy) > 1 && policy[0] == role && policy[1] == dom {
			rolePolicies = append(rolePolicies, policy)
		}
	}
	return rolePolicies
}

// GetAllRoles 获取所有角色
func GetAllRoles() []string {
	if enforcer == nil {
		return nil
	}
	roles, _ := enforcer.GetAllRoles()
	return roles
}

// GetAllUsers 获取所有用户
func GetAllUsers() []string {
	if enforcer == nil {
		return nil
	}
	users, _ := enforcer.GetAllSubjects()
	return users
}
