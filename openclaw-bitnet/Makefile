# OpenClaw + BitNet Makefile
# Convenience commands for managing the Docker setup

.PHONY: setup build up down logs clean test help
.PHONY: download-model download-model-large download-model-3b download-model-llama3
.PHONY: use-2b use-large use-3b use-8b model restart
.PHONY: shell-bitnet shell-openclaw status rebuild

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
	@echo "  make clean          - Remove containers and volumes"
	@echo ""
	@echo "Model Switching (downloads if needed, then switches):"
	@echo "  make use-2b         - Use 2B model (default, fast)"
	@echo "  make use-large      - Use 0.7B model (fastest)"
	@echo "  make use-3b         - Use 3B model (balanced)"
	@echo "  make use-8b         - Use 8B model (best for tools)"
	@echo "  make model          - Show current model"
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

# ============================================
# Model Switching Commands
# ============================================

# Show current model
model:
	@./scripts/switch-model.sh

# Switch to 2B model (default)
use-2b: download-model
	@./scripts/switch-model.sh 2b
	@$(MAKE) restart

# Switch to 0.7B model (fastest)
use-large: download-model-large
	@./scripts/switch-model.sh large
	@$(MAKE) restart

# Switch to 3B model
use-3b: download-model-3b
	@./scripts/switch-model.sh 3b
	@$(MAKE) restart

# Switch to 8B model (best for tools)
use-8b: download-model-llama3
	@./scripts/switch-model.sh 8b
	@$(MAKE) restart

# Restart services (used after model switch)
restart:
	@echo "Restarting services with new model..."
	@docker compose down 2>/dev/null || true
	@docker compose up -d
	@echo ""
	@echo "Done! Services restarting with new model."
	@echo "View logs: make logs"
