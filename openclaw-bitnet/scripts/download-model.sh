#!/bin/bash
# Download BitNet models for use with OpenClaw
#
# Usage:
#   ./download-model.sh [model-name]
#
# Available models:
#   - 2b (default): BitNet-b1.58-2B-4T (Official Microsoft model)
#   - large: bitnet_b1_58-large (0.7B, faster)
#   - 3b: bitnet_b1_58-3B (3.3B, more capable)
#   - llama3: Llama3-8B-1.58-100B-tokens (8B, most capable)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

MODEL=${1:-2b}

echo "============================================"
echo "  BitNet Model Downloader"
echo "============================================"
echo ""

case $MODEL in
    2b|2B|official)
        echo "Downloading: BitNet-b1.58-2B-4T (Official Microsoft 2B model)"
        REPO="microsoft/BitNet-b1.58-2B-4T-gguf"
        DIR="BitNet-b1.58-2B-4T"
        ;;
    large|0.7b|small)
        echo "Downloading: bitnet_b1_58-large (0.7B model)"
        REPO="1bitLLM/bitnet_b1_58-large"
        DIR="bitnet_b1_58-large"
        ;;
    3b|3B)
        echo "Downloading: bitnet_b1_58-3B (3.3B model)"
        REPO="1bitLLM/bitnet_b1_58-3B"
        DIR="bitnet_b1_58-3B"
        ;;
    llama3|8b|8B)
        echo "Downloading: Llama3-8B-1.58-100B-tokens (8B model)"
        REPO="HF1BitLLM/Llama3-8B-1.58-100B-tokens"
        DIR="Llama3-8B-1.58-100B-tokens"
        ;;
    *)
        echo "Unknown model: $MODEL"
        echo ""
        echo "Available models:"
        echo "  2b     - BitNet-b1.58-2B-4T (Official, recommended)"
        echo "  large  - bitnet_b1_58-large (0.7B, faster)"
        echo "  3b     - bitnet_b1_58-3B (3.3B)"
        echo "  llama3 - Llama3-8B-1.58-100B-tokens (8B)"
        exit 1
        ;;
esac

echo ""
echo "Repository: $REPO"
echo "Target: models/$DIR"
echo ""

# Use Docker to download (avoids needing local Python setup)
docker compose run --rm model-downloader bash -c "
    pip install -q huggingface_hub &&
    huggingface-cli download $REPO --local-dir /models/$DIR
"

echo ""
echo "============================================"
echo "  Download Complete!"
echo "============================================"
echo ""
echo "Model saved to: models/$DIR"
echo ""
echo "Update docker-compose.yml to use this model:"
echo "  BITNET_MODEL=/models/$DIR/ggml-model-i2_s.gguf"
echo ""
