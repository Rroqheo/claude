#!/bin/bash

echo "🔥 地狱之门 AI 服务系统 - 最终完整报告"
echo "========================================"
echo ""

HELL_GATE_DIR="/Users/b/Documents/Bsng/地狱之门_"

# 检查地狱之门目录
if [ -d "$HELL_GATE_DIR" ]; then
    echo "✅ 地狱之门目录: $HELL_GATE_DIR"
else
    echo "❌ 地狱之门目录不存在"
    exit 1
fi

echo ""
echo "📊 服务配置统计"
echo "==============="

# 统计服务数量
service_count=0
ai_services=("chatgpt" "claude" "gemini" "grok" "zhaoyun" "local" "puter-ai")
service_names=("ChatGPT" "Claude" "Gemini" "Grok" "赵云 AI" "本地模型" "Puter AI")
ports=(3001 3002 3003 3004 3005 3006 3007)

echo "🤖 已配置的 AI 服务: ${#ai_services[@]} 个"
echo ""

# 检查每个服务
for i in "${!ai_services[@]}"; do
    service="${ai_services[$i]}"
    name="${service_names[$i]}"
    port="${ports[$i]}"
    service_dir="$HELL_GATE_DIR/$service"
    
    echo "🔹 $name (端口 $port):"
    
    if [ -d "$service_dir" ]; then
        echo "   📁 目录: ✅ 存在"
        service_count=$((service_count + 1))
        
        # 检查配置文件
        if [ -f "$service_dir/.env" ]; then
            echo "   ⚙️  配置: ✅ .env"
        else
            echo "   ⚙️  配置: ❌ 缺少 .env"
        fi
        
        # 检查启动脚本
        start_script=""
        case $service in
            "chatgpt") start_script="start-chatgpt.sh" ;;
            "claude") start_script="start-claude.sh" ;;
            "gemini") start_script="start-gemini.sh" ;;
            "grok") start_script="start-grok.sh" ;;
            "zhaoyun") start_script="start-zhaoyun.sh" ;;
            "local") start_script="start-local.sh" ;;
            "puter-ai") start_script="start-puter-ai.sh" ;;
        esac
        
        if [ -f "$service_dir/$start_script" ]; then
            echo "   🚀 启动脚本: ✅ $start_script"
        else
            echo "   🚀 启动脚本: ❌ 缺少 $start_script"
        fi
        
        # 检查聊天界面
        chat_file=""
        case $service in
            "grok") chat_file="grok-chat.html" ;;
            "zhaoyun") chat_file="zhaoyun-chat.html" ;;
            "puter-ai") chat_file="puter-ai-demo.html" ;;
        esac
        
        if [ -n "$chat_file" ] && [ -f "$service_dir/$chat_file" ]; then
            echo "   💬 聊天界面: ✅ $chat_file"
        elif [ -n "$chat_file" ]; then
            echo "   💬 聊天界面: ❌ 缺少 $chat_file"
        fi
        
        # 检查运行状态
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            echo "   🟢 状态: 运行中"
        else
            echo "   🔴 状态: 未运行"
        fi
        
    else
        echo "   📁 目录: ❌ 不存在"
    fi
    echo ""
done

echo "🎨 主题样式文件"
echo "=============="
theme_files=("chatgpt-theme.css" "claude-theme.css" "gemini-theme.css" "grok-theme.css" "hell-gate-theme.css" "puter-ai-theme.css")
theme_count=0

for theme in "${theme_files[@]}"; do
    if [ -f "$HELL_GATE_DIR/$theme" ]; then
        echo "✅ $theme"
        theme_count=$((theme_count + 1))
    else
        echo "❌ $theme"
    fi
done

echo ""
echo "🛠️  管理工具"
echo "==========="
management_files=("hell-gate-control.sh" "check-services.sh" "start-hell-gate.sh")
mgmt_count=0

for mgmt in "${management_files[@]}"; do
    if [ -f "$HELL_GATE_DIR/$mgmt" ]; then
        echo "✅ $mgmt"
        mgmt_count=$((mgmt_count + 1))
    else
        echo "❌ $mgmt"
    fi
done

echo ""
echo "📚 文档文件"
echo "=========="
doc_files=("README.md" ".env" "package.json")
doc_count=0

for doc in "${doc_files[@]}"; do
    if [ -f "$HELL_GATE_DIR/$doc" ]; then
        echo "✅ $doc"
        doc_count=$((doc_count + 1))
    else
        echo "❌ $doc"
    fi
done

echo ""
echo "🌟 特殊功能"
echo "=========="

# 检查 Puter.js 演示文件
puter_demo_file="/Users/b/claudia/puter-ai-complete-demo.html"
puter_auth_file="/Users/b/claudia/puter-auth-demo.html"

echo "🚀 Puter.js AI 完整演示:"
if [ -f "$puter_demo_file" ]; then
    echo "   ✅ 完整演示文件: puter-ai-complete-demo.html"
    echo "   📍 位置: $puter_demo_file"
    echo "   🎯 功能: GPT-4o, Claude 3.5 Sonnet, Llama, 图像分析, 流式响应"
else
    echo "   ❌ 完整演示文件不存在"
fi

echo ""
echo "🔐 Puter.js 身份验证演示:"
if [ -f "$puter_auth_file" ]; then
    echo "   ✅ 身份验证文件: puter-auth-demo.html"
    echo "   📍 位置: $puter_auth_file"
    echo "   🎯 功能: 登录/登出, 用户信息, 云存储笔记"
else
    echo "   ❌ 身份验证文件不存在"
fi

# 检查 Puter AI 服务目录中的文件
echo ""
echo "📁 Puter AI 服务目录:"
if [ -d "$HELL_GATE_DIR/puter-ai" ]; then
    echo "   ✅ 目录存在: $HELL_GATE_DIR/puter-ai"
    if [ -f "$HELL_GATE_DIR/puter-ai/puter-ai-demo.html" ]; then
        echo "   ✅ 完整演示: puter-ai-demo.html"
    fi
    if [ -f "$HELL_GATE_DIR/puter-ai/puter-auth-demo.html" ]; then
        echo "   ✅ 身份验证演示: puter-auth-demo.html"
    fi
else
    echo "   ❌ Puter AI 目录不存在"
fi

echo ""
echo "🚀 启动方法"
echo "=========="
echo "1. 启动所有服务:"
echo "   cd '$HELL_GATE_DIR' && ./hell-gate-control.sh start"
echo ""
echo "2. 启动单个服务:"
echo "   cd '$HELL_GATE_DIR/[服务名]' && ./start-[服务名].sh"
echo ""
echo "3. 检查服务状态:"
echo "   cd '$HELL_GATE_DIR' && ./check-services.sh"
echo ""

echo "🌐 访问地址"
echo "=========="
echo "• ChatGPT:     http://localhost:3001"
echo "• Claude:      http://localhost:3002"
echo "• Gemini:      http://localhost:3003"
echo "• Grok:        http://localhost:3004/grok-chat.html"
echo "• 赵云 AI:     http://localhost:3005/zhaoyun-chat.html"
echo "• 本地模型:    http://localhost:3006"
echo "• Puter AI:    http://localhost:3007/puter-ai-demo.html"
echo "• Puter 身份验证: http://localhost:3007/puter-auth-demo.html"
echo ""

echo "📊 配置统计"
echo "=========="
echo "🤖 AI 服务: $service_count/7"
echo "🎨 主题文件: $theme_count/6"
echo "🛠️  管理工具: $mgmt_count/3"
echo "📚 文档文件: $doc_count/3"

# 计算总文件数
total_files=$(find "$HELL_GATE_DIR" -type f | wc -l | tr -d ' ')
total_dirs=$(find "$HELL_GATE_DIR" -type d | wc -l | tr -d ' ')

echo "📁 总目录数: $total_dirs"
echo "📄 总文件数: $total_files"

echo ""
echo "🎯 下一步操作"
echo "============"
echo "1. 启动想要使用的 AI 服务"
echo "2. 在浏览器中访问对应的地址"
echo "3. 体验免费的 Puter.js AI 功能"
echo "4. 使用 Grok 和赵云 AI 的专用界面"
echo "5. 测试 Puter.js 的身份验证和云存储功能"
echo ""

if [ $service_count -eq 7 ] && [ $theme_count -ge 5 ] && [ $mgmt_count -eq 3 ]; then
    echo "🎉 地狱之门 AI 服务系统配置 100% 完成！"
    echo "   包含 7 个 AI 服务，完整的管理工具和主题样式"
    echo "   特别包含免费的 Puter.js AI 功能套件"
else
    echo "⚠️  配置可能不完整，请检查缺失的组件"
fi

echo ""
echo "🔥 地狱之门已开启，AI 之力尽在掌握！"