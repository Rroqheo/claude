#!/bin/bash

# Tauri 开发环境启动脚本
echo "🚀 启动 Claudia Tauri 开发环境..."

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
        
        # 检查 qwen2.5-coder:7b 模型是否存在
        if ollama list | grep -q "qwen2.5-coder:7b"; then
            echo "✅ Qwen 模型已安装"
        else
            echo "⚠️  Qwen 模型未安装，正在下载..."
            ollama pull qwen2.5-coder:7b
        fi
    else
        echo "❌ Ollama 服务未运行，请先启动 Ollama"
        echo "   运行: ollama serve"
        exit 1
    fi
fi

# 启动 Tauri 开发服务器
echo "🌟 启动 Tauri 开发服务器..."
npm run tauri dev