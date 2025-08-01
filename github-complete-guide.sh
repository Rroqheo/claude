#!/bin/bash

echo "🎯 GitHub 完整设置指南 - 三种方法"
echo "================================="

echo "📋 当前状态："
echo "Git 用户: $(git config user.name)"
echo "远程仓库: $(git remote get-url origin)"
echo "待推送提交: $(git rev-list --count origin/main..HEAD 2>/dev/null || echo '4')"

echo ""
echo "🚀 方法1: GitHub CLI (推荐 - 最简单)"
echo "================================="
echo "1️⃣ 登录 GitHub CLI:"
echo "   gh auth login"
echo "   选择: GitHub.com -> HTTPS -> Yes -> Login with a web browser"
echo ""
echo "2️⃣ 创建仓库并推送:"
echo "   gh repo create claudia --public --description 'Claudia AI Desktop App'"
echo "   git push -u origin main"

echo ""
echo "🌐 方法2: 网页创建 (传统方式)"
echo "=========================="
echo "1️⃣ 访问: https://github.com/new"
echo "2️⃣ 仓库名: claudia"
echo "3️⃣ 选择 Public"
echo "4️⃣ 不要勾选任何初始化选项"
echo "5️⃣ 点击 Create repository"
echo "6️⃣ 推送代码: git push -u origin main"

echo ""
echo "🔑 方法3: Personal Access Token"
echo "=============================="
echo "1️⃣ 生成 Token: https://github.com/settings/tokens"
echo "2️⃣ 勾选 'repo' 权限"
echo "3️⃣ 复制 Token"
echo "4️⃣ 推送时使用:"
echo "   用户名: Rroqheo"
echo "   密码: [你的Token]"

echo ""
echo "⚡ 快速执行 (选择一个):"
echo "====================="
echo "GitHub CLI: ./github-auto-setup.sh"
echo "或手动: gh auth login && gh repo create claudia --public && git push -u origin main"

echo ""
echo "✅ 完成后访问: https://github.com/Rroqheo/claudia"