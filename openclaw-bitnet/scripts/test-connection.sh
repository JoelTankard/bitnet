#!/bin/bash
# Test script to verify BitNet and OpenClaw are working
#
# Usage: ./test-connection.sh

set -e

BITNET_URL=${BITNET_URL:-"http://localhost:8080"}
OPENCLAW_URL=${OPENCLAW_URL:-"http://localhost:18789"}

echo "============================================"
echo "  OpenClaw + BitNet Connection Test"
echo "============================================"
echo ""

# Test BitNet server
echo "Testing BitNet server at $BITNET_URL..."
if curl -sf "$BITNET_URL/health" > /dev/null 2>&1; then
    echo "  [OK] BitNet server is healthy"
else
    echo "  [FAIL] BitNet server is not responding"
    echo "  Make sure the BitNet container is running:"
    echo "    docker compose ps"
    echo "    docker compose logs bitnet-server"
fi

echo ""

# Test BitNet models endpoint
echo "Testing BitNet models endpoint..."
MODELS=$(curl -sf "$BITNET_URL/v1/models" 2>/dev/null || echo "")
if [ -n "$MODELS" ]; then
    echo "  [OK] Models endpoint available"
    echo "  Response: $MODELS"
else
    echo "  [INFO] Models endpoint not available (this is normal for llama-server)"
fi

echo ""

# Test OpenClaw gateway
echo "Testing OpenClaw gateway at $OPENCLAW_URL..."
if curl -sf "$OPENCLAW_URL/health" > /dev/null 2>&1; then
    echo "  [OK] OpenClaw gateway is healthy"
else
    echo "  [FAIL] OpenClaw gateway is not responding"
    echo "  Make sure the OpenClaw container is running:"
    echo "    docker compose ps"
    echo "    docker compose logs openclaw"
fi

echo ""

# Test a simple completion (if BitNet is working)
echo "Testing BitNet completion..."
RESPONSE=$(curl -sf -X POST "$BITNET_URL/v1/completions" \
    -H "Content-Type: application/json" \
    -d '{"prompt": "Hello, I am", "max_tokens": 20}' 2>/dev/null || echo "")

if [ -n "$RESPONSE" ]; then
    echo "  [OK] BitNet completion working"
    echo "  Response: $RESPONSE"
else
    echo "  [SKIP] Could not test completion (server may still be loading)"
fi

echo ""
echo "============================================"
echo "  Test Complete"
echo "============================================"
