#!/bin/bash

echo "🚀 GitHub 自动化设置 - Claudia 项目"
echo "=================================="

# 检查GitHub CLI是否安装
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI 未安装"
    echo "📥 正在安装 GitHub CLI..."
    if command -v brew &> /dev/null; then
        brew install gh
    else
        echo "请手动安装 GitHub CLI: https://cli.github.com/"
        echo "或者使用网页方式创建仓库"
        exit 1
    fi
fi

echo "📋 项目信息："
echo "仓库名: claudia"
echo "用户: Rroqheo"
echo "描述: Claudia - AI Desktop Application with Tauri, React, and Multiple AI Services"

echo ""
echo "🔐 GitHub 认证状态："
gh auth status 2>/dev/null || {
    echo "需要登录 GitHub..."
    echo "运行: gh auth login"
    echo "选择: GitHub.com -> HTTPS -> Yes -> Login with a web browser"
    exit 1
}

echo ""
echo "📦 创建 GitHub 仓库..."
gh repo create claudia --public --description "Claudia - AI Desktop Application with Tauri, React, and Multiple AI Services" --clone=false

echo ""
echo "🚀 推送代码到 GitHub..."
git push -u origin main

echo ""
echo "✅ 完成！你的仓库现在可以在以下地址访问："
echo "🌐 https://github.com/Rroqheo/claudia"

echo ""
echo "📊 项目统计："
echo "提交数: $(git rev-list --count HEAD)"
echo "文件数: $(find . -type f -not -path './.git/*' | wc -l | tr -d ' ')"
echo "代码行数: $(find . -name '*.tsx' -o -name '*.ts' -o -name '*.rs' -o -name '*.js' | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}' || echo '计算中...')"