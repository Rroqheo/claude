#!/bin/bash

# Docker Setup Script for Claudia Ultimate Edition
# This script helps with easy Docker deployment and management

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}$1${NC}"
}

# Function to check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_status "Docker and Docker Compose are installed."
}

# Function to display help
show_help() {
    print_header "Claudia Ultimate Edition - Docker Setup"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  dev        Start development environment"
    echo "  web        Start web-only development (React frontend)"
    echo "  gui        Start GUI development (Linux with X11)"
    echo "  build      Build the application"
    echo "  artifacts  Extract build artifacts"
    echo "  clean      Clean up Docker containers and images"
    echo "  pull       Pull latest images from registry"
    echo "  logs       Show logs from running containers"
    echo "  help       Show this help message"
    echo ""
    echo "Options:"
    echo "  --detach   Run in detached mode (background)"
    echo "  --force    Force rebuild without cache"
    echo ""
    echo "Examples:"
    echo "  $0 dev              # Start development environment"
    echo "  $0 dev --detach     # Start in background"
    echo "  $0 build --force    # Force rebuild"
    echo "  $0 clean            # Clean up Docker resources"
}

# Function to start development environment
start_dev() {
    print_status "Starting Claudia development environment..."
    
    local args=""
    if [[ "$1" == "--detach" ]]; then
        args="-d"
    fi
    
    if [[ "$1" == "--force" || "$2" == "--force" ]]; then
        print_status "Forcing rebuild..."
        docker-compose --profile dev build --no-cache
    fi
    
    docker-compose --profile dev up $args
    
    if [[ "$1" == "--detach" ]]; then
        print_status "Development environment is running in background."
        print_status "Access the app at: http://localhost:1420"
        print_status "View logs with: $0 logs"
    fi
}

# Function to start web-only development
start_web() {
    print_status "Starting web-only development environment..."
    
    local args=""
    if [[ "$1" == "--detach" ]]; then
        args="-d"
    fi
    
    if [[ "$1" == "--force" || "$2" == "--force" ]]; then
        print_status "Forcing rebuild..."
        docker-compose --profile web build --no-cache
    fi
    
    docker-compose --profile web up $args
    
    if [[ "$1" == "--detach" ]]; then
        print_status "Web development environment is running in background."
        print_status "Access the app at: http://localhost:1420"
    fi
}

# Function to start GUI development
start_gui() {
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        print_warning "GUI mode is primarily designed for Linux systems."
        print_warning "You may need to set up X11 forwarding manually on other systems."
    fi
    
    print_status "Starting GUI development environment..."
    print_status "Enabling X11 forwarding..."
    
    # Enable X11 forwarding
    xhost +local:docker 2>/dev/null || print_warning "Could not enable X11 forwarding. GUI may not work."
    
    docker-compose --profile gui up
}

# Function to build the application
build_app() {
    print_status "Building Claudia Ultimate Edition..."
    
    if [[ "$1" == "--force" ]]; then
        print_status "Forcing rebuild..."
        docker-compose --profile build build --no-cache
    fi
    
    docker-compose --profile build up
    print_status "Build completed."
}

# Function to extract artifacts
extract_artifacts() {
    print_status "Extracting build artifacts..."
    
    # Create artifacts directory
    mkdir -p ./artifacts
    
    docker-compose --profile artifacts up
    
    if [[ -d "./artifacts" ]]; then
        print_status "Artifacts extracted to ./artifacts/"
        ls -la ./artifacts/
    else
        print_error "Failed to extract artifacts."
    fi
}

# Function to clean up Docker resources
clean_docker() {
    print_status "Cleaning up Docker resources for Claudia..."
    
    # Stop all containers
    docker-compose down --remove-orphans
    
    # Remove images
    docker images | grep claudia | awk '{print $3}' | xargs docker rmi -f 2>/dev/null || true
    
    # Prune unused resources
    docker system prune -f
    
    print_status "Cleanup completed."
}

# Function to pull latest images
pull_images() {
    print_status "Pulling latest images from GitHub Container Registry..."
    
    docker pull ghcr.io/rroqheo/claude:latest || print_warning "Could not pull latest image"
    docker pull ghcr.io/rroqheo/claude:dev-latest || print_warning "Could not pull dev image"
    
    print_status "Images updated."
}

# Function to show logs
show_logs() {
    print_status "Showing logs from running containers..."
    docker-compose logs -f
}

# Main script logic
case "${1:-help}" in
    "dev")
        check_docker
        start_dev "${@:2}"
        ;;
    "web")
        check_docker
        start_web "${@:2}"
        ;;
    "gui")
        check_docker
        start_gui "${@:2}"
        ;;
    "build")
        check_docker
        build_app "${@:2}"
        ;;
    "artifacts")
        check_docker
        extract_artifacts
        ;;
    "clean")
        check_docker
        clean_docker
        ;;
    "pull")
        check_docker
        pull_images
        ;;
    "logs")
        check_docker
        show_logs
        ;;
    "help"|*)
        show_help
        ;;
esac