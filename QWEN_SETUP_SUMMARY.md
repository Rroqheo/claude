# Qwen CLI Code 安装总结

## ✅ 安装状态
- **Qwen CLI Code 版本**: 0.0.1-alpha.10
- **安装位置**: `/Users/b/.npm-global/bin/qwen`
- **状态**: 已成功安装并可运行

## 🔧 发现的问题及解决方案

### 问题 1: PATH 配置
**问题**: npm 全局包安装在 `/Users/b/.npm-global/bin/`，但此路径不在系统 PATH 中
**解决**: 已添加到 ~/.zshrc 中

### 问题 2: 环境变量配置
**需要设置的环境变量**:
```bash
export OPENAI_API_KEY="your_api_key_here"
export OPENAI_BASE_URL="https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
export OPENAI_MODEL="qwen3-coder-plus"
```

## 🚀 使用方法

### 临时使用（当前会话）:
```bash
# 设置环境变量
export OPENAI_API_KEY="your_actual_api_key"
export OPENAI_BASE_URL="https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
export OPENAI_MODEL="qwen3-coder-plus"

# 使用完整路径运行
/Users/b/.npm-global/bin/qwen "Help me write a function"
```

### 永久使用:
1. 重启终端或运行 `source ~/.zshrc`
2. 设置您的 API key: `export OPENAI_API_KEY="your_actual_api_key"`
3. 直接使用: `qwen "Your prompt here"`

## 📝 常用命令
```bash
# 查看版本
qwen --version

# 查看帮助
qwen --help

# 基本使用
qwen "Write a Python function to sort a list"

# 启用检查点功能
qwen --checkpointing "Refactor this code"

# 列出可用扩展
qwen --list-extensions
```

## ⚠️ 注意事项
1. 需要有效的阿里云 DashScope API key
2. 确保网络连接正常
3. 如果遇到权限问题，可能需要使用完整路径运行命令