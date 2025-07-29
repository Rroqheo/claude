#!/bin/bash

# 地狱之门 - 完整 AI 服务配置脚本 (包含 Grok)
TARGET_DIR="/Users/b/Documents/Bsng/地狱之门_"

echo "🔥 创建完整 AI 服务配置 (包含 Grok)..."

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

# 4. Grok 独立配置 (新增)
mkdir -p "$TARGET_DIR/grok"
cat > "$TARGET_DIR/grok/.env" << 'EOF'
# Grok 专用配置
XAI_API_KEY="your_xai_api_key_here"
XAI_BASE_URL="https://api.x.ai/v1"
XAI_MODEL="grok-beta"
SERVICE_NAME="Grok"
SERVICE_PORT="3004"
PUTER_JS_URL="https://js.puter.com/v2/"
EOF

cat > "$TARGET_DIR/grok/start-grok.sh" << 'EOF'
#!/bin/bash
echo "⚡ 启动 Grok 服务..."
cd "$(dirname "$0")"
source .env
export PORT=$SERVICE_PORT
echo "🤖 Grok 服务启动在端口 $SERVICE_PORT"
echo "📡 使用 Puter.js: $PUTER_JS_URL"
npm run dev -- --port $SERVICE_PORT
EOF

# 5. 本地模型独立配置
mkdir -p "$TARGET_DIR/local"
cat > "$TARGET_DIR/local/.env" << 'EOF'
# 本地模型专用配置 (非 Ollama)
LOCAL_MODEL_PATH="/path/to/your/local/model"
LOCAL_MODEL_TYPE="gguf"
LOCAL_MODEL_NAME="qwen2.5-coder-7b"
SERVICE_NAME="LocalModel"
SERVICE_PORT="3005"
ENABLE_GPU="true"
EOF

# 6. 赵云 AI 配置 (新增特殊服务)
mkdir -p "$TARGET_DIR/zhaoyun"
cat > "$TARGET_DIR/zhaoyun/.env" << 'EOF'
# 赵云 AI 专用配置
ZHAOYUN_API_KEY="your_zhaoyun_api_key_here"
ZHAOYUN_BASE_URL="https://api.zhaoyun.ai/v1"
ZHAOYUN_MODEL="zhaoyun-pro"
SERVICE_NAME="ZhaoYun"
SERVICE_PORT="3006"
SPECIAL_MODE="warrior"
EOF

cat > "$TARGET_DIR/zhaoyun/start-zhaoyun.sh" << 'EOF'
#!/bin/bash
echo "🛡️ 启动赵云 AI 服务..."
cd "$(dirname "$0")"
source .env
export PORT=$SERVICE_PORT
echo "⚔️ 赵云 AI 战士模式启动在端口 $SERVICE_PORT"
npm run dev -- --port $SERVICE_PORT
EOF

# 7. 更新主控制脚本
cat > "$TARGET_DIR/hell-gate-control.sh" << 'EOF'
#!/bin/bash

echo "🔥 地狱之门 AI 服务控制中心"
echo "================================"
echo "1. ChatGPT 服务"
echo "2. Claude 服务" 
echo "3. Gemini 服务"
echo "4. Grok 服务 ⚡"
echo "5. 赵云 AI 服务 🛡️"
echo "6. 本地模型服务"
echo "7. 启动所有服务"
echo "8. 停止所有服务"
echo "9. 服务状态检查"
echo "================================"

read -p "请选择服务 (1-9): " choice

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
        echo "⚡ 启动 Grok..."
        cd grok && ./start-grok.sh
        ;;
    5)
        echo "🛡️ 启动赵云 AI..."
        cd zhaoyun && ./start-zhaoyun.sh
        ;;
    6)
        echo "🏠 启动本地模型..."
        cd local && ./start-local.sh
        ;;
    7)
        echo "🚀 启动所有服务..."
        cd chatgpt && ./start-chatgpt.sh &
        cd ../claude && ./start-claude.sh &
        cd ../gemini && ./start-gemini.sh &
        cd ../grok && ./start-grok.sh &
        cd ../zhaoyun && ./start-zhaoyun.sh &
        cd ../local && ./start-local.sh &
        wait
        ;;
    8)
        echo "🛑 停止所有服务..."
        pkill -f "port 300[1-6]"
        ;;
    9)
        echo "🔍 检查服务状态..."
        ./check-services.sh
        ;;
    *)
        echo "❌ 无效选择"
        ;;
esac
EOF

# 8. 创建 Grok 专用 HTML 界面
cat > "$TARGET_DIR/grok/grok-chat.html" << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grok AI Chat - 地狱之门</title>
    <link rel="stylesheet" href="../grok-theme.css">
</head>
<body class="grok-container">
    <div class="grok-header">
        🔥 地狱之门 - Grok AI 聊天
    </div>
    
    <div class="grok-chat">
        <div class="grok-status online">
            <div class="grok-typing">
                <div class="grok-typing-dot"></div>
                <div class="grok-typing-dot"></div>
                <div class="grok-typing-dot"></div>
            </div>
            Grok 在线
        </div>
        
        <div id="messages" style="height: 500px; overflow-y: auto; margin: 20px 0;">
            <div class="grok-message assistant">
                <strong>Grok:</strong><br>
                嘿！我是 Grok，你的机智 AI 助手。我在这里用我独特的幽默感和解决问题的能力帮助你。有什么我可以帮你的吗？
            </div>
        </div>
        
        <div class="grok-input-container">
            <input type="text" id="user-input" class="grok-input" 
                   placeholder="问我任何问题...">
            <button onclick="sendMessage()" class="grok-send-button">
                ➤
            </button>
        </div>
    </div>

    <script src="https://js.puter.com/v2/"></script>
    <script>
        const messagesDiv = document.getElementById('messages');
        const userInput = document.getElementById('user-input');

        async function sendMessage() {
            const message = userInput.value.trim();
            if (!message) return;

            // 添加用户消息
            addMessage(message, 'user');
            userInput.value = '';

            // 显示 Grok 正在思考
            const thinkingDiv = addMessage('正在思考...', 'assistant', true);
            
            try {
                // 使用 Puter.js 调用 Grok
                const response = await puter.ai.chat(message, {
                    model: 'x-ai/grok-beta',
                    stream: true
                });

                // 移除思考提示
                thinkingDiv.remove();
                
                // 创建响应容器
                const responseDiv = addMessage('', 'assistant');
                const responseContent = responseDiv.querySelector('.message-content');
                
                // 流式显示响应
                for await (const part of response) {
                    responseContent.innerHTML += part.text;
                    messagesDiv.scrollTop = messagesDiv.scrollHeight;
                }
                
            } catch (error) {
                thinkingDiv.remove();
                addMessage(`抱歉，出现了错误: ${error.message}`, 'assistant');
            }
        }

        function addMessage(content, type, isTemporary = false) {
            const messageDiv = document.createElement('div');
            messageDiv.className = `grok-message ${type}`;
            messageDiv.innerHTML = `
                <strong>${type === 'user' ? '你' : 'Grok'}:</strong><br>
                <span class="message-content">${content}</span>
            `;
            
            if (isTemporary) {
                messageDiv.classList.add('temporary');
            }
            
            messagesDiv.appendChild(messageDiv);
            messagesDiv.scrollTop = messagesDiv.scrollHeight;
            return messageDiv;
        }

        // 回车发送消息
        userInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') sendMessage();
        });
    </script>
</body>
</html>
EOF

# 9. 创建赵云 AI 专用界面
cat > "$TARGET_DIR/zhaoyun/zhaoyun-chat.html" << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>赵云 AI - 地狱之门</title>
    <style>
        :root {
            --zhaoyun-primary: #C9302C;
            --zhaoyun-secondary: #8B0000;
            --zhaoyun-gold: #FFD700;
            --zhaoyun-bg: #1a1a1a;
            --zhaoyun-surface: #2d2d2d;
            --zhaoyun-text: #ffffff;
        }
        
        body {
            background: linear-gradient(135deg, var(--zhaoyun-bg), var(--zhaoyun-secondary));
            color: var(--zhaoyun-text);
            font-family: 'KaiTi', '楷体', serif;
            margin: 0;
            min-height: 100vh;
        }
        
        .zhaoyun-header {
            background: linear-gradient(45deg, var(--zhaoyun-primary), var(--zhaoyun-gold));
            text-align: center;
            padding: 30px;
            font-size: 36px;
            font-weight: bold;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }
        
        .zhaoyun-chat {
            max-width: 900px;
            margin: 0 auto;
            padding: 30px;
        }
        
        .zhaoyun-message {
            background: var(--zhaoyun-surface);
            border: 2px solid var(--zhaoyun-gold);
            border-radius: 15px;
            padding: 20px;
            margin: 20px 0;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.3);
        }
        
        .zhaoyun-input {
            width: 100%;
            padding: 15px;
            border: 2px solid var(--zhaoyun-gold);
            border-radius: 10px;
            background: var(--zhaoyun-surface);
            color: var(--zhaoyun-text);
            font-size: 16px;
            font-family: inherit;
        }
        
        .zhaoyun-button {
            background: linear-gradient(45deg, var(--zhaoyun-primary), var(--zhaoyun-gold));
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="zhaoyun-header">
        🛡️ 赵云 AI - 常山赵子龙
    </div>
    
    <div class="zhaoyun-chat">
        <div id="messages">
            <div class="zhaoyun-message">
                <strong>赵云:</strong><br>
                吾乃常山赵子龙！有何军情要事，尽管道来！
            </div>
        </div>
        
        <div style="margin-top: 30px;">
            <input type="text" id="user-input" class="zhaoyun-input" 
                   placeholder="请输入您的问题，将军...">
            <button onclick="sendToZhaoYun()" class="zhaoyun-button">
                🗡️ 请教将军
            </button>
        </div>
    </div>

    <script>
        function sendToZhaoYun() {
            const input = document.getElementById('user-input');
            const message = input.value.trim();
            if (!message) return;
            
            const messagesDiv = document.getElementById('messages');
            
            // 添加用户消息
            messagesDiv.innerHTML += `
                <div class="zhaoyun-message" style="border-color: var(--zhaoyun-primary);">
                    <strong>您:</strong><br>${message}
                </div>
            `;
            
            // 赵云回复 (这里可以集成实际的 AI API)
            messagesDiv.innerHTML += `
                <div class="zhaoyun-message">
                    <strong>赵云:</strong><br>
                    将军所问甚好！以赵云之见，此事当如此处理...
                    <br><br>
                    <em>（此处可集成真实 AI 响应）</em>
                </div>
            `;
            
            input.value = '';
            messagesDiv.scrollTop = messagesDiv.scrollHeight;
        }
        
        document.getElementById('user-input').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') sendToZhaoYun();
        });
    </script>
</body>
</html>
EOF

# 10. 更新服务状态检查脚本
cat > "$TARGET_DIR/check-services.sh" << 'EOF'
#!/bin/bash

echo "🔍 地狱之门服务状态检查"
echo "========================"

services=("ChatGPT:3001" "Claude:3002" "Gemini:3003" "Grok:3004" "LocalModel:3005" "ZhaoYun:3006")

for service in "${services[@]}"; do
    name="${service%:*}"
    port="${service#*:}"
    
    if lsof -ti:$port > /dev/null 2>&1; then
        echo "✅ $name (端口 $port): 运行中"
    else
        echo "❌ $name (端口 $port): 未运行"
    fi
done

echo ""
echo "🌐 访问地址:"
echo "ChatGPT: http://localhost:3001"
echo "Claude: http://localhost:3002" 
echo "Gemini: http://localhost:3003"
echo "Grok: http://localhost:3004/grok-chat.html"
echo "ZhaoYun: http://localhost:3006/zhaoyun-chat.html"
echo "LocalModel: http://localhost:3005"
EOF

# 设置执行权限
chmod +x "$TARGET_DIR/chatgpt/start-chatgpt.sh" 2>/dev/null || true
chmod +x "$TARGET_DIR/claude/start-claude.sh" 2>/dev/null || true
chmod +x "$TARGET_DIR/gemini/start-gemini.sh" 2>/dev/null || true
chmod +x "$TARGET_DIR/grok/start-grok.sh"
chmod +x "$TARGET_DIR/zhaoyun/start-zhaoyun.sh"
chmod +x "$TARGET_DIR/local/start-local.sh" 2>/dev/null || true
chmod +x "$TARGET_DIR/hell-gate-control.sh"
chmod +x "$TARGET_DIR/check-services.sh"

# 复制主题文件
cp "$(pwd)/grok-theme.css" "$TARGET_DIR/" 2>/dev/null || echo "⚠️ grok-theme.css 未找到，请手动复制"
cp "$(pwd)/chatgpt-theme.css" "$TARGET_DIR/" 2>/dev/null || true
cp "$(pwd)/claude-theme.css" "$TARGET_DIR/" 2>/dev/null || true
cp "$(pwd)/gemini-theme.css" "$TARGET_DIR/" 2>/dev/null || true
cp "$(pwd)/hell-gate-theme.css" "$TARGET_DIR/" 2>/dev/null || true

echo "✅ 完整 AI 服务配置完成！"
echo ""
echo "📁 服务目录结构:"
echo "├── chatgpt/     - ChatGPT 独立服务"
echo "├── claude/      - Claude 独立服务"
echo "├── gemini/      - Gemini 独立服务"
echo "├── grok/        - Grok 独立服务 ⚡"
echo "├── zhaoyun/     - 赵云 AI 服务 🛡️"
echo "├── local/       - 本地模型服务"
echo "├── hell-gate-control.sh - 主控制脚本"
echo "└── check-services.sh    - 服务状态检查"
echo ""
echo "🚀 使用方法:"
echo "cd '$TARGET_DIR' && ./hell-gate-control.sh"