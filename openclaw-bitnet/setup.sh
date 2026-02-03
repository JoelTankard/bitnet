#!/bin/bash
# OpenClaw + BitNet Setup Script
# This script sets up the Docker environment for running OpenClaw with BitNet

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "============================================"
echo "  OpenClaw + BitNet Setup"
echo "============================================"
echo ""

# Check for Docker
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed. Please install Docker first."
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check for Docker Compose
if ! docker compose version &> /dev/null; then
    echo "ERROR: Docker Compose is not available. Please install Docker Compose."
    echo "Visit: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "Docker and Docker Compose found."
echo ""

# Create necessary directories
echo "Creating directories..."
mkdir -p models config

# Check if config exists, if not copy default
if [ ! -f "config/openclaw.json" ]; then
    echo "Copying default OpenClaw configuration..."
    cp config/openclaw.json config/openclaw.json 2>/dev/null || true
fi

echo ""
echo "============================================"
echo "  Building Docker Images"
echo "============================================"
echo ""

# Build the images
docker compose build

echo ""
echo "============================================"
echo "  Setup Complete!"
echo "============================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Download a BitNet model:"
echo "   docker compose run --rm model-downloader bash -c \\"
echo "     'pip install huggingface_hub && \\"
echo "      huggingface-cli download microsoft/BitNet-b1.58-2B-4T-gguf \\"
echo "      --local-dir /models/BitNet-b1.58-2B-4T'"
echo ""
echo "2. Start the services:"
echo "   docker compose up -d"
echo ""
echo "3. Access OpenClaw:"
echo "   - Web interface: http://localhost:18789"
echo "   - API endpoint:  http://localhost:18789/api"
echo ""
echo "4. View logs:"
echo "   docker compose logs -f"
echo ""
echo "5. Stop services:"
echo "   docker compose down"
echo ""
echo "For more information, see README.md"
