# OpenClaw + BitNet Makefile
# Convenience commands for managing the Docker setup

.PHONY: setup build up down logs clean test download-model help

# Default target
help:
	@echo "OpenClaw + BitNet - Available Commands"
	@echo ""
	@echo "  make setup          - Run initial setup"
	@echo "  make build          - Build Docker images"
	@echo "  make up             - Start all services"
	@echo "  make down           - Stop all services"
	@echo "  make logs           - View logs (follow mode)"
	@echo "  make test           - Test connections"
	@echo "  make download-model - Download default BitNet model"
	@echo "  make clean          - Remove containers and volumes"
	@echo ""
	@echo "  make shell-bitnet   - Open shell in BitNet container"
	@echo "  make shell-openclaw - Open shell in OpenClaw container"
	@echo ""

# Initial setup
setup:
	./setup.sh

# Build Docker images
build:
	docker compose build

# Start services
up:
	docker compose up -d
	@echo ""
	@echo "Services started!"
	@echo "  OpenClaw: http://localhost:18789"
	@echo ""
	@echo "View logs with: make logs"

# Stop services
down:
	docker compose down

# View logs
logs:
	docker compose logs -f

# Test connections
test:
	./scripts/test-connection.sh

# Download the default BitNet model
download-model:
	./scripts/download-model.sh 2b

# Download specific models
download-model-large:
	./scripts/download-model.sh large

download-model-3b:
	./scripts/download-model.sh 3b

download-model-llama3:
	./scripts/download-model.sh llama3

# Clean up everything
clean:
	docker compose down -v --remove-orphans
	@echo "Containers and volumes removed."

# Open shell in containers
shell-bitnet:
	docker compose exec bitnet-server bash

shell-openclaw:
	docker compose exec openclaw bash

# Rebuild and restart
rebuild: down build up

# Show status
status:
	docker compose ps
