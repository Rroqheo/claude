#!/bin/bash

# 地狱之门 ChatGPT 配置脚本
# 目标路径: /Users/b/Documents/Bsng/地狱之门_

echo "🔥 地狱之门 ChatGPT 配置开始..."

# 创建目标目录
TARGET_DIR="/Users/b/Documents/Bsng/地狱之门_"
mkdir -p "$TARGET_DIR"

# 复制 Claudia 核心文件到目标目录
echo "📁 复制核心文件..."
cp -r "$(pwd)/src" "$TARGET_DIR/"
cp -r "$(pwd)/src-tauri" "$TARGET_DIR/"
cp "$(pwd)/package.json" "$TARGET_DIR/"
cp "$(pwd)/tsconfig.json" "$TARGET_DIR/"
cp "$(pwd)/vite.config.ts" "$TARGET_DIR/"
cp "$(pwd)/index.html" "$TARGET_DIR/"
cp -r "$(pwd)/public" "$TARGET_DIR/"

# 创建专门的 ChatGPT 配置
echo "🤖 配置 ChatGPT 环境..."
cat > "$TARGET_DIR/.env" << 'EOF'
# 地狱之门 ChatGPT 配置
OPENAI_API_KEY="your_openai_api_key_here"
OPENAI_BASE_URL="https://api.openai.com/v1"
OPENAI_MODEL="gpt-4"

# Ollama 本地配置 (备用)
OLLAMA_BASE_URL="http://localhost:11434/v1"
OLLAMA_MODEL="qwen2.5-coder:7b"

# 地狱之门特殊配置
HELL_GATE_MODE="true"
CHAT_THEME="dark"
EOF

# 创建启动脚本
cat > "$TARGET_DIR/start-hell-gate.sh" << 'EOF'
#!/bin/bash
echo "🔥 启动地狱之门 ChatGPT..."
cd "$(dirname "$0")"
source .env
npm install
npm run tauri dev
EOF

chmod +x "$TARGET_DIR/start-hell-gate.sh"

# 创建 README
cat > "$TARGET_DIR/README.md" << 'EOF'
# 🔥 地狱之门 ChatGPT

## 快速启动
```bash
cd /Users/b/Documents/Bsng/地狱之门_
./start-hell-gate.sh
```

## 配置说明
1. 编辑 `.env` 文件，设置您的 OpenAI API Key
2. 或者使用本地 Ollama 模型
3. 运行启动脚本即可

## 功能特性
- 🤖 ChatGPT 集成
- 🔥 地狱之门主题
- 💻 代码编辑器
- 📁 文件管理
- 🎯 AI 编程助手
EOF

echo "✅ 地狱之门 ChatGPT 配置完成！"
echo "📍 目标路径: $TARGET_DIR"
echo "🚀 运行: cd '$TARGET_DIR' && ./start-hell-gate.sh"