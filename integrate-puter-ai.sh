#!/bin/bash

echo "🚀 正在为地狱之门添加 Puter.js AI 完整演示..."
echo "=============================================="

HELL_GATE_DIR="/Users/b/Documents/Bsng/地狱之门_"
PUTER_DIR="$HELL_GATE_DIR/puter-ai"

# 创建 Puter AI 目录
mkdir -p "$PUTER_DIR"

# 复制完整演示文件
cp "/Users/b/claudia/puter-ai-complete-demo.html" "$PUTER_DIR/puter-ai-demo.html"
cp "/Users/b/claudia/puter-auth-demo.html" "$PUTER_DIR/puter-auth-demo.html"

# 创建 Puter AI 配置文件
cat > "$PUTER_DIR/.env" << 'EOF'
# Puter.js AI 服务配置
SERVICE_NAME=Puter AI
PORT=3007
DESCRIPTION=免费无服务器 AI 服务，支持多种模型
FEATURES=GPT-4o,Claude 3.5 Sonnet,Llama,图像分析,流式响应
API_KEY_REQUIRED=false
COST=FREE
EOF

# 创建 Puter AI 启动脚本
cat > "$PUTER_DIR/start-puter-ai.sh" << 'EOF'
#!/bin/bash

echo "🚀 启动 Puter.js AI 服务..."
echo "=============================="

PORT=3007
SERVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 检查端口是否被占用
if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null ; then
    echo "❌ 端口 $PORT 已被占用"
    echo "正在尝试停止现有服务..."
    pkill -f "python.*$PORT" 2>/dev/null || true
    sleep 2
fi

# 创建简单的 HTTP 服务器
cat > "$SERVICE_DIR/server.py" << 'PYEOF'
#!/usr/bin/env python3
import http.server
import socketserver
import os
import sys

PORT = 3007
SERVICE_DIR = os.path.dirname(os.path.abspath(__file__))

class PuterAIHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=SERVICE_DIR, **kwargs)
    
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        super().end_headers()

if __name__ == "__main__":
    os.chdir(SERVICE_DIR)
    with socketserver.TCPServer(("", PORT), PuterAIHandler) as httpd:
        print(f"🌐 Puter.js AI 服务已启动")
        print(f"📍 访问地址: http://localhost:{PORT}/puter-ai-demo.html")
        print(f"🔐 身份验证演示: http://localhost:{PORT}/puter-auth-demo.html")
        print(f"⚡ 特性: 免费 AI 服务，无需 API 密钥")
        print("按 Ctrl+C 停止服务")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n🛑 Puter.js AI 服务已停止")
PYEOF

# 启动服务
python3 "$SERVICE_DIR/server.py"
EOF

# 设置执行权限
chmod +x "$PUTER_DIR/start-puter-ai.sh"

# 创建 Puter AI 主题样式
cat > "$HELL_GATE_DIR/puter-ai-theme.css" << 'EOF'
/* Puter.js AI 专用界面样式 */
:root {
    --puter-primary: #6366f1;
    --puter-secondary: #8b5cf6;
    --puter-accent: #06b6d4;
    --puter-bg: #0f172a;
    --puter-surface: #1e293b;
    --puter-text: #f8fafc;
    --puter-success: #10b981;
    --puter-warning: #f59e0b;
    --puter-error: #ef4444;
    --puter-glow: rgba(99, 102, 241, 0.3);
    --puter-electric: #00d4ff;
    --puter-quantum: #ff6b6b;
}

.puter-container {
    background: linear-gradient(135deg, var(--puter-bg), #1e1b4b);
    border: 2px solid var(--puter-primary);
    border-radius: 20px;
    padding: 30px;
    box-shadow: 
        0 0 30px var(--puter-glow),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
    position: relative;
    overflow: hidden;
}

.puter-container::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: 
        radial-gradient(circle at 20% 80%, var(--puter-electric) 0%, transparent 50%),
        radial-gradient(circle at 80% 20%, var(--puter-quantum) 0%, transparent 50%);
    opacity: 0.1;
    pointer-events: none;
}

.puter-header {
    text-align: center;
    margin-bottom: 30px;
    position: relative;
    z-index: 1;
}

.puter-title {
    font-size: 2.5rem;
    font-weight: bold;
    background: linear-gradient(45deg, var(--puter-primary), var(--puter-electric));
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin-bottom: 15px;
    text-shadow: 0 0 30px var(--puter-glow);
}

.puter-subtitle {
    color: var(--puter-accent);
    font-size: 1.1rem;
    opacity: 0.9;
}

.puter-chat-area {
    background: rgba(30, 41, 59, 0.8);
    border: 1px solid var(--puter-primary);
    border-radius: 15px;
    padding: 20px;
    margin: 20px 0;
    backdrop-filter: blur(10px);
}

.puter-message {
    margin: 15px 0;
    padding: 15px;
    border-radius: 12px;
    position: relative;
    animation: puterFadeIn 0.5s ease-out;
}

@keyframes puterFadeIn {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.puter-message.user {
    background: linear-gradient(135deg, var(--puter-primary), var(--puter-secondary));
    margin-left: 20%;
    border-bottom-right-radius: 5px;
}

.puter-message.ai {
    background: linear-gradient(135deg, var(--puter-surface), rgba(6, 182, 212, 0.2));
    margin-right: 20%;
    border: 1px solid var(--puter-accent);
    border-bottom-left-radius: 5px;
}

.puter-input-area {
    display: flex;
    gap: 15px;
    margin-top: 20px;
    position: relative;
    z-index: 1;
}

.puter-input {
    flex: 1;
    padding: 15px 20px;
    background: rgba(15, 23, 42, 0.8);
    border: 2px solid var(--puter-primary);
    border-radius: 25px;
    color: var(--puter-text);
    font-size: 16px;
    backdrop-filter: blur(10px);
    transition: all 0.3s ease;
}

.puter-input:focus {
    outline: none;
    border-color: var(--puter-electric);
    box-shadow: 0 0 20px var(--puter-glow);
    background: rgba(15, 23, 42, 0.9);
}

.puter-send-btn {
    background: linear-gradient(45deg, var(--puter-primary), var(--puter-electric));
    border: none;
    border-radius: 50%;
    width: 50px;
    height: 50px;
    color: white;
    font-size: 20px;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 5px 15px var(--puter-glow);
}

.puter-send-btn:hover {
    transform: scale(1.1) rotate(15deg);
    box-shadow: 0 8px 25px var(--puter-glow);
}

.puter-model-selector {
    display: flex;
    gap: 10px;
    margin-bottom: 20px;
    flex-wrap: wrap;
    justify-content: center;
}

.puter-model-btn {
    padding: 10px 20px;
    background: rgba(30, 41, 59, 0.8);
    border: 1px solid var(--puter-primary);
    border-radius: 20px;
    color: var(--puter-text);
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 14px;
    backdrop-filter: blur(10px);
}

.puter-model-btn:hover {
    background: var(--puter-primary);
    transform: translateY(-2px);
    box-shadow: 0 5px 15px var(--puter-glow);
}

.puter-model-btn.active {
    background: linear-gradient(45deg, var(--puter-primary), var(--puter-electric));
    border-color: var(--puter-electric);
}

.puter-feature-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
    margin: 30px 0;
}

.puter-feature-card {
    background: rgba(30, 41, 59, 0.6);
    border: 1px solid var(--puter-accent);
    border-radius: 15px;
    padding: 25px;
    text-align: center;
    transition: all 0.3s ease;
    backdrop-filter: blur(10px);
    position: relative;
    overflow: hidden;
}

.puter-feature-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 3px;
    background: linear-gradient(90deg, var(--puter-primary), var(--puter-electric));
}

.puter-feature-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 15px 30px var(--puter-glow);
    border-color: var(--puter-electric);
}

.puter-feature-icon {
    font-size: 2.5rem;
    margin-bottom: 15px;
    display: block;
}

.puter-feature-title {
    font-size: 1.2rem;
    font-weight: bold;
    color: var(--puter-electric);
    margin-bottom: 10px;
}

.puter-feature-desc {
    color: var(--puter-text);
    opacity: 0.8;
    line-height: 1.5;
}

.puter-loading {
    display: inline-block;
    width: 20px;
    height: 20px;
    border: 3px solid rgba(99, 102, 241, 0.3);
    border-radius: 50%;
    border-top-color: var(--puter-electric);
    animation: puterSpin 1s linear infinite;
}

@keyframes puterSpin {
    to { transform: rotate(360deg); }
}

.puter-status-bar {
    background: rgba(15, 23, 42, 0.9);
    border: 1px solid var(--puter-primary);
    border-radius: 10px;
    padding: 15px;
    margin: 20px 0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    backdrop-filter: blur(10px);
}

.puter-status-item {
    text-align: center;
}

.puter-status-value {
    font-size: 1.5rem;
    font-weight: bold;
    color: var(--puter-electric);
}

.puter-status-label {
    font-size: 0.9rem;
    color: var(--puter-text);
    opacity: 0.7;
}

/* 响应式设计 */
@media (max-width: 768px) {
    .puter-title {
        font-size: 2rem;
    }
    
    .puter-input-area {
        flex-direction: column;
    }
    
    .puter-send-btn {
        align-self: flex-end;
        width: 60px;
        height: 60px;
    }
    
    .puter-feature-grid {
        grid-template-columns: 1fr;
    }
    
    .puter-message {
        margin-left: 0;
        margin-right: 0;
    }
}

/* 深色模式优化 */
@media (prefers-color-scheme: dark) {
    .puter-container {
        box-shadow: 
            0 0 40px var(--puter-glow),
            inset 0 1px 0 rgba(255, 255, 255, 0.05);
    }
}
EOF

# 更新主控制脚本
if [ -f "$HELL_GATE_DIR/hell-gate-control.sh" ]; then
    # 备份原文件
    cp "$HELL_GATE_DIR/hell-gate-control.sh" "$HELL_GATE_DIR/hell-gate-control.sh.backup"
    
    # 添加 Puter AI 服务
    sed -i '' 's/services=("chatgpt" "claude" "gemini" "grok" "zhaoyun" "local")/services=("chatgpt" "claude" "gemini" "grok" "zhaoyun" "local" "puter-ai")/' "$HELL_GATE_DIR/hell-gate-control.sh"
    sed -i '' 's/service_names=("ChatGPT" "Claude" "Gemini" "Grok" "赵云 AI" "本地模型")/service_names=("ChatGPT" "Claude" "Gemini" "Grok" "赵云 AI" "本地模型" "Puter AI")/' "$HELL_GATE_DIR/hell-gate-control.sh"
    sed -i '' 's/ports=(3001 3002 3003 3004 3005 3006)/ports=(3001 3002 3003 3004 3005 3006 3007)/' "$HELL_GATE_DIR/hell-gate-control.sh"
fi

# 更新服务检查脚本
if [ -f "$HELL_GATE_DIR/check-services.sh" ]; then
    # 备份原文件
    cp "$HELL_GATE_DIR/check-services.sh" "$HELL_GATE_DIR/check-services.sh.backup"
    
    # 添加 Puter AI 服务检查
    cat >> "$HELL_GATE_DIR/check-services.sh" << 'EOF'

echo "🚀 Puter AI:"
if lsof -Pi :3007 -sTCP:LISTEN -t >/dev/null ; then
    echo "   状态: ✅ 运行中"
    echo "   地址: http://localhost:3007/puter-ai-demo.html"
    echo "   身份验证: http://localhost:3007/puter-auth-demo.html"
else
    echo "   状态: ❌ 未运行"
    echo "   启动: cd '$HELL_GATE_DIR/puter-ai' && ./start-puter-ai.sh"
fi
EOF
fi

# 更新 README
if [ -f "$HELL_GATE_DIR/README.md" ]; then
    cat >> "$HELL_GATE_DIR/README.md" << 'EOF'

## 🚀 Puter.js AI 服务

### 特性
- 🆓 完全免费，无需 API 密钥
- 🤖 支持多种 AI 模型（GPT-4o、Claude 3.5 Sonnet、Llama）
- 👁️ 图像分析功能（GPT-4 Vision）
- ⚡ 流式响应支持
- 🔐 用户付费模式
- 📱 响应式设计

### 访问地址
- 完整演示: http://localhost:3007/puter-ai-demo.html
- 身份验证演示: http://localhost:3007/puter-auth-demo.html

### 启动方法
```bash
cd puter-ai && ./start-puter-ai.sh
```

### 支持的模型
1. **GPT-4o** - 基本文本生成和图像分析
2. **Claude 3.5 Sonnet** - 复杂分析和推理
3. **Llama** - 长文本生成和流式响应

### 功能演示
- 基本文本生成
- 复杂分析任务
- 流式响应
- 图像分析
- 多模型对比
- 使用统计
EOF
fi

echo ""
echo "✅ Puter.js AI 服务配置完成！"
echo "================================"
echo ""
echo "📁 服务目录: $PUTER_DIR"
echo "🌐 完整演示: http://localhost:3007/puter-ai-demo.html"
echo "🔐 身份验证: http://localhost:3007/puter-auth-demo.html"
echo ""
echo "🚀 启动命令:"
echo "   cd '$PUTER_DIR' && ./start-puter-ai.sh"
echo ""
echo "⚡ 特性:"
echo "   • 完全免费，无需 API 密钥"
echo "   • 支持 GPT-4o、Claude 3.5 Sonnet、Llama"
echo "   • 图像分析功能"
echo "   • 流式响应"
echo "   • 多模型对比"
echo "   • 使用统计"
echo ""
echo "🔥 地狱之门现在包含 7 个 AI 服务！"