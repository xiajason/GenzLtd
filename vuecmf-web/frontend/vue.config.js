module.exports = {
  publicPath: '/',  // 添加公共路径配置（修复资源加载路径）
  chainWebpack: config => {
    config.plugin('define').tap(args => {
      args[0]['__VUE_PROD_HYDRATION_MISMATCH_DETAILS__'] = JSON.stringify(false);
      return args;
    });

    // 👇 添加以下代码（确保 favicon 被正确处理）
    config.plugin('html')  // 获取 html-webpack-plugin 插件实例
      .tap(args => {       // 修改插件的配置参数
        args[0].favicon = './public/favicon.ico';  // 指定 favicon 路径
        return args;       // 返回修改后的参数
      });
    // 👆 添加结束
    
    // 添加构建优化
    config.optimization.splitChunks({
      chunks: 'all',
      cacheGroups: {
        vendor: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendors',
          chunks: 'all'
        }
      }
    });
  },
  devServer: {
    port: 8081,
    proxy: {
      '/vuecmf': {
        target: 'http://localhost:8080',  // 后端API地址
        changeOrigin: true,
        pathRewrite: {
          '^/vuecmf': '/vuecmf'
        }
      }
    }
  }
};

// {{ edit_1: Remove all markdown documentation from this file }}
// The following lines were causing the syntax error:
// ## 2. Resolve React DevTools Message
// 
// This message appears incorrectly in non-React projects:
// 1. **Disable the React DevTools extension** in your browser
// 2. **Clear browser cache** (Cmd+Shift+R on Mac or Ctrl+Shift+R on Windows/Linux)
// 
// ## 3. Verify Frontend Configuration
// 
// Ensure your Vue app is configured to proxy API requests correctly:
// ```javascript
// module.exports = {
//   devServer: {
//     proxy: {
//       '/api': {
//         target: 'http://localhost:8080',
//         changeOrigin: true
//       }
//     }
//   }
// }