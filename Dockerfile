# Multi-stage Docker build for Claudia - Multi-AI Desktop Application
FROM node:20-bullseye as frontend-builder

# Install system dependencies for building
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Bun package manager
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:$PATH"

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json bun.lock ./

# Install dependencies
RUN bun install --frozen-lockfile

# Copy source code
COPY . .

# Build the frontend
RUN bun run build

# Rust backend stage
FROM rust:1.75-bullseye as backend-builder

# Install system dependencies for Tauri
RUN apt-get update && apt-get install -y \
    libwebkit2gtk-4.1-dev \
    libgtk-3-dev \
    libayatana-appindicator3-dev \
    librsvg2-dev \
    patchelf \
    build-essential \
    curl \
    wget \
    file \
    libssl-dev \
    libxdo-dev \
    libsoup-3.0-dev \
    libjavascriptcoregtk-4.1-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy Cargo files
COPY src-tauri/Cargo.toml src-tauri/Cargo.lock ./src-tauri/

# Copy the built frontend from previous stage
COPY --from=frontend-builder /app/dist ./dist

# Copy Tauri source and configuration
COPY src-tauri ./src-tauri
COPY tauri.conf.json ./

# Build Tauri application
RUN cd src-tauri && cargo build --release

# Final runtime stage
FROM debian:bullseye-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libwebkit2gtk-4.1-0 \
    libgtk-3-0 \
    libayatana-appindicator3-1 \
    librsvg2-2 \
    ca-certificates \
    curl \
    git \
    xvfb \
    x11vnc \
    fluxbox \
    && rm -rf /var/lib/apt/lists/*

# Create a user for running the app
RUN useradd -m -s /bin/bash claudia

# Copy the built application
COPY --from=backend-builder /app/src-tauri/target/release/claudia /usr/local/bin/claudia
COPY --from=frontend-builder /app/dist /opt/claudia/dist

# Set up environment
ENV DISPLAY=:99
ENV CLAUDE_DIR=/home/claudia/.claude

# Create necessary directories
RUN mkdir -p /home/claudia/.claude && \
    chown -R claudia:claudia /home/claudia

# Switch to claudia user
USER claudia
WORKDIR /home/claudia

# Create startup script
RUN echo '#!/bin/bash\n\
# Start virtual display\n\
Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &\n\
sleep 2\n\
\n\
# Start window manager\n\
fluxbox > /dev/null 2>&1 &\n\
\n\
# Start VNC server (optional, for remote access)\n\
x11vnc -display :99 -nopw -listen localhost -xkb -rfbport 5900 -bg\n\
\n\
# Start Claudia application\n\
exec /usr/local/bin/claudia' > /home/claudia/start.sh && \
    chmod +x /home/claudia/start.sh

# Expose VNC port for optional remote access
EXPOSE 5900

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD pgrep -f claudia > /dev/null || exit 1

# Default command
CMD ["/home/claudia/start.sh"]