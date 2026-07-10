#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/compose/docker-compose.yml"
ENV_FILE="${ENV_FILE:-$PROJECT_ROOT/compose/env/.env.development}"

docker compose \
  --env-file "$ENV_FILE" \
  -f "$COMPOSE_FILE" \
  ps

echo
echo "Volumes:"
docker volume ls --filter "name=youmail_"

echo
echo "Rede:"
docker network ls --filter "name=youmail-internal"
