#!/bin/bash
set -e

echo "Starting BitNet Inference Server..."
echo "Model: ${BITNET_MODEL}"
echo "Threads: ${BITNET_THREADS}"
echo "Context Size: ${BITNET_CTX_SIZE}"
echo "Port: ${BITNET_PORT}"

# Check if model exists
if [ ! -f "${BITNET_MODEL}" ]; then
    echo "ERROR: Model file not found at ${BITNET_MODEL}"
    echo "Please mount your model directory to /models"
    echo ""
    echo "Available files in /models:"
    ls -la /models/ 2>/dev/null || echo "  (directory empty or not mounted)"
    exit 1
fi

# Start the inference server
exec python3 /bitnet/run_inference_server.py \
    --model "${BITNET_MODEL}" \
    --threads "${BITNET_THREADS}" \
    --ctx-size "${BITNET_CTX_SIZE}" \
    --port "${BITNET_PORT}" \
    --host "${BITNET_HOST}"
