#!/bin/bash

# =====================================================================
# AgentSecOps Sandbox Integration Demo Harness
# =====================================================================

set -euo pipefail

if [[ ! -f .env ]]; then
  echo ".env.example을 .env로 복사하고 각 자격증명을 난수로 설정하세요." >&2
  exit 1
fi

set -a
source .env
set +a

: "${PLAYGROUND_GATEWAY_API_KEY:?PLAYGROUND_GATEWAY_API_KEY를 설정하세요}"
: "${PLAYGROUND_UPSTREAM_API_KEY:?PLAYGROUND_UPSTREAM_API_KEY를 설정하세요}"
: "${PLAYGROUND_GRAFANA_ADMIN_PASSWORD:?PLAYGROUND_GRAFANA_ADMIN_PASSWORD를 설정하세요}"

echo "=== 1. Building and starting local containers ==="
docker compose down --remove-orphans
docker compose up -d --build

echo ""
echo "=== 2. Waiting for services to be ready ==="
echo ""
echo "=== 3. Running end-to-end assertions ==="
python3 tests/verify_demo.py

echo ""
echo "=== 4. Demo Complete ==="
echo "감사 로그는 ./artifacts/aegis-logs/audit.jsonl 에 저장됩니다."
