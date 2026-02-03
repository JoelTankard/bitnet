# OpenClaw + BitNet Integration

Run [OpenClaw](https://github.com/openclaw/openclaw) with [BitNet](https://github.com/microsoft/BitNet) as the LLM backend - all in isolated Docker containers.

BitNet is Microsoft's 1-bit LLM inference framework that achieves fast, efficient inference with dramatically reduced energy consumption. This integration lets you use BitNet's efficient 1.58-bit models as the brain for your OpenClaw personal AI assistant.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Docker Network                        │
│  ┌─────────────────┐        ┌─────────────────────────┐ │
│  │   OpenClaw      │        │    BitNet Server        │ │
│  │   Gateway       │◄──────►│    (llama-server)       │ │
│  │   Port 18789    │  API   │    Port 8080            │ │
│  └────────┬────────┘        └─────────────────────────┘ │
│           │                                              │
└───────────┼──────────────────────────────────────────────┘
            │
    ┌───────▼───────┐
    │  Messaging    │
    │  Platforms    │
    │  (WhatsApp,   │
    │   Telegram,   │
    │   etc.)       │
    └───────────────┘
```

## Features

- **Isolated Execution**: Both OpenClaw and BitNet run in separate Docker containers
- **Efficient Inference**: BitNet's 1.58-bit models use minimal resources
- **OpenAI-Compatible API**: BitNet server exposes a llama.cpp server with OpenAI-compatible endpoints
- **Full OpenClaw Support**: All OpenClaw features work with BitNet as the backend

## Prerequisites

- Docker & Docker Compose
- At least 8GB RAM (16GB recommended for larger models)
- ~10GB disk space for models

## Quick Start

### 1. Clone and setup

```bash
cd openclaw-bitnet
./setup.sh
```

### 2. Download a BitNet model

```bash
# Download the official 2B model (recommended for most users)
docker compose run --rm bitnet-server \
  huggingface-cli download microsoft/BitNet-b1.58-2B-4T-gguf \
  --local-dir /models/BitNet-b1.58-2B-4T
```

### 3. Start the services

```bash
docker compose up -d
```

### 4. Access OpenClaw

Open http://localhost:18789 for the OpenClaw web interface, or connect your messaging platforms.

## Configuration

### BitNet Model Selection

Edit `docker-compose.yml` to change the model:

```yaml
services:
  bitnet-server:
    environment:
      - BITNET_MODEL=/models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf
```

Available models:
- `BitNet-b1.58-2B-4T` - Official 2B model (recommended)
- `bitnet_b1_58-large` - 0.7B model (faster, less capable)
- `bitnet_b1_58-3B` - 3.3B model (more capable, slower)
- `Llama3-8B-1.58-100B-tokens` - 8B model (most capable, requires more RAM)

### OpenClaw Configuration

Edit `config/openclaw.json`:

```json
{
  "agent": {
    "model": "bitnet/bitnet-b1.58-2b"
  },
  "providers": {
    "bitnet": {
      "baseUrl": "http://bitnet-server:8080",
      "apiKey": "not-required"
    }
  }
}
```

## Commands

```bash
# Start services
docker compose up -d

# View logs
docker compose logs -f

# Stop services
docker compose down

# Rebuild after changes
docker compose build --no-cache

# Run OpenClaw CLI commands
docker compose exec openclaw openclaw agent --message "Hello!"

# Check BitNet server health
curl http://localhost:8080/health
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `BITNET_MODEL` | `/models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf` | Path to model file |
| `BITNET_THREADS` | `4` | Number of CPU threads |
| `BITNET_CTX_SIZE` | `4096` | Context window size |
| `BITNET_PORT` | `8080` | Server port |
| `OPENCLAW_PORT` | `18789` | OpenClaw gateway port |

## Security Notes

- The containers run in an isolated Docker network
- BitNet server is only accessible from within the Docker network
- OpenClaw gateway is exposed on localhost only by default
- No credentials are stored in images - use Docker secrets or environment files

## Troubleshooting

### BitNet server won't start
- Check if the model file exists: `docker compose exec bitnet-server ls -la /models/`
- Ensure enough RAM is available
- Check logs: `docker compose logs bitnet-server`

### OpenClaw can't connect to BitNet
- Verify BitNet is healthy: `docker compose exec openclaw curl http://bitnet-server:8080/health`
- Check network connectivity: `docker compose exec openclaw ping bitnet-server`

### Slow inference
- Increase `BITNET_THREADS` (but don't exceed CPU cores)
- Use a smaller model
- Enable embedding quantization in model setup

## License

This integration is provided under MIT license. BitNet and OpenClaw have their own respective licenses.
