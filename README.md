# AgentSecOps Playground

AgentSecOps Playground는 AI 에이전트 거버넌스 구성요소를 안전한 가상 데이터로
재현하는 통합 검증 하네스입니다. 실제 API Key, 고객 데이터, 사내 인프라에
연결하지 않습니다.

## 포함 범위

런타임 Compose 데모는 다음 세 서비스를 실행합니다.

- **AegisLLM**: Bearer API 키 인증, PII DLP, 프롬프트 정책, 감사 로그를 처리하는 LLM 게이트웨이
- **SliceRAG**: `project_id`별 논리 격리 검색을 수행하는 내부 RAG 서비스
- **Mock LLM**: 실제 모델 대신 요청 내용을 검증하기 위한 OpenAI 호환 Upstream

포트폴리오 생태계의 나머지 모듈은 별도 책임 경계에서 검증합니다.

- **Aperture-MCP**: MCP `tools/call` 정책 프록시
- **LeanDraft-Linter**: 설계 문서와 PR 계획의 복잡도를 검사하는 CLI·Web UI

전체 책임 경계와 향후 MCP 시나리오는 [architecture.md](architecture.md)에 설명합니다.

## 빠른 시작

개발용 Compose는 AegisLLM과 SliceRAG 저장소를 Playground의 형제 디렉터리에서
빌드합니다. 따라서 아래와 같이 저장소를 같은 부모 경로에 준비해야 합니다.

```text
devcy0922_port/
├── aegis-llm/
├── slicerag/
└── agentsecops-playground/
```

프로젝트 서버에서 실행합니다.

```bash
./run-demo.sh
```

기본 포트는 모두 localhost에만 바인딩됩니다.

| 서비스 | 기본 포트 | 재지정 변수 |
| --- | --- | --- |
| AegisLLM | `28080` | `AEGIS_HOST_PORT` |
| SliceRAG | `28095` | `SLICERAG_HOST_PORT` |
| Mock LLM | `28000` | `MOCK_LLM_HOST_PORT` |

## 자동 검증

`run-demo.sh`는 `datasets/`의 금융·HR 가상 문서를 수집한 뒤 다음을 단언합니다.

1. 정적 Bearer API 키 인증과 정상 모델 요청
2. 금융 프로젝트 RAG 검색 및 HR 프로젝트로의 교차 테넌트 누출 부재
3. 검색 결과가 AegisLLM의 Upstream 요청에 컨텍스트로 주입됨
4. 이메일과 유효한 가상 주민등록번호가 한국어 문맥에서도 마스킹됨
5. 알려진 프롬프트 인젝션이 `400 Bad Request`로 차단되고 Upstream으로 전달되지 않음

감사 로그는 `artifacts/aegis-logs/audit.jsonl`에 남습니다. 이 경로는 로컬 검증
산출물이며 커밋하지 않습니다.

## 제약과 다음 릴리스

- 현재 Compose는 로컬 개발 통합용입니다. `v0.1.0` 공개 릴리스에서는 각 모듈의
  고정 OCI 이미지 태그를 참조하는 단독 clone 실행 구성을 추가합니다.
- Aperture-MCP의 고위험 `tools/call` 차단 시나리오는 정책 결정 Mock과 함께 다음
  Playground 릴리스에서 Compose E2E에 포함합니다.
