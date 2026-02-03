#!/bin/bash
set -e

echo "Starting OpenClaw Gateway..."
echo "BitNet API URL: ${BITNET_API_URL}"
echo "Config Directory: ${OPENCLAW_CONFIG_DIR}"

# Wait for BitNet server to be ready
echo "Waiting for BitNet server..."
MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -sf "${BITNET_API_URL}/health" > /dev/null 2>&1; then
        echo "BitNet server is ready!"
        break
    fi
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "Attempt $RETRY_COUNT/$MAX_RETRIES - BitNet server not ready, waiting..."
    sleep 2
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "WARNING: BitNet server may not be ready, proceeding anyway..."
fi

# Update config with environment variables
if [ -f "${OPENCLAW_CONFIG_DIR}/openclaw.json" ]; then
    # Use node to update the config with the correct BitNet URL
    node -e "
        const fs = require('fs');
        const configPath = '${OPENCLAW_CONFIG_DIR}/openclaw.json';
        const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

        // Ensure providers section exists
        config.providers = config.providers || {};
        config.providers.bitnet = config.providers.bitnet || {};
        config.providers.bitnet.baseUrl = '${BITNET_API_URL}';

        fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
        console.log('Configuration updated with BitNet URL');
    "
fi

# Start OpenClaw gateway
exec openclaw gateway \
    --port 18789 \
    --verbose
