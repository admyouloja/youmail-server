#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/compose/docker-compose.yml"
ENV_FILE="$PROJECT_ROOT/compose/env/.env.development"

if ! command -v docker >/dev/null 2>&1; then
  echo "Erro: Docker não está instalado ou não está disponível no PATH."
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "Erro: Docker Compose plugin não está disponível."
  exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Erro: arquivo $ENV_FILE não encontrado."
  exit 1
fi

docker compose \
  --env-file "$ENV_FILE" \
  -f "$COMPOSE_FILE" \
  config --quiet

echo "Configuração Docker Compose válida."
