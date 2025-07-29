#!/bin/bash

# 地狱之门 - 分离式 AI 服务配置脚本
TARGET_DIR="/Users/b/Documents/Bsng/地狱之门_"

echo "🔥 创建分离式 AI 服务配置..."

# 1. ChatGPT 独立配置
mkdir -p "$TARGET_DIR/chatgpt"
cat > "$TARGET_DIR/chatgpt/.env" << 'EOF'
# ChatGPT 专用配置
OPENAI_API_KEY="your_openai_api_key_here"
OPENAI_BASE_URL="https://api.openai.com/v1"
OPENAI_MODEL="gpt-4"
SERVICE_NAME="ChatGPT"
SERVICE_PORT="3001"
EOF

cat > "$TARGET_DIR/chatgpt/start-chatgpt.sh" << 'EOF'
#!/bin/bash
echo "🤖 启动 ChatGPT 服务..."
cd "$(dirname "$0")"
source .env
export PORT=$SERVICE_PORT
npm run dev -- --port $SERVICE_PORT
EOF

# 2. Claude 独立配置
mkdir -p "$TARGET_DIR/claude"
cat > "$TARGET_DIR/claude/.env" << 'EOF'
# Claude 专用配置
ANTHROPIC_API_KEY="your_anthropic_api_key_here"
ANTHROPIC_BASE_URL="https://api.anthropic.com"
ANTHROPIC_MODEL="claude-3-sonnet-20240229"
SERVICE_NAME="Claude"
SERVICE_PORT="3002"
EOF

cat > "$TARGET_DIR/claude/start-claude.sh" << 'EOF'
#!/bin/bash
echo "🧠 启动 Claude 服务..."
cd "$(dirname "$0")"
source .env
export PORT=$SERVICE_PORT
npm run tauri dev
EOF

# 3. Gemini 独立配置
mkdir -p "$TARGET_DIR/gemini"
cat > "$TARGET_DIR/gemini/.env" << 'EOF'
# Gemini 专用配置
GEMINI_API_KEY="your_gemini_api_key_here"
GEMINI_BASE_URL="https://generativelanguage.googleapis.com/v1beta"
GEMINI_MODEL="gemini-pro"
SERVICE_NAME="Gemini"
SERVICE_PORT="3003"
EOF

cat > "$TARGET_DIR/gemini/start-gemini.sh" << 'EOF'
#!/bin/bash
echo "💎 启动 Gemini 服务..."
cd "$(dirname "$0")"
source .env
export PORT=$SERVICE_PORT
npm run dev -- --port $SERVICE_PORT
EOF

# 4. 本地模型独立配置 (不使用 Ollama)
mkdir -p "$TARGET_DIR/local"
cat > "$TARGET_DIR/local/.env" << 'EOF'
# 本地模型专用配置 (非 Ollama)
LOCAL_MODEL_PATH="/path/to/your/local/model"
LOCAL_MODEL_TYPE="gguf"
LOCAL_MODEL_NAME="qwen2.5-coder-7b"
SERVICE_NAME="LocalModel"
SERVICE_PORT="3004"
ENABLE_GPU="true"
EOF

cat > "$TARGET_DIR/local/start-local.sh" << 'EOF'
#!/bin/bash
echo "🏠 启动本地模型服务..."
cd "$(dirname "$0")"
source .env
# 这里可以配置 llama.cpp 或其他本地推理引擎
echo "本地模型路径: $LOCAL_MODEL_PATH"
echo "模型类型: $LOCAL_MODEL_TYPE"
echo "服务端口: $SERVICE_PORT"
EOF

# 5. 主控制脚本
cat > "$TARGET_DIR/hell-gate-control.sh" << 'EOF'
#!/bin/bash

echo "🔥 地狱之门 AI 服务控制中心"
echo "================================"
echo "1. ChatGPT 服务"
echo "2. Claude 服务" 
echo "3. Gemini 服务"
echo "4. 本地模型服务"
echo "5. 启动所有服务"
echo "6. 停止所有服务"
echo "================================"

read -p "请选择服务 (1-6): " choice

case $choice in
    1)
        echo "🤖 启动 ChatGPT..."
        cd chatgpt && ./start-chatgpt.sh
        ;;
    2)
        echo "🧠 启动 Claude..."
        cd claude && ./start-claude.sh
        ;;
    3)
        echo "💎 启动 Gemini..."
        cd gemini && ./start-gemini.sh
        ;;
    4)
        echo "🏠 启动本地模型..."
        cd local && ./start-local.sh
        ;;
    5)
        echo "🚀 启动所有服务..."
        cd chatgpt && ./start-chatgpt.sh &
        cd ../claude && ./start-claude.sh &
        cd ../gemini && ./start-gemini.sh &
        cd ../local && ./start-local.sh &
        wait
        ;;
    6)
        echo "🛑 停止所有服务..."
        pkill -f "port 300[1-4]"
        ;;
    *)
        echo "❌ 无效选择"
        ;;
esac
EOF

# 设置执行权限
chmod +x "$TARGET_DIR/chatgpt/start-chatgpt.sh"
chmod +x "$TARGET_DIR/claude/start-claude.sh"
chmod +x "$TARGET_DIR/gemini/start-gemini.sh"
chmod +x "$TARGET_DIR/local/start-local.sh"
chmod +x "$TARGET_DIR/hell-gate-control.sh"

# 6. 创建服务状态监控脚本
cat > "$TARGET_DIR/check-services.sh" << 'EOF'
#!/bin/bash

echo "🔍 地狱之门服务状态检查"
echo "========================"

services=("ChatGPT:3001" "Claude:3002" "Gemini:3003" "Local:3004")

for service in "${services[@]}"; do
    name="${service%:*}"
    port="${service#*:}"
    
    if lsof -ti:$port > /dev/null 2>&1; then
        echo "✅ $name (端口 $port): 运行中"
    else
        echo "❌ $name (端口 $port): 未运行"
    fi
done
EOF

chmod +x "$TARGET_DIR/check-services.sh"

echo "✅ 分离式 AI 服务配置完成！"
echo ""
echo "📁 服务目录结构:"
echo "├── chatgpt/     - ChatGPT 独立服务"
echo "├── claude/      - Claude 独立服务"
echo "├── gemini/      - Gemini 独立服务"
echo "├── local/       - 本地模型服务"
echo "├── hell-gate-control.sh - 主控制脚本"
echo "└── check-services.sh    - 服务状态检查"
echo ""
echo "🚀 使用方法:"
echo "cd '$TARGET_DIR' && ./hell-gate-control.sh"