# AgentSecOps Playground

본 저장소는 B2B AI 에이전트 거버넌스 및 보안 인프라의 핵심 모듈들이 상호작용하는 모습을 외부 API Key나 실 vLLM GPU 서버 없이도 로컬에서 단번에 검증할 수 있도록 지원하는 통합 데모 샌드박스입니다.

## 포함된 컴포넌트

1. **AegisLLM** (`aegis-llm`): Rust로 구축된 실시간 API 인증 및 PII DLP 비식별화 게이트웨이.
2. **SliceRAG** (`slicerag`): Python으로 구현된 테넌트 네임스페이스 격리형 RAG 스토어.
3. **Mock LLM** (`mock-llm`): 로컬 샌드박스 동작을 위해 OpenAI Chat Completion API 스펙을 모킹하는 고속 가상 LLM Upstream.

## 빠른 시작

단 하나의 실행 스크립트를 사용하여 전체 환경을 빌드하고 시뮬레이션 테스트를 구동할 수 있습니다.

```bash
./run-demo.sh
```

## 검증되는 시황 시나리오 목록

시뮬레이션 스크립트는 다음 흐름을 순차적으로 수행하고 검증합니다:
1. **시나리오 1 (정상 API 인증)**: `Bearer aegis-demo-admin`을 활용해 게이트웨이 인증을 통과하고 가상 LLM의 응답을 성공적으로 수신하는 흐름 검증.
2. **시나리오 2 (DLP 개인정보 마스킹)**: 본문에 포함된 이메일 정보가 게이트웨이 보안 필터를 거쳐 `[REDACTED_EMAIL]`로 비식별화되어 안전하게 전송되는지 확인.
3. **시나리오 3 (Jailbreak 인젝션 차단)**: 시스템 우회 등 위험한 프롬프트 인젝션 명령 인입 시 API 게이트웨이 레벨에서 감지하여 요청을 즉시 거절(`400 Bad Request`)하는 흐름 시연.
