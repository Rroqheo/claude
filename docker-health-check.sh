#!/bin/bash

# Docker Health Check Script for Claudia
# This script verifies that Docker binding is working correctly

echo "🏥 Claudia Docker Health Check"
echo "================================"

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success_count=0
total_checks=0

check_service() {
    local service_name="$1"
    local check_command="$2"
    local expected_status="$3"
    
    total_checks=$((total_checks + 1))
    
    echo -n "Checking $service_name... "
    
    if eval "$check_command" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ HEALTHY${NC}"
        success_count=$((success_count + 1))
    else
        echo -e "${RED}❌ UNHEALTHY${NC}"
        echo "   Command: $check_command"
    fi
}

check_port() {
    local service_name="$1"
    local port="$2"
    
    total_checks=$((total_checks + 1))
    
    echo -n "Checking $service_name (port $port)... "
    
    if nc -z localhost "$port" 2>/dev/null; then
        echo -e "${GREEN}✅ ACCESSIBLE${NC}"
        success_count=$((success_count + 1))
    else
        echo -e "${RED}❌ NOT ACCESSIBLE${NC}"
    fi
}

echo "Checking Docker services..."
echo ""

# Check if Docker is running
check_service "Docker daemon" "docker info" "running"

# Check if Docker Compose is available
check_service "Docker Compose" "docker compose version || docker-compose version" "available"

# Check container status
if docker compose ps >/dev/null 2>&1; then
    containers=$(docker compose ps --services)
    for container in $containers; do
        check_service "Container: $container" "docker compose ps $container | grep -q 'Up'"
    done
fi

echo ""
echo "Checking service accessibility..."

# Check service ports
check_port "Nginx Proxy" 80
check_port "VNC Access" 5900
check_port "Ollama API" 11434
check_port "Redis" 6379
check_port "PostgreSQL" 5432

# Optional monitoring services
if docker compose ps prometheus >/dev/null 2>&1; then
    check_port "Prometheus" 9090
fi

if docker compose ps grafana >/dev/null 2>&1; then
    check_port "Grafana" 3000
fi

echo ""
echo "Checking API endpoints..."

# Check HTTP endpoints
check_service "Nginx health" "curl -s http://localhost/health | grep -q 'OK'"
check_service "Ollama API" "curl -sf http://localhost:11434/api/tags -o /dev/null"

echo ""
echo "================================"
echo "Health Check Summary:"
echo "  ✅ Passed: $success_count/$total_checks checks"

if [ $success_count -eq $total_checks ]; then
    echo -e "  ${GREEN}🎉 ALL SYSTEMS HEALTHY!${NC}"
    echo "  🐳 Docker binding is working perfectly!"
    exit 0
elif [ $success_count -gt $((total_checks / 2)) ]; then
    echo -e "  ${YELLOW}⚠️  PARTIALLY HEALTHY${NC}"
    echo "  🔧 Some services need attention"
    exit 1
else
    echo -e "  ${RED}💥 SYSTEM UNHEALTHY${NC}"
    echo "  🚨 Multiple services are down"
    exit 2
fi