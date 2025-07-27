#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
GenzLtd API 自动化测试脚本
测试所有登录相关的接口
"""

import requests
import json
import time
from typing import Dict, Any, List
import sys

class GenzLtdAPITester:
    def __init__(self, base_url: str = "http://localhost:8082"):
        self.base_url = base_url
        self.session = requests.Session()
        self.token = None
        self.test_results = []
        
    def log(self, message: str, level: str = "INFO"):
        """日志记录"""
        timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
        print(f"[{timestamp}] [{level}] {message}")
        
    def test_request(self, method: str, url: str, data: Dict = None, 
                    expected_status: int = 200, description: str = "") -> Dict:
        """执行测试请求"""
        try:
            headers = {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            }
            
            if self.token:
                headers['token'] = self.token
                
            if method.upper() == 'GET':
                response = self.session.get(url, headers=headers)
            else:
                response = self.session.post(url, json=data, headers=headers)
                
            success = response.status_code == expected_status
            result = {
                'method': method,
                'url': url,
                'status_code': response.status_code,
                'expected_status': expected_status,
                'success': success,
                'description': description,
                'response': response.text[:500] if response.text else ''
            }
            
            if success:
                self.log(f"✅ {description} - 成功", "SUCCESS")
            else:
                self.log(f"❌ {description} - 失败 (状态码: {response.status_code})", "ERROR")
                
            return result
            
        except Exception as e:
            error_result = {
                'method': method,
                'url': url,
                'status_code': 0,
                'expected_status': expected_status,
                'success': False,
                'description': description,
                'error': str(e)
            }
            self.log(f"❌ {description} - 异常: {str(e)}", "ERROR")
            return error_result

    def test_login_interface(self) -> bool:
        """测试登录接口"""
        self.log("开始测试登录接口...", "INFO")
        
        # 测试登录接口
        login_data = {
            "username": "vuecmf",
            "password": "123456"
        }
        
        result = self.test_request(
            'POST',
            f"{self.base_url}/vuecmf/admin/login",
            login_data,
            200,
            "管理员登录"
        )
        
        if result['success']:
            try:
                response_data = json.loads(result['response'])
                if 'data' in response_data and 'token' in response_data['data']:
                    self.token = response_data['data']['token']
                    self.log(f"登录成功，获取到token: {self.token[:20]}...", "SUCCESS")
                    return True
                else:
                    self.log("登录响应中没有找到token", "WARNING")
                    return False
            except json.JSONDecodeError:
                self.log("登录响应不是有效的JSON格式", "ERROR")
                return False
        else:
            self.log("登录失败", "ERROR")
            return False

    def test_admin_interfaces(self):
        """测试管理员相关接口"""
        self.log("开始测试管理员相关接口...", "INFO")
        
        admin_tests = [
            {
                'url': '/vuecmf/admin/detail',
                'data': {},
                'description': '获取管理员详情'
            },
            {
                'url': '/vuecmf/admin/get_all_roles',
                'data': {},
                'description': '获取所有角色'
            },
            {
                'url': '/vuecmf/admin/get_roles',
                'data': {},
                'description': '获取用户角色'
            },
            {
                'url': '/vuecmf/admin/get_user_permission',
                'data': {},
                'description': '获取用户权限'
            }
        ]
        
        for test in admin_tests:
            result = self.test_request(
                'POST',
                f"{self.base_url}{test['url']}",
                test['data'],
                200,
                test['description']
            )
            self.test_results.append(result)

    def test_roles_interfaces(self):
        """测试角色管理接口"""
        self.log("开始测试角色管理接口...", "INFO")
        
        roles_tests = [
            {
                'url': '/vuecmf/roles/',
                'data': {},
                'description': '获取角色列表'
            },
            {
                'url': '/vuecmf/roles/get_users',
                'data': {},
                'description': '获取角色下所有用户'
            },
            {
                'url': '/vuecmf/roles/get_permission',
                'data': {},
                'description': '获取角色下所有权限'
            },
            {
                'url': '/vuecmf/roles/get_all_users',
                'data': {},
                'description': '获取所有用户'
            }
        ]
        
        for test in roles_tests:
            result = self.test_request(
                'POST',
                f"{self.base_url}{test['url']}",
                test['data'],
                200,
                test['description']
            )
            self.test_results.append(result)

    def test_app_config_interfaces(self):
        """测试应用配置接口"""
        self.log("开始测试应用配置接口...", "INFO")
        
        app_config_tests = [
            {
                'url': '/vuecmf/app_config/',
                'data': {},
                'description': '获取应用配置列表'
            },
            {
                'url': '/vuecmf/app_config/dropdown',
                'data': {},
                'description': '获取应用下拉列表'
            }
        ]
        
        for test in app_config_tests:
            result = self.test_request(
                'POST',
                f"{self.base_url}{test['url']}",
                test['data'],
                200,
                test['description']
            )
            self.test_results.append(result)

    def test_model_interfaces(self):
        """测试模型配置接口"""
        self.log("开始测试模型配置接口...", "INFO")
        
        model_tests = [
            {
                'url': '/vuecmf/model_config/',
                'data': {},
                'description': '获取模型配置列表'
            },
            {
                'url': '/vuecmf/model_config/dropdown',
                'data': {},
                'description': '获取模型下拉列表'
            },
            {
                'url': '/vuecmf/model_action/',
                'data': {},
                'description': '获取模型动作列表'
            },
            {
                'url': '/vuecmf/model_action/get_action_list',
                'data': {},
                'description': '获取动作列表'
            },
            {
                'url': '/vuecmf/model_field/',
                'data': {},
                'description': '获取模型字段列表'
            },
            {
                'url': '/vuecmf/model_field/dropdown',
                'data': {},
                'description': '获取字段下拉列表'
            }
        ]
        
        for test in model_tests:
            result = self.test_request(
                'POST',
                f"{self.base_url}{test['url']}",
                test['data'],
                200,
                test['description']
            )
            self.test_results.append(result)

    def test_menu_interfaces(self):
        """测试菜单配置接口"""
        self.log("开始测试菜单配置接口...", "INFO")
        
        menu_tests = [
            {
                'url': '/vuecmf/menu/',
                'data': {},
                'description': '获取菜单列表'
            },
            {
                'url': '/vuecmf/menu/nav',
                'data': {},
                'description': '获取导航菜单'
            }
        ]
        
        for test in menu_tests:
            result = self.test_request(
                'POST',
                f"{self.base_url}{test['url']}",
                test['data'],
                200,
                test['description']
            )
            self.test_results.append(result)

    def test_logout_interface(self):
        """测试退出登录接口"""
        self.log("开始测试退出登录接口...", "INFO")
        
        result = self.test_request(
            'POST',
            f"{self.base_url}/vuecmf/admin/logout",
            {},
            200,
            "退出登录"
        )
        self.test_results.append(result)

    def test_home_interfaces(self):
        """测试首页接口"""
        self.log("开始测试首页接口...", "INFO")
        
        # 测试GET请求
        result = self.test_request(
            'GET',
            f"{self.base_url}/home",
            expected_status=200,
            description="访问首页"
        )
        self.test_results.append(result)
        
        # 测试POST请求
        result = self.test_request(
            'POST',
            f"{self.base_url}/home/index/success",
            {},
            200,
            "首页成功接口"
        )
        self.test_results.append(result)

    def test_vuecmf_interfaces(self):
        """测试VueCMF系统接口"""
        self.log("开始测试VueCMF系统接口...", "INFO")
        
        # 测试GET请求
        result = self.test_request(
            'GET',
            f"{self.base_url}/vuecmf",
            expected_status=200,
            description="访问VueCMF系统首页"
        )
        self.test_results.append(result)
        
        # 测试POST请求
        result = self.test_request(
            'POST',
            f"{self.base_url}/vuecmf/index/success",
            {},
            200,
            "VueCMF成功接口"
        )
        self.test_results.append(result)

    def run_all_tests(self):
        """运行所有测试"""
        self.log("=" * 60, "INFO")
        self.log("开始 GenzLtd API 自动化测试", "INFO")
        self.log("=" * 60, "INFO")
        
        # 1. 测试登录
        if not self.test_login_interface():
            self.log("登录失败，无法继续测试其他接口", "ERROR")
            return
            
        # 2. 测试各种接口
        self.test_admin_interfaces()
        self.test_roles_interfaces()
        self.test_app_config_interfaces()
        self.test_model_interfaces()
        self.test_menu_interfaces()
        self.test_home_interfaces()
        self.test_vuecmf_interfaces()
        
        # 3. 测试退出登录
        self.test_logout_interface()
        
        # 4. 生成测试报告
        self.generate_report()

    def generate_report(self):
        """生成测试报告"""
        self.log("=" * 60, "INFO")
        self.log("测试报告", "INFO")
        self.log("=" * 60, "INFO")
        
        total_tests = len(self.test_results)
        successful_tests = sum(1 for result in self.test_results if result['success'])
        failed_tests = total_tests - successful_tests
        
        self.log(f"总测试数: {total_tests}", "INFO")
        self.log(f"成功: {successful_tests}", "SUCCESS")
        self.log(f"失败: {failed_tests}", "ERROR")
        self.log(f"成功率: {successful_tests/total_tests*100:.1f}%", "INFO")
        
        if failed_tests > 0:
            self.log("\n失败的测试:", "ERROR")
            for result in self.test_results:
                if not result['success']:
                    self.log(f"  - {result['description']}: {result.get('error', f'状态码 {result['status_code']}')}", "ERROR")
        
        # 保存详细报告到文件
        report_file = "api_test_report.json"
        with open(report_file, 'w', encoding='utf-8') as f:
            json.dump({
                'summary': {
                    'total': total_tests,
                    'successful': successful_tests,
                    'failed': failed_tests,
                    'success_rate': successful_tests/total_tests*100
                },
                'results': self.test_results
            }, f, ensure_ascii=False, indent=2)
        
        self.log(f"详细报告已保存到: {report_file}", "INFO")

def main():
    """主函数"""
    if len(sys.argv) > 1:
        base_url = sys.argv[1]
    else:
        base_url = "http://localhost:8082"
    
    tester = GenzLtdAPITester(base_url)
    tester.run_all_tests()

if __name__ == "__main__":
    main() 