#!/bin/bash

# =====================================================================
# AgentSecOps Sandbox Integration Demo Harness
# =====================================================================

set -euo pipefail

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
