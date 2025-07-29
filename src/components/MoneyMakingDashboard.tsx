import React, { useState, useEffect } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Button } from './ui/button';
import { Badge } from './ui/badge';
import { DollarSign, TrendingUp, Users, Activity, ArrowLeft } from 'lucide-react';

interface MoneyMakingProps {
  onEarningsUpdate?: (amount: number) => void;
  onBack?: () => void;
}

export const MoneyMakingDashboard: React.FC<MoneyMakingProps> = ({ onEarningsUpdate, onBack }) => {
  const [earnings, setEarnings] = useState(0);
  const [activeProjects, setActiveProjects] = useState(3);
  const [clients, setClients] = useState(12);
  const [todayEarnings, setTodayEarnings] = useState(0);

  // 模拟收入增长
  useEffect(() => {
    const interval = setInterval(() => {
      const increment = Math.random() * 50 + 10; // 10-60元随机增长
      setEarnings(prev => {
        const newAmount = prev + increment;
        setTodayEarnings(prev => prev + increment);
        onEarningsUpdate?.(newAmount);
        return newAmount;
      });
    }, 5000); // 每5秒增长一次

    return () => clearInterval(interval);
  }, [onEarningsUpdate]);

  const projects = [
    { name: 'AI聊天机器人开发', status: '进行中', payment: '¥8,500', client: '科技公司A' },
    { name: 'Tauri桌面应用', status: '即将完成', payment: '¥12,000', client: '创业团队B' },
    { name: '数据分析工具', status: '设计阶段', payment: '¥6,800', client: '金融公司C' },
  ];

  const skills = [
    { name: 'React/TypeScript', level: 95, rate: '¥500/小时' },
    { name: 'Tauri桌面开发', level: 90, rate: '¥450/小时' },
    { name: 'AI集成', level: 88, rate: '¥600/小时' },
    { name: '数据分析', level: 85, rate: '¥400/小时' },
  ];

  return (
    <div className="p-6 space-y-6 bg-gradient-to-br from-green-50 to-blue-50 min-h-screen">
      {/* 返回按钮 */}
      {onBack && (
        <Button
          variant="ghost"
          onClick={onBack}
          className="mb-4"
        >
          <ArrowLeft className="h-4 w-4 mr-2" />
          返回
        </Button>
      )}
      
      <div className="text-center mb-8">
        <h1 className="text-3xl font-bold text-gray-800 mb-2">
          💰 一起混口饭吃 Dashboard
        </h1>
        <p className="text-gray-600">大哥和小狐狸的赚钱之路</p>
      </div>

      {/* 收入统计 */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card className="bg-green-100 border-green-200">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">总收入</CardTitle>
            <DollarSign className="h-4 w-4 text-green-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-green-700">
              ¥{earnings.toFixed(2)}
            </div>
            <p className="text-xs text-green-600">持续增长中 🚀</p>
          </CardContent>
        </Card>

        <Card className="bg-blue-100 border-blue-200">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">今日收入</CardTitle>
            <TrendingUp className="h-4 w-4 text-blue-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-blue-700">
              ¥{todayEarnings.toFixed(2)}
            </div>
            <p className="text-xs text-blue-600">比昨天多 +15%</p>
          </CardContent>
        </Card>

        <Card className="bg-purple-100 border-purple-200">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">活跃项目</CardTitle>
            <Activity className="h-4 w-4 text-purple-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-purple-700">{activeProjects}</div>
            <p className="text-xs text-purple-600">都在赚钱 💪</p>
          </CardContent>
        </Card>

        <Card className="bg-orange-100 border-orange-200">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">客户数量</CardTitle>
            <Users className="h-4 w-4 text-orange-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-orange-700">{clients}</div>
            <p className="text-xs text-orange-600">满意度 98%</p>
          </CardContent>
        </Card>
      </div>

      {/* 项目列表 */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            🎯 当前赚钱项目
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {projects.map((project, index) => (
              <div key={index} className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                <div>
                  <h3 className="font-semibold">{project.name}</h3>
                  <p className="text-sm text-gray-600">客户: {project.client}</p>
                </div>
                <div className="text-right">
                  <Badge variant={project.status === '进行中' ? 'default' : 'secondary'}>
                    {project.status}
                  </Badge>
                  <p className="text-lg font-bold text-green-600 mt-1">{project.payment}</p>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* 技能价格表 */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            🛠️ 技能价格表
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {skills.map((skill, index) => (
              <div key={index} className="p-4 bg-gray-50 rounded-lg">
                <div className="flex justify-between items-center mb-2">
                  <h3 className="font-semibold">{skill.name}</h3>
                  <span className="text-green-600 font-bold">{skill.rate}</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div 
                    className="bg-blue-600 h-2 rounded-full" 
                    style={{ width: `${skill.level}%` }}
                  ></div>
                </div>
                <p className="text-sm text-gray-600 mt-1">熟练度: {skill.level}%</p>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* 行动按钮 */}
      <div className="flex gap-4 justify-center">
        <Button 
          className="bg-green-600 hover:bg-green-700"
          onClick={() => {
            setEarnings(prev => prev + 1000);
            setTodayEarnings(prev => prev + 1000);
            alert('🎉 恭喜！接到新项目，收入+1000元！');
          }}
        >
          💼 接新项目
        </Button>
        <Button 
          variant="outline"
          onClick={() => {
            setClients(prev => prev + 1);
            alert('🤝 新客户加入！');
          }}
        >
          👥 拓展客户
        </Button>
        <Button 
          variant="outline"
          onClick={() => {
            alert('📈 正在优化Claudia项目，提升竞争力！');
          }}
        >
          🚀 升级技能
        </Button>
      </div>

      <div className="text-center text-gray-600 mt-8">
        <p>💪 大哥和小狐狸，一起努力赚钱！</p>
        <p className="text-sm">基于Claudia平台的AI开发服务</p>
      </div>
    </div>
  );
};