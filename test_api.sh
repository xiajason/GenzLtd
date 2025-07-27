#!/bin/bash

# GenzLtd API 自动化测试脚本
# 测试所有登录相关的接口

BASE_URL="http://localhost:8082"
TOKEN=""
TEST_COUNT=0
SUCCESS_COUNT=0
FAIL_COUNT=0

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
    ((SUCCESS_COUNT++))
    ((TEST_COUNT++))
}

error() {
    echo -e "${RED}❌ $1${NC}"
    ((FAIL_COUNT++))
    ((TEST_COUNT++))
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# 测试函数
test_api() {
    local method=$1
    local url=$2
    local data=$3
    local description=$4
    local expected_status=${5:-200}
    
    log "测试: $description"
    
    local response
    local status_code
    
    if [ "$method" = "GET" ]; then
        if [ -n "$TOKEN" ]; then
            response=$(curl -s -w "\n%{http_code}" -H "token: $TOKEN" "$BASE_URL$url")
        else
            response=$(curl -s -w "\n%{http_code}" "$BASE_URL$url")
        fi
    else
        if [ -n "$TOKEN" ]; then
            response=$(curl -s -w "\n%{http_code}" -X POST -H "Content-Type: application/json" -H "token: $TOKEN" -d "$data" "$BASE_URL$url")
        else
            response=$(curl -s -w "\n%{http_code}" -X POST -H "Content-Type: application/json" -d "$data" "$BASE_URL$url")
        fi
    fi
    
    # 提取状态码（最后一行）
    status_code=$(echo "$response" | tail -n1)
    # 提取响应内容（除最后一行）
    response_body=$(echo "$response" | head -n -1)
    
    if [ "$status_code" = "$expected_status" ]; then
        success "$description - 成功 (状态码: $status_code)"
        echo "响应: ${response_body:0:200}..."
    else
        error "$description - 失败 (状态码: $status_code, 期望: $expected_status)"
        echo "响应: ${response_body:0:200}..."
    fi
    
    echo ""
}

# 测试登录并获取token
test_login() {
    log "开始测试登录接口..."
    
    local login_data='{"data":{"login_name":"vuecmf","password":"123456"}}'
    local response=$(curl -s -X POST -H "Content-Type: application/json" -d "$login_data" "$BASE_URL/vuecmf/admin/login")
    
    # 检查是否包含token
    if echo "$response" | grep -q "token"; then
        TOKEN=$(echo "$response" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
        success "登录成功，获取到token: ${TOKEN:0:20}..."
        return 0
    else
        error "登录失败，响应: ${response:0:200}..."
        return 1
    fi
}

# 主测试函数
run_tests() {
    echo "============================================================"
    echo "开始 GenzLtd API 自动化测试"
    echo "============================================================"
    
    # 1. 测试登录
    if ! test_login; then
        error "登录失败，无法继续测试其他接口"
        return 1
    fi
    
    # 2. 测试管理员相关接口
    log "开始测试管理员相关接口..."
    test_api "POST" "/vuecmf/admin/detail" '{"data":{}}' "获取管理员详情"
    test_api "POST" "/vuecmf/admin/get_all_roles" '{"data":{}}' "获取所有角色"
    test_api "POST" "/vuecmf/admin/get_roles" '{"data":{}}' "获取用户角色"
    test_api "POST" "/vuecmf/admin/get_user_permission" '{"data":{}}' "获取用户权限"
    
    # 3. 测试角色管理接口
    log "开始测试角色管理接口..."
    test_api "POST" "/vuecmf/roles/" '{"data":{}}' "获取角色列表"
    test_api "POST" "/vuecmf/roles/get_users" '{"data":{}}' "获取角色下所有用户"
    test_api "POST" "/vuecmf/roles/get_permission" '{"data":{}}' "获取角色下所有权限"
    test_api "POST" "/vuecmf/roles/get_all_users" '{"data":{}}' "获取所有用户"
    
    # 4. 测试应用配置接口
    log "开始测试应用配置接口..."
    test_api "POST" "/vuecmf/app_config/" '{"data":{}}' "获取应用配置列表"
    test_api "POST" "/vuecmf/app_config/dropdown" '{"data":{}}' "获取应用下拉列表"
    
    # 5. 测试模型配置接口
    log "开始测试模型配置接口..."
    test_api "POST" "/vuecmf/model_config/" '{"data":{}}' "获取模型配置列表"
    test_api "POST" "/vuecmf/model_config/dropdown" '{"data":{}}' "获取模型下拉列表"
    test_api "POST" "/vuecmf/model_action/" '{"data":{}}' "获取模型动作列表"
    test_api "POST" "/vuecmf/model_action/get_action_list" '{"data":{}}' "获取动作列表"
    test_api "POST" "/vuecmf/model_field/" '{"data":{}}' "获取模型字段列表"
    test_api "POST" "/vuecmf/model_field/dropdown" '{"data":{}}' "获取字段下拉列表"
    
    # 6. 测试菜单配置接口
    log "开始测试菜单配置接口..."
    test_api "POST" "/vuecmf/menu/" '{"data":{}}' "获取菜单列表"
    test_api "POST" "/vuecmf/menu/nav" '{"data":{}}' "获取导航菜单"
    
    # 7. 测试首页接口
    log "开始测试首页接口..."
    test_api "GET" "/home" "" "访问首页"
    test_api "POST" "/home/index/success" '{"data":{}}' "首页成功接口"
    
    # 8. 测试VueCMF系统接口
    log "开始测试VueCMF系统接口..."
    test_api "GET" "/vuecmf" "" "访问VueCMF系统首页"
    test_api "POST" "/vuecmf/index/success" '{"data":{}}' "VueCMF成功接口"
    
    # 9. 测试退出登录接口
    log "开始测试退出登录接口..."
    test_api "POST" "/vuecmf/admin/logout" '{"data":{"token":"'$TOKEN'"}}' "退出登录"
    
    # 生成测试报告
    generate_report
}

# 生成测试报告
generate_report() {
    echo "============================================================"
    echo "测试报告"
    echo "============================================================"
    echo "总测试数: $TEST_COUNT"
    echo -e "${GREEN}成功: $SUCCESS_COUNT${NC}"
    echo -e "${RED}失败: $FAIL_COUNT${NC}"
    
    if [ $TEST_COUNT -gt 0 ]; then
        local success_rate=$(echo "scale=1; $SUCCESS_COUNT * 100 / $TEST_COUNT" | bc -l 2>/dev/null || echo "0")
        echo "成功率: ${success_rate}%"
    fi
    
    # 保存报告到文件
    cat > api_test_report.txt << EOF
GenzLtd API 测试报告
生成时间: $(date)
============================================================
总测试数: $TEST_COUNT
成功: $SUCCESS_COUNT
失败: $FAIL_COUNT
成功率: ${success_rate}%
============================================================
EOF
    
    log "详细报告已保存到: api_test_report.txt"
}

# 检查依赖
check_dependencies() {
    if ! command -v curl &> /dev/null; then
        error "curl 未安装，请先安装 curl"
        exit 1
    fi
    
    if ! command -v bc &> /dev/null; then
        warning "bc 未安装，成功率计算可能不准确"
    fi
}

# 主函数
main() {
    check_dependencies
    
    if [ $# -gt 0 ]; then
        BASE_URL="$1"
    fi
    
    log "使用API地址: $BASE_URL"
    
    # 检查服务是否运行
    if ! curl -s "$BASE_URL" > /dev/null 2>&1; then
        error "无法连接到 $BASE_URL，请确保服务正在运行"
        exit 1
    fi
    
    run_tests
}

# 运行主函数
main "$@" 