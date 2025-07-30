/**
 * VueCMF 主JavaScript文件
 */

// 全局配置
const VueCMF = {
    version: '1.0.0',
    apiBaseUrl: '/api',
    debug: false
};

// 工具函数
const Utils = {
    // 显示消息提示
    showMessage: function(message, type = 'info') {
        console.log(`${type}: ${message}`);
    },
    
    // AJAX请求封装
    request: function(url, options = {}) {
        return fetch(url, options)
            .then(response => response.json())
            .catch(error => {
                console.error('Request failed:', error);
                throw error;
            });
    },
    
    // 表单验证
    validateForm: function(formElement) {
        const inputs = formElement.querySelectorAll('input[required]');
        let isValid = true;
        
        inputs.forEach(input => {
            if (!input.value.trim()) {
                input.classList.add('error');
                isValid = false;
            } else {
                input.classList.remove('error');
            }
        });
        
        return isValid;
    }
};

// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', function() {
    console.log('VueCMF initialized successfully');
});

// 导出到全局作用域
window.VueCMF = VueCMF;
window.Utils = Utils; 