#!/usr/bin/env node

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// 分析凭证报告
function analyzeCredentialReport() {
    const csvPath = path.join(__dirname, 'CredentiaReport.csv');
    
    if (!fs.existsSync(csvPath)) {
        console.log('❌ 找不到 CredentiaReport.csv 文件');
        return;
    }
    
    const data = fs.readFileSync(csvPath, 'utf8');
    const lines = data.trim().split('\n');
    
    if (lines.length < 2) {
        console.log('❌ CSV文件格式不正确');
        return;
    }
    
    const headers = lines[0].split(',');
    const userRow = lines[1].split(',');
    
    console.log('🔐 AWS 凭证安全分析报告');
    console.log('=' * 50);
    
    // 基本信息
    const user = userRow[0];
    const creationTime = userRow[1];
    const lastLogon = userRow[2];
    
    console.log(`👤 用户: ${user}`);
    console.log(`📅 创建时间: ${creationTime}`);
    console.log(`🕐 最后登录: ${lastLogon}`);
    
    // 密码状态
    const passwordExist = userRow[3];
    const passwordActive = userRow[4];
    const mfaActive = userRow[7];
    
    console.log('\n🔑 密码和MFA状态:');
    console.log(`  密码存在: ${passwordExist === 'TRUE' ? '✅' : '❌'}`);
    console.log(`  密码激活: ${passwordActive}`);
    console.log(`  MFA启用: ${mfaActive === 'TRUE' ? '✅' : '❌'}`);
    
    // Access Key 分析
    console.log('\n🗝️  Access Key 状态:');
    
    // Access Key 1
    const ak1Exist = userRow[8];
    const ak1Active = userRow[9];
    console.log(`  Access Key 1: ${ak1Exist === 'TRUE' ? '存在' : '不存在'} ${ak1Active === 'TRUE' ? '(激活)' : '(未激活)'}`);
    
    // Access Key 2
    const ak2Exist = userRow[12];
    const ak2Active = userRow[13];
    console.log(`  Access Key 2: ${ak2Exist === 'TRUE' ? '存在' : '不存在'} ${ak2Active === 'TRUE' ? '(激活)' : '(未激活)'}`);
    
    // 安全建议
    console.log('\n💡 安全建议:');
    
    if (ak1Exist === 'FALSE' && ak2Exist === 'FALSE') {
        console.log('  ✅ 很好！没有access key，降低了泄露风险');
    } else {
        console.log('  ⚠️  建议定期轮换access key');
        console.log('  ⚠️  确保access key安全存储');
    }
    
    if (mfaActive === 'TRUE') {
        console.log('  ✅ MFA已启用，安全性良好');
    } else {
        console.log('  🚨 强烈建议启用MFA！');
    }
    
    // 生成安全报告
    const report = {
        user: user,
        timestamp: new Date().toISOString(),
        security_score: calculateSecurityScore(userRow),
        recommendations: generateRecommendations(userRow)
    };
    
    fs.writeFileSync('security-report.json', JSON.stringify(report, null, 2));
    console.log('\n📊 详细报告已保存到 security-report.json');
}

function calculateSecurityScore(userRow) {
    let score = 0;
    
    // MFA启用 +40分
    if (userRow[7] === 'TRUE') score += 40;
    
    // 密码存在 +20分
    if (userRow[3] === 'TRUE') score += 20;
    
    // 没有access key +30分 (更安全)
    if (userRow[8] === 'FALSE' && userRow[12] === 'FALSE') score += 30;
    
    // 最近登录 +10分
    const lastLogon = new Date(userRow[2]);
    const now = new Date();
    const daysSinceLogin = (now - lastLogon) / (1000 * 60 * 60 * 24);
    if (daysSinceLogin < 30) score += 10;
    
    return Math.min(score, 100);
}

function generateRecommendations(userRow) {
    const recommendations = [];
    
    if (userRow[7] !== 'TRUE') {
        recommendations.push('启用多因素认证(MFA)');
    }
    
    if (userRow[8] === 'TRUE' || userRow[12] === 'TRUE') {
        recommendations.push('定期轮换Access Key');
        recommendations.push('使用IAM角色替代长期Access Key');
    }
    
    if (userRow[3] !== 'TRUE') {
        recommendations.push('设置强密码');
    }
    
    return recommendations;
}

// 运行分析
analyzeCredentialReport();