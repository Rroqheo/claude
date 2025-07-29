#!/bin/bash

# 开发环境启动脚本
echo "🚀 启动 Claudia 开发环境..."

# 加载环境变量
if [ -f .env ]; then
    echo "📋 加载环境变量..."
    source .env
    echo "✅ 环境变量已加载"
    echo "   OPENAI_API_KEY: ${OPENAI_API_KEY}"
    echo "   OPENAI_BASE_URL: ${OPENAI_BASE_URL}"
    echo "   OPENAI_MODEL: ${OPENAI_MODEL}"
else
    echo "⚠️  未找到 .env 文件"
fi

# 检查 Ollama 是否运行（如果使用本地模式）
if [ "$OPENAI_BASE_URL" = "http://localhost:11434/v1" ]; then
    echo "🔍 检查 Ollama 服务..."
    if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        echo "✅ Ollama 服务正在运行"
    else
        echo "❌ Ollama 服务未运行，请先启动 Ollama"
        echo "   运行: ollama serve"
        exit 1
    fi
fi

# 启动开发服务器
echo "🌟 启动 Vite 开发服务器..."
npm run dev