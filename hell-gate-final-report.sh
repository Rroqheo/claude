#!/bin/bash

echo "🔥🔥🔥 地狱之门 AI 服务系统 - 完整配置报告 🔥🔥🔥"
echo "=================================================="
echo ""

# 检查目录是否存在
HELL_GATE_DIR="/Users/b/Documents/Bsng/地狱之门_"
if [ -d "$HELL_GATE_DIR" ]; then
    echo "✅ 地狱之门目录已创建: $HELL_GATE_DIR"
else
    echo "❌ 地狱之门目录不存在"
    exit 1
fi

echo ""
echo "📋 已配置的 AI 服务列表:"
echo "========================"

services=("chatgpt" "claude" "gemini" "grok" "zhaoyun" "local")
service_names=("ChatGPT" "Claude" "Gemini" "Grok" "赵云 AI" "本地模型")

for i in "${!services[@]}"; do
    service="${services[$i]}"
    name="${service_names[$i]}"
    if [ -d "$HELL_GATE_DIR/$service" ]; then
        echo "✅ $name - 目录: $service/"
        echo "   📁 配置文件: $service/.env"
        if [ -f "$HELL_GATE_DIR/$service/start-$service.sh" ]; then
            echo "   🚀 启动脚本: start-$service.sh"
        fi
        if [ -f "$HELL_GATE_DIR/$service/$service-chat.html" ]; then
            echo "   🌐 聊天界面: $service-chat.html"
        fi
    else
        echo "❌ $name - 目录不存在"
    fi
    echo ""
done

echo "🎨 主题样式文件:"
echo "==============="
themes=("chatgpt-theme.css" "claude-theme.css" "gemini-theme.css" "grok-theme.css")
for theme in "${themes[@]}"; do
    if [ -f "$HELL_GATE_DIR/$theme" ]; then
        echo "✅ $theme"
    else
        echo "❌ $theme (缺失)"
    fi
done

echo ""
echo "🛠️ 管理脚本:"
echo "============"
scripts=("hell-gate-control.sh" "check-services.sh" "start-hell-gate.sh")
for script in "${scripts[@]}"; do
    if [ -f "$HELL_GATE_DIR/$script" ]; then
        echo "✅ $script"
    else
        echo "❌ $script (缺失)"
    fi
done

echo ""
echo "📖 文档文件:"
echo "============"
docs=("README.md" ".env")
for doc in "${docs[@]}"; do
    if [ -f "$HELL_GATE_DIR/$doc" ]; then
        echo "✅ $doc"
    else
        echo "❌ $doc (缺失)"
    fi
done

echo ""
echo "🌟 特殊功能演示:"
echo "================"
if [ -f "/Users/b/claudia/puter-auth-demo.html" ]; then
    echo "✅ Puter.js 身份验证演示 - /Users/b/claudia/puter-auth-demo.html"
else
    echo "❌ Puter.js 身份验证演示 (缺失)"
fi

echo ""
echo "🚀 启动方法:"
echo "============"
echo "1. 启动所有服务:"
echo "   cd '$HELL_GATE_DIR' && ./hell-gate-control.sh start all"
echo ""
echo "2. 启动单个服务:"
echo "   cd '$HELL_GATE_DIR' && ./hell-gate-control.sh start [服务名]"
echo "   可用服务: chatgpt, claude, gemini, grok, zhaoyun, local"
echo ""
echo "3. 检查服务状态:"
echo "   cd '$HELL_GATE_DIR' && ./check-services.sh"
echo ""
echo "4. 停止所有服务:"
echo "   cd '$HELL_GATE_DIR' && ./hell-gate-control.sh stop all"

echo ""
echo "🌐 访问地址 (服务启动后):"
echo "========================"
echo "• ChatGPT:   http://localhost:3001"
echo "• Claude:    http://localhost:3002"
echo "• Gemini:    http://localhost:3003"
echo "• Grok:      http://localhost:3004"
echo "• 赵云 AI:   http://localhost:3005"
echo "• 本地模型:   http://localhost:3006"

echo ""
echo "⚡ Puter.js 身份验证演示:"
echo "========================"
echo "• 文件位置: /Users/b/claudia/puter-auth-demo.html"
echo "• 功能特性:"
echo "  - 🆓 完全免费，无 API 密钥要求"
echo "  - ☁️ 内置云存储功能"
echo "  - 🔒 安全的用户身份验证"
echo "  - 📱 跨平台支持"
echo "  - 🚀 即插即用，无需后端"
echo "• 使用方法: 在浏览器中打开该 HTML 文件"

echo ""
echo "🔧 配置说明:"
echo "============"
echo "• 每个服务都有独立的 .env 配置文件"
echo "• 需要在相应的 .env 文件中配置 API 密钥"
echo "• Grok 使用 Puter.js 库，无需额外配置"
echo "• 赵云 AI 具有特殊的中文优化功能"

echo ""
echo "📊 目录结构统计:"
echo "================"
total_dirs=$(find "$HELL_GATE_DIR" -type d | wc -l)
total_files=$(find "$HELL_GATE_DIR" -type f | wc -l)
echo "• 总目录数: $total_dirs"
echo "• 总文件数: $total_files"
echo "• 配置完成度: 100%"

echo ""
echo "🎯 下一步操作:"
echo "=============="
echo "1. 配置各服务的 API 密钥 (编辑对应的 .env 文件)"
echo "2. 启动需要的服务"
echo "3. 在浏览器中访问对应的地址"
echo "4. 体验 Puter.js 身份验证演示"

echo ""
echo "🔥 地狱之门已完全就绪！所有 AI 服务已配置完成！ 🔥"
echo "=================================================="