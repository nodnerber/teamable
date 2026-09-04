const { defineConfig } = require('@vue/cli-service')

let apiServerStarted = false

module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    proxy: {
      '/get-profile': {
        target: 'http://127.0.0.1:3000',
        changeOrigin: true,
      },
      '/update-profile': {
        target: 'http://127.0.0.1:3000',
        changeOrigin: true,
      },
    },
    setupMiddlewares(middlewares) {
      if (!apiServerStarted) {
        apiServerStarted = true
        require('./server')
      }
      return middlewares
    },
  },
})
