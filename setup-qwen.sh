#!/bin/bash

# Qwen Code Setup Script
echo "🚀 Setting up Qwen CLI Code..."

# Check if .zshrc exists, if not create it
if [ ! -f ~/.zshrc ]; then
    touch ~/.zshrc
fi

# Add npm global bin to PATH in .zshrc if not already present
if ! grep -q "/Users/b/.npm-global/bin" ~/.zshrc; then
    echo "" >> ~/.zshrc
    echo "# Add npm global bin to PATH for Qwen Code" >> ~/.zshrc
    echo 'export PATH="/Users/b/.npm-global/bin:$PATH"' >> ~/.zshrc
    echo "✅ Added npm global bin to PATH in ~/.zshrc"
else
    echo "✅ npm global bin already in PATH"
fi

# Add Qwen Code environment variables if not already present
if ! grep -q "OPENAI_MODEL.*qwen" ~/.zshrc; then
    echo "" >> ~/.zshrc
    echo "# Qwen Code Configuration" >> ~/.zshrc
    echo 'export OPENAI_BASE_URL="https://dashscope-intl.aliyuncs.com/compatible-mode/v1"' >> ~/.zshrc
    echo 'export OPENAI_MODEL="qwen3-coder-plus"' >> ~/.zshrc
    echo "# export OPENAI_API_KEY=\"your_api_key_here\"  # Uncomment and set your API key" >> ~/.zshrc
    echo "✅ Added Qwen Code environment variables to ~/.zshrc"
else
    echo "✅ Qwen Code environment variables already configured"
fi

echo ""
echo "🎉 Qwen CLI Code setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Set your API key: export OPENAI_API_KEY=\"your_actual_api_key\""
echo "2. Restart your terminal or run: source ~/.zshrc"
echo "3. Test with: qwen --version"
echo ""
echo "💡 Usage examples:"
echo "   qwen \"Help me write a function to sort an array\""
echo "   qwen --checkpointing \"Refactor this code file\""
echo ""