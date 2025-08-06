# Multi-stage Dockerfile for building Claudia Ultimate Edition
# This builds the Tauri application and extracts the binaries

# Build stage
FROM ubuntu:22.04 AS builder

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    build-essential \
    file \
    libssl-dev \
    libgtk-3-dev \
    libayatana-appindicator3-dev \
    libwebkit2gtk-4.1-dev \
    librsvg2-dev \
    patchelf \
    libxdo-dev \
    libsoup-3.0-dev \
    libjavascriptcoregtk-4.1-dev \
    git \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

# Set working directory
WORKDIR /app

# Copy package files first for better layer caching
COPY package.json package-lock.json bun.lock* ./
COPY src-tauri/Cargo.toml src-tauri/Cargo.lock* src-tauri/

# Install frontend dependencies
RUN bun install

# Install Rust dependencies
WORKDIR /app/src-tauri
RUN cargo fetch
WORKDIR /app

# Copy source code
COPY . .

# Build the application
RUN bun run build
RUN bun run tauri build

# Runtime stage for the built application
FROM ubuntu:22.04 AS runtime

# Install runtime dependencies for the Tauri app
RUN apt-get update && apt-get install -y \
    libwebkit2gtk-4.1-0 \
    libgtk-3-0 \
    libayatana-appindicator3-1 \
    librsvg2-2 \
    libssl3 \
    libsoup-3.0-0 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/src-tauri/target/release/claudia /app/claudia

# Copy any additional assets needed
COPY --from=builder /app/src-tauri/target/release/bundle/deb/*.deb /app/packages/
COPY --from=builder /app/src-tauri/target/release/bundle/appimage/*.AppImage /app/packages/

# Create a non-root user
RUN useradd -r -s /bin/false claudia

# Make binary executable
RUN chmod +x /app/claudia

# Expose any necessary ports (if running in server mode)
EXPOSE 8080

# Default command - note: GUI apps need special handling in containers
CMD ["/app/claudia"]

# Artifacts stage - for extracting build artifacts
FROM scratch AS artifacts
COPY --from=builder /app/src-tauri/target/release/claudia /claudia
COPY --from=builder /app/src-tauri/target/release/bundle/ /bundle/