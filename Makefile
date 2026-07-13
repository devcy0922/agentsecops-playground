.PHONY: build demo test benchmark chaos-test clean help

help:
	@echo "AgentSecOps Playground Makefile Commands:"
	@echo "  demo       - Start local container ecosystem (gateway, slicerag, mock-llm, fallback, prometheus, grafana)"
	@echo "  test       - Run integration verification script"
	@echo "  chaos-test - Run end-to-end integration and chaos fallback test"
	@echo "  benchmark  - Run wrk load tests against the security gateway"
	@echo "  clean      - Stop and remove all containers"

demo:
	docker compose down --remove-orphans
	docker compose up -d --build
	@echo "Waiting for services to boot..."
	@sleep 5

test:
	python3 tests/verify_demo.py

chaos-test: demo test

benchmark:
	@echo "Executing Aegis LLM Gateway Benchmark under Load..."
	@if command -v wrk > /dev/null; then \
		echo "=== Benchmarking Normal Path (No PII) ==="; \
		wrk -t4 -c50 -d10s -s tests/wrk_normal.lua http://localhost:28080/v1/chat/completions; \
	else \
		echo "Error: 'wrk' load testing tool is not installed."; \
		exit 1; \
	fi

clean:
	docker compose down -v --remove-orphans
