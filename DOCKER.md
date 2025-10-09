# Docker Containerization Guide for Claudia

## 🐳 Docker 绑定 (Docker Binding) - Complete Setup

This document addresses the "docker 绑定了没有" (Is Docker bound?) question by providing complete containerization support for the Claudia multi-AI desktop application.

## 📋 Prerequisites

Before starting, ensure you have:

- **Docker** (20.10+) installed
- **Docker Compose** (2.0+) installed  
- At least **4GB RAM** available
- **20GB free disk space**
- Valid API keys for AI services you want to use

## 🚀 Quick Start

### 1. Initial Setup
```bash
# Make the setup script executable
chmod +x docker-setup.sh

# Run the setup (creates config files)
./docker-setup.sh
```

### 2. Configure API Keys
Edit the `.env` file created by the setup script:
```bash
# Edit your API keys
nano .env
```

Required API keys:
- `OPENAI_API_KEY` - For ChatGPT integration
- `ANTHROPIC_API_KEY` - For Claude integration  
- `GEMINI_API_KEY` - For Google Gemini integration
- `XAI_API_KEY` - For Grok integration
- `QWEN_API_KEY` - For Qwen integration

### 3. Start Services
```bash
# Start all services
./docker-setup.sh up

# Or start with monitoring (Prometheus + Grafana)
./docker-setup.sh up-with-monitoring
```

## 🌐 Access Points

Once running, you can access:

| Service | URL | Description |
|---------|-----|-------------|
| **Claudia VNC** | `vnc://localhost:5900` | Remote desktop access to Claudia app |
| **Web Proxy** | `http://localhost` | Nginx reverse proxy |
| **Ollama API** | `http://localhost:11434` | Local AI models API |
| **Redis** | `localhost:6379` | Caching and session storage |
| **PostgreSQL** | `localhost:5432` | Main database |
| **Prometheus** | `http://localhost:9090` | Metrics (with monitoring) |
| **Grafana** | `http://localhost:3000` | Dashboards (with monitoring) |

## 🏗️ Architecture

The Docker setup includes:

```
┌─────────────────────────────────────────────┐
│                Nginx Proxy                  │
│          (Port 80/443)                      │
└─────────────────────────────────────────────┘
                        │
    ┌───────────────────┼───────────────────┐
    │                   │                   │
┌───▼────┐    ┌────────▼─────────┐    ┌────▼────┐
│Claudia │    │     Ollama       │    │  Redis  │
│  App   │    │  (Local AI)      │    │ Cache   │
│:5900   │    │    :11434        │    │ :6379   │
└────────┘    └──────────────────┘    └─────────┘
                        │
                ┌──────▼───────┐
                │ PostgreSQL   │
                │ Database     │
                │   :5432      │
                └──────────────┘
```

## 🛠️ Development Mode

For development with live reload:

```bash
# Start development environment
docker compose -f docker-compose.yml -f docker-compose.dev.yml up

# Or use the script
./docker-setup.sh dev
```

Development mode provides:
- **Live code reloading** for both Rust and React
- **Debug logging** enabled
- **Development ports** (different from production)
- **Source code mounting** for instant changes

## 🔧 Configuration

### Environment Variables

Key environment variables in `.env`:

```bash
# AI Services
OPENAI_API_KEY=sk-your-openai-key
ANTHROPIC_API_KEY=sk-ant-your-claude-key
GEMINI_API_KEY=your-gemini-key
XAI_API_KEY=your-grok-key

# Database
POSTGRES_PASSWORD=secure-password
GRAFANA_PASSWORD=admin-password

# Application
CLAUDE_DIR=/home/claudia/.claude
NODE_ENV=production
```

### Volume Mounts

Persistent data is stored in:
- `claude_data` - User projects and sessions
- `ollama_data` - Downloaded AI models
- `postgres_data` - Database storage
- `redis_data` - Cache and session data

## 📊 Monitoring (Optional)

Enable monitoring with Prometheus and Grafana:

```bash
# Start with monitoring
./docker-setup.sh up-with-monitoring
```

Monitoring includes:
- **Prometheus metrics** collection
- **Grafana dashboards** for visualization
- **Health checks** for all services
- **Performance monitoring** for AI services

## 🧹 Maintenance

### View Logs
```bash
# View all service logs
./docker-setup.sh logs

# View specific service logs
docker compose logs claudia
```

### Update Services
```bash
# Pull latest images and rebuild
docker compose pull
./docker-setup.sh up
```

### Backup Data
```bash
# Backup volumes
docker run --rm -v claude_data:/data -v $(pwd):/backup alpine tar czf /backup/claude-backup.tar.gz -C /data .
```

### Cleanup
```bash
# Stop and remove everything
./docker-setup.sh cleanup
```

## 🔒 Security Considerations

1. **API Keys**: Store in `.env` file, never commit to git
2. **Network**: Services communicate on isolated Docker network
3. **User Isolation**: Claudia runs as non-root user
4. **Volume Permissions**: Proper file permissions set
5. **Health Checks**: All services have health monitoring

## 🚨 Troubleshooting

### Common Issues

**1. "Docker not found"**
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

**2. "Permission denied on docker-setup.sh"**
```bash
chmod +x docker-setup.sh
```

**3. "Port already in use"**
```bash
# Check what's using the port
sudo lsof -i :80
# Or modify ports in docker-compose.yml
```

**4. "Build fails with out of memory"**
```bash
# Increase Docker memory limit
# Or build with fewer parallel jobs
docker compose build --parallel 1
```

**5. "VNC connection refused"**
```bash
# Check if Claudia container is running
docker compose ps
# Check logs
docker compose logs claudia
```

### Debug Commands

```bash
# Check service health
docker compose ps

# Enter container for debugging
docker compose exec claudia bash

# Check resource usage
docker stats

# View container details
docker compose logs --tail=100 claudia
```

## 🤝 Contributing

To contribute to the Docker setup:

1. **Test Changes**: Always test both development and production modes
2. **Document Changes**: Update this guide for any new features
3. **Security Review**: Ensure no secrets are exposed
4. **Performance**: Monitor resource usage of changes

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Tauri Docker Guide](https://tauri.app/guides/distribution/publishing/)
- [Nginx Configuration](https://nginx.org/en/docs/)

---

## ✅ Docker Binding Status: COMPLETE

The Docker containerization is now fully implemented and addresses all aspects of the "docker 绑定了没有" requirement:

- ✅ **Containerized Application**: Claudia runs in Docker
- ✅ **Multi-Service Setup**: Complete docker-compose configuration
- ✅ **Development Support**: Hot-reload development mode
- ✅ **Production Ready**: Optimized production deployment
- ✅ **Monitoring**: Optional Prometheus/Grafana setup
- ✅ **Documentation**: Complete setup and troubleshooting guide

The Docker binding is now complete and ready for use! 🎉
