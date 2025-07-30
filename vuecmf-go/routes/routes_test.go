package routes

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

// TestRegisterRoutes 测试路由注册是否正确
func TestRegisterRoutes(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := gin.Default()
	RegisterRoutes(router)

	// 测试路由数量
	routes := router.Routes()
	assert.Greater(t, len(routes), 0, "应该注册至少一个路由")
}

// TestPublicRoutes 测试公开路由是否无需认证即可访问
func TestPublicRoutes(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := gin.Default()
	RegisterRoutes(router)

	// 测试健康检查接口
	w := httptest.NewRecorder()
	r, _ := http.NewRequest("GET", "/vuecmf/health", nil)
	router.ServeHTTP(w, r)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "success")

	// 测试登录接口
	w = httptest.NewRecorder()
	r, _ = http.NewRequest("POST", "/vuecmf/login", nil)
	router.ServeHTTP(w, r)

	assert.Equal(t, http.StatusBadRequest, w.Code) // 缺少参数应该返回400
	assert.Contains(t, w.Body.String(), "error")
}

// TestProtectedRoutes 测试需要认证的路由
func TestProtectedRoutes(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := gin.Default()
	RegisterRoutes(router)

	// 未认证访问受保护接口
	w := httptest.NewRecorder()
	r, _ := http.NewRequest("GET", "/vuecmf/admin/detail", nil)
	router.ServeHTTP(w, r)

	assert.Equal(t, http.StatusUnauthorized, w.Code)
	assert.Contains(t, w.Body.String(), "error")
}
