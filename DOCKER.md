# Docker Deployment Guide for Claudia Ultimate Edition

This guide provides detailed instructions for deploying Claudia Ultimate Edition using Docker.

## 🚀 Quick Start

### Prerequisites
- Docker 20.10+ and Docker Compose 2.0+
- Git

### 1. Clone and Setup
```bash
git clone https://github.com/getAsterisk/claudia.git
cd claudia
chmod +x docker-setup.sh
```

### 2. Start Development Environment
```bash
# Using the setup script (recommended)
./docker-setup.sh dev

# Or using docker-compose directly
docker-compose --profile dev up
```

### 3. Access the Application
- **Frontend**: http://localhost:1420
- **HMR WebSocket**: ws://localhost:1421

## 📋 Available Commands

### Using the Setup Script
```bash
./docker-setup.sh dev        # Development environment
./docker-setup.sh web        # Web-only (React frontend)
./docker-setup.sh gui        # GUI development (Linux)
./docker-setup.sh build      # Build the application
./docker-setup.sh artifacts  # Extract build artifacts
./docker-setup.sh clean      # Clean Docker resources
./docker-setup.sh pull       # Pull latest images
./docker-setup.sh logs       # Show container logs
```

### Using Docker Compose Directly
```bash
# Development profiles
docker-compose --profile dev up        # Full development
docker-compose --profile web up        # Web-only development
docker-compose --profile gui up        # GUI development
docker-compose --profile build up      # Build application
docker-compose --profile artifacts up  # Extract artifacts
```

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the project root:

```env
# Development settings
NODE_ENV=development
TAURI_DEV_HOST=0.0.0.0

# Display settings (for GUI mode)
DISPLAY=:0

# Custom ports (optional)
VITE_PORT=1420
VITE_HMR_PORT=1421
```

### Docker Compose Profiles

- **dev**: Full development environment with Tauri and hot reload
- **web**: React frontend only for web development
- **gui**: GUI development with X11 forwarding (Linux)
- **build**: Production build environment
- **artifacts**: Extract build artifacts

## 🖥️ Platform-Specific Setup

### Linux (GUI Development)
```bash
# Enable X11 forwarding
xhost +local:docker
./docker-setup.sh gui
```

### macOS
```bash
# Install XQuartz for X11 support (optional)
brew install --cask xquartz

# Start development (web mode recommended)
./docker-setup.sh web
```

### Windows
```bash
# Use web mode (recommended)
./docker-setup.sh web

# Or install VcXsrv for X11 support
```

## 📦 Building and Distribution

### Build Production Binaries
```bash
# Build using Docker
./docker-setup.sh build

# Extract artifacts
./docker-setup.sh artifacts

# Artifacts will be in ./artifacts/ directory
```

### GitHub Actions Integration
The repository includes automated Docker builds:

- **Docker images**: Built on every push to main/develop
- **Multi-platform**: linux/amd64 and linux/arm64
- **Artifacts**: Binaries uploaded as GitHub artifacts
- **Releases**: Automatic releases for tagged versions

### Pre-built Images
```bash
# Pull from GitHub Container Registry
docker pull ghcr.io/rroqheo/claude:latest      # Production
docker pull ghcr.io/rroqheo/claude:dev-latest  # Development

# Run pre-built image
docker run -p 1420:1420 ghcr.io/rroqheo/claude:dev-latest
```

## 🔍 Troubleshooting

### Common Issues

1. **Port Already in Use**
   ```bash
   # Stop conflicting services
   docker-compose down
   # Or change ports in docker-compose.yml
   ```

2. **X11 Permission Denied (Linux)**
   ```bash
   # Enable X11 forwarding
   xhost +local:docker
   ```

3. **Build Failures**
   ```bash
   # Clean and rebuild
   ./docker-setup.sh clean
   ./docker-setup.sh build --force
   ```

4. **Out of Memory During Build**
   ```bash
   # Increase Docker memory limit
   # Or build with limited parallelism
   docker build --memory=4g .
   ```

### Logging and Debugging
```bash
# View container logs
./docker-setup.sh logs

# Debug specific service
docker-compose logs claudia-dev

# Interactive shell in container
docker-compose exec claudia-dev bash
```

## 🚀 Deployment to Production

### GitHub Container Registry
Images are automatically published to:
- `ghcr.io/rroqheo/claude:latest`
- `ghcr.io/rroqheo/claude:dev-latest`
- `ghcr.io/rroqheo/claude:v{version}`

### Custom Registry
```bash
# Build and tag for custom registry
docker build -t your-registry.com/claudia:latest .
docker push your-registry.com/claudia:latest
```

### Server Deployment
```bash
# Run on server (headless mode)
docker run -d \
  --name claudia-app \
  -p 8080:8080 \
  --restart unless-stopped \
  ghcr.io/rroqheo/claude:latest
```

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Tauri Documentation](https://tauri.app/v1/guides/)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Project Repository](https://github.com/getAsterisk/claudia)

## 💡 Tips

1. **Development Speed**: Use `--profile web` for faster frontend development
2. **Resource Usage**: GUI mode requires more resources due to X11
3. **Hot Reload**: Both `dev` and `web` profiles support hot reload
4. **Caching**: Docker build cache significantly speeds up rebuilds
5. **Artifacts**: Use the `artifacts` profile to extract binaries for distribution

For more help, open an issue in the [GitHub repository](https://github.com/getAsterisk/claudia/issues).