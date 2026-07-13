# AgentSecOps Playground 아키텍처

## 목적

이 저장소는 AegisLLM, SliceRAG, Aperture-MCP, LeanDraft-Linter의 책임 경계를
포트폴리오용 안전한 데이터셋으로 재현하고 검증하는 통합 데모 하네스다. 실제
LLM, 고객 데이터, 사내 네트워크 자격 증명은 사용하지 않는다.

## 실행 경계

```mermaid
flowchart LR
    C["Demo 검증 스크립트"] --> G["AegisLLM\nLLM 요청 인증·DLP·정책"]
    G --> R["SliceRAG\nproject_id 범위 검색"]
    G --> U["Mock LLM\n검증용 Upstream"]
    C --> M["Aperture-MCP\ntools/call 정책 차단"]
    M --> T["Mock MCP Server\n안전한 도구 대상"]
    L["LeanDraft-Linter"] --> D["architecture.md·데모 설계 검사"]
```

## 데모 데이터셋

- `aegis-demo-finance`와 `aegis-demo-hr` 프로젝트에 서로 다른 가상 정책 문서를
  수집한다.
- 문서에는 `example.com` 도메인과 가상 식별자만 사용한다.
- 검색 검증은 금융 프로젝트 질의가 HR 프로젝트의 문맥을 반환하지 않는지까지
  단언한다.

## 검증 시나리오

1. 정적 Bearer API 키 인증을 거친 정상 LLM 요청
2. 이메일·가상 식별자 DLP 마스킹 후 Upstream 전달 확인
3. 알려진 프롬프트 인젝션 패턴의 게이트웨이 차단과 Upstream 미호출 확인
4. 데이터셋 ingest 후 프로젝트 범위 RAG 검색 및 교차 테넌트 격리 확인
5. 고위험 MCP `tools/call`의 Aperture-MCP 차단 확인
6. LeanDraft-Linter가 이 문서를 검사하는 CI 단계

## 재현성 원칙

- Playground 단독 clone 후 동작하도록 데모 전용 Mock 서비스와 데이터셋을 저장소
  안에 둔다.
- 다른 모듈은 고정된 OCI 이미지 태그로 참조하며, 개발 모드에서만 명시적으로
  로컬 소스 빌드를 선택할 수 있게 한다.
- 검증 스크립트는 HTTP 상태, 응답 본문, Upstream 수신 기록을 모두 단언하고
  실패 시 0이 아닌 종료 코드로 끝난다.
