#!/bin/bash

# Docker Setup Script for Claudia - Multi-AI Desktop Application
# This script addresses the "docker 绑定了没有" (Docker binding) issue

echo "🐳 Setting up Docker environment for Claudia..."
echo "================================================================"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker compose &> /dev/null && ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose."
    echo "   Visit: https://docs.docker.com/compose/install/"
    exit 1
fi

# Create necessary directories
echo "📁 Creating necessary directories..."
mkdir -p logs init-scripts ssl

# Create environment file if it doesn't exist
if [ ! -f .env ]; then
    echo "⚙️  Creating environment configuration..."
    cat > .env << 'EOF'
# AI Service API Keys - Replace with your actual keys
OPENAI_API_KEY=your-openai-api-key-here
ANTHROPIC_API_KEY=your-claude-api-key-here
GEMINI_API_KEY=your-gemini-api-key-here
XAI_API_KEY=your-grok-api-key-here
QWEN_API_KEY=your-qwen-api-key-here
DASHSCOPE_API_KEY=your-dashscope-api-key-here

# Database Configuration
POSTGRES_PASSWORD=claudia123
GRAFANA_PASSWORD=admin123

# Application Settings
CLAUDE_DIR=/home/claudia/.claude
NODE_ENV=production
EOF
    echo "✅ Created .env file - Please update it with your actual API keys"
else
    echo "✅ Environment file already exists"
fi

# Create basic nginx configuration
if [ ! -f nginx.conf ]; then
    echo "🌐 Creating nginx configuration..."
    cat > nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    upstream claudia-app {
        server claudia:3000;
    }
    
    upstream ollama-service {
        server ollama:11434;
    }
    
    server {
        listen 80;
        server_name localhost;
        
        # Health check endpoint
        location /health {
            return 200 "OK\n";
            add_header Content-Type text/plain;
        }
        
        # Proxy to Claudia app
        location / {
            proxy_pass http://claudia-app;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
        
        # Proxy to Ollama API
        location /ollama/ {
            rewrite ^/ollama/(.*)$ /$1 break;
            proxy_pass http://ollama-service;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
EOF
    echo "✅ Created nginx.conf"
else
    echo "✅ Nginx configuration already exists"
fi

# Create Prometheus configuration (optional)
if [ ! -f prometheus.yml ]; then
    echo "📊 Creating Prometheus configuration..."
    cat > prometheus.yml << 'EOF'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'claudia'
    static_configs:
      - targets: ['claudia:3000']
  - job_name: 'ollama'
    static_configs:
      - targets: ['ollama:11434']
EOF
    echo "✅ Created prometheus.yml"
else
    echo "✅ Prometheus configuration already exists"
fi

# Create database initialization script
cat > init-scripts/01-init.sql << 'EOF'
-- Initialize Claudia database
CREATE DATABASE IF NOT EXISTS claudia;

-- Create user sessions table
CREATE TABLE IF NOT EXISTS user_sessions (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(255) UNIQUE NOT NULL,
    ai_service VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB
);

-- Create usage analytics table
CREATE TABLE IF NOT EXISTS usage_analytics (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(255) REFERENCES user_sessions(session_id),
    tokens_used INTEGER,
    cost_estimate DECIMAL(10,4),
    service VARCHAR(100),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_sessions_service ON user_sessions(ai_service);
CREATE INDEX IF NOT EXISTS idx_analytics_timestamp ON usage_analytics(timestamp);
CREATE INDEX IF NOT EXISTS idx_analytics_service ON usage_analytics(service);
EOF

echo "✅ Created database initialization script"

# Function to handle different Docker Compose commands
use_compose() {
    if command -v docker &> /dev/null && docker compose version &> /dev/null; then
        docker compose "$@"
    elif command -v docker-compose &> /dev/null; then
        docker-compose "$@"
    else
        echo "❌ Neither 'docker compose' nor 'docker-compose' is available"
        exit 1
    fi
}

echo ""
echo "🚀 Docker environment setup complete!"
echo ""
echo "Available commands:"
echo "  🏗️  Build and start all services:"
echo "     ./docker-setup.sh up"
echo ""
echo "  🔧 Start with monitoring (Prometheus + Grafana):"
echo "     ./docker-setup.sh up-with-monitoring"
echo ""
echo "  💻 Start development environment:"
echo "     ./docker-setup.sh dev"
echo ""
echo "  🛑 Stop all services:"
echo "     ./docker-setup.sh down"
echo ""
echo "  📊 View logs:"
echo "     ./docker-setup.sh logs"
echo ""
echo "  🔄 Restart services:"
echo "     ./docker-setup.sh restart"
echo ""
echo "  🧹 Clean up everything:"
echo "     ./docker-setup.sh cleanup"
echo ""

# Handle command line arguments
case "${1:-}" in
    "up")
        echo "🏗️ Building and starting Claudia services..."
        use_compose up -d --build
        echo ""
        echo "✅ Services started! Access points:"
        echo "   🖥️  Claudia VNC: vnc://localhost:5900"
        echo "   🔄 Nginx proxy: http://localhost"
        echo "   🧠 Ollama API: http://localhost:11434"
        echo "   📊 Redis: localhost:6379"
        echo "   🗄️  PostgreSQL: localhost:5432"
        ;;
    "dev")
        echo "💻 Starting development environment..."
        use_compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
        echo ""
        echo "✅ Development environment started! Access points:"
        echo "   🖥️  Claudia Dev: http://localhost:8080"
        echo "   ⚡ Vite HMR: http://localhost:8080/vite"
        echo "   🧠 Ollama API: http://localhost:11434"
        echo "   📊 Redis Dev: localhost:6380" 
        echo "   🗄️  PostgreSQL Dev: localhost:5433"
        echo "   📝 Live reload enabled for source code changes"
        ;;
    "up-with-monitoring")
        echo "🏗️ Building and starting Claudia services with monitoring..."
        use_compose --profile monitoring up -d --build
        echo ""
        echo "✅ Services started with monitoring! Access points:"
        echo "   🖥️  Claudia VNC: vnc://localhost:5900"
        echo "   🔄 Nginx proxy: http://localhost"
        echo "   🧠 Ollama API: http://localhost:11434"
        echo "   📊 Prometheus: http://localhost:9090"
        echo "   📈 Grafana: http://localhost:3000 (admin/admin123)"
        ;;
    "down")
        echo "🛑 Stopping all services..."
        use_compose --profile monitoring down
        echo "✅ All services stopped"
        ;;
    "logs")
        echo "📊 Showing service logs..."
        use_compose logs -f
        ;;
    "restart")
        echo "🔄 Restarting services..."
        use_compose restart
        echo "✅ Services restarted"
        ;;
    "cleanup")
        echo "🧹 Cleaning up all containers, volumes, and images..."
        use_compose --profile monitoring down -v --remove-orphans
        docker system prune -f
        echo "✅ Cleanup complete"
        ;;
    "")
        echo "✨ Setup complete! Use one of the commands above to continue."
        ;;
    *)
        echo "❓ Unknown command: $1"
        echo "   Available: up, up-with-monitoring, dev, down, logs, restart, cleanup"
        exit 1
        ;;
esac