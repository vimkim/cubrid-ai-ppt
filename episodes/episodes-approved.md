# 에피소드 진정성 승인 목록 (Presenter Sign-off)

**발표자:** 김대현 (CUBRID AI TFT, 개발 2팀)
**승인일:** 2026-04-20
**승인 방식:** Deep Interview → Ralplan v2 플랜의 Phase 0 hard gate 통과
**상태:** ✅ **9/9 에피소드 진정성 확인 완료** — Phase 1 진입 허용

---

## Area 1: 대규모 코드베이스 탐색/이해

### HERO 1-1: `heap_file.c` 레코드 삽입 흐름 파악 ✅
- **실제 경험:** OOS 기능 개발 중 `heap_insert_logical` → `heap_insert_physical` 호출 체인을 Claude Code로 파악
- **Before:** grep + cscope/ctags로 15,000줄+ 파일에서 함수 체인 수동 추적
- **After:** Claude가 흐름 + 각 단계 역할 요약 제공
- **Demo:** 스크린샷/코드 스니펫으로 설명 (사전 녹화 없음)
- **Caveat:** (없음, success case)
- **Drill-down (발표 전 기입):**
  - 관련 PR: `TBD — 발표자 기입`
  - 관련 JIRA: `TBD — feat/oos 브랜치 작업`
  - 날짜: `TBD`

### MENTION 1-2 (교체됨): 에러 메시지 → 발생 코드 위치 추적 ✅
- **실제 경험:** CUBRID 에러 메시지/로그 텍스트를 Claude에 주고 "어디서 발생하는지" 물어 파일/함수 위치를 직접 지정받음
- **Before:** 에러 메시지 일부를 grep + msgcat 교차 참조로 수동 탐색
- **After:** Claude가 에러 발생 지점 후보를 몇 군데 지정 → 확인
- **Caveat:** 후보가 복수일 때 잘못된 걸 먼저 지정한 경우 있음 → 개발자 검증 필요
- **Demo:** 없음 (30~45초 bullet-point slide)
- **Drill-down (발표 전 기입):**
  - 예시 에러 메시지 1개: `TBD`

### MENTION 1-3 (교체됨): 다른 개발자의 PR 이해/리뷰 준비 ✅
- **실제 경험:** 동료 개발자 또는 GitHub PR을 Claude로 읽어 변경 범위/구조 파악
- **Before:** PR diff + 관련 커밋 로그 수동 독해, 컨텍스트 조립에 시간 소요
- **After:** Claude가 구조/변경 범위 요약 → 리뷰 준비 시간 단축
- **핵심 가치:** PR의 구조와 변경 범위를 빠르게 파악 — 리뷰 준비 시간 단축
- **Caveat:** AI 요약은 리뷰 시작점이지 결론이 아님. PR 작성자 의도는 작성자 본인에게 확인해야 함.
- **Demo:** 없음
- **Drill-down (발표 전 기입):**
  - 참고 PR 1~2개: `TBD`

---

## Area 2: 실제 개발 작업

### HERO 2-2: CI shell-test 실패 분석 및 수정 ✅
- **실제 경험:** PR merge 후 CI shell test 실패 로그를 Claude에 읽히고 분석 요청
- **Before:** CI 로그 다운로드, expected/actual diff, 로컬 재현 시도
- **After:** Claude가 실패 로그 + 테스트 스크립트 읽고 근본 원인 짚음
- **Demo:** 스크린샷/코드 스니펫으로 설명 (사전 녹화 없음)
- **Caveat:** (없음)
- **Drill-down (발표 전 기입):**
  - CI job URL: `TBD`
  - 실패했던 테스트명: `TBD`
  - 관련 PR: `TBD`

### MENTION 2-1: isolation test (.ctl) 작성 ✅
- **실제 경험:** 기존 `.ctl` 파일 패턴을 Claude가 학습하게 한 후 새 isolation 테스트 초안 받음
- **Before:** 기존 .ctl 복사 + 수동 수정, 시행착오
- **After:** 패턴 기반 초안 즉시 생성
- **Demo:** 없음
- **Drill-down (발표 전 기입):**
  - 작성한 .ctl 파일명: `TBD`

### MENTION 2-3: 헬퍼 함수 + 단위 테스트 동시 작성 ✅ (edge case 누락 경험 포함)
- **실제 경험:** 새 헬퍼 함수와 단위 테스트를 Claude가 함께 생성 → 직접 edge case 보완
- **Before:** 함수 → 빌드 → 테스트 수동 사이클
- **After:** 동시 생성
- **Caveat (강조):** Claude가 만든 테스트가 일부 edge case(NULL, empty, boundary)를 놓쳐 개발자가 직접 보완해야 했음 → "AI 출력은 초안" 원칙의 구체적 근거
- **Demo:** 없음
- **Drill-down (발표 전 기입):**
  - 함수명: `TBD`

---

## Area 3: 문서/커뮤니케이션

### HERO 3-1: OOS JIRA 이슈 / PR description 작성 ✅
- **실제 경험:** OOS 기능 관련 JIRA 이슈 작성 시 팀 컨벤션(한국어 본문 + 영어 섹션 헤더) 준수하며 Claude Code 활용
- **Before:** 기존 이슈 참고하며 수동 작성, 기술적 맥락 정리에 시간
- **After:** Claude에 변경 코드 범위 보여주고 이슈/PR description 초안 요청
- **Demo:** 스크린샷/코드 스니펫으로 설명 (사전 녹화 없음)
- **Caveat:** (없음)
- **Drill-down (발표 전 기입):**
  - JIRA 이슈 번호: `TBD (CBRD-XXXXX)`
  - PR 번호: `TBD`

### MENTION 3-2: Greptile 봇 리뷰 코멘트 일괄 응답 ✅
- **실제 경험:** GitHub PR의 Greptile bot 리뷰 코멘트들을 Claude로 일괄 응답
- **Before:** 코멘트당 개별 읽고 응답 작성
- **After:** 전체 응답 초안을 한 번에 받음
- **Demo:** 없음
- **Drill-down (발표 전 기입):**
  - 예시 PR: `TBD`

### MENTION 3-3: 조사 노트 → 내부 문서 변환 ✅ ("보충" 환각 사례 포함)
- **실제 경험:** 조사 메모를 Claude로 구조화된 내부 문서로 변환
- **Before:** 메모를 처음부터 재구조화
- **After:** Claude가 구조화된 초안 생성
- **Caveat (강조):** Claude가 원 메모에 없던 내용을 "보충"으로 추가한 경우 있음 → 발표자 팩트체크 필수. "문서화의 자동화는 확인의 자동화가 아니다"
- **Demo:** 없음
- **Drill-down (발표 전 기입):**
  - 변환 예시 1개: `TBD`

---

## 변경 내역 (v2 draft → approved)

| # | v2 Draft | Approved | 비고 |
|---|----------|----------|------|
| 1-1 | heap_file.c 흐름 | **동일** (유지) | Hero |
| 1-2 | JIRA + PR 체인 요약 | **교체** → 에러 메시지 → 코드 위치 추적 | 미경험 사례 제거 |
| 1-3 | MVCC/Vacuum 이해 | **교체** → 다른 개발자 PR 이해 | 미경험 사례 제거. 환각 annotation 유지 |
| 2-1 ~ 2-3 | 동일 | **동일** (유지) | 모두 실경험 확인 |
| 3-1 ~ 3-3 | 동일 | **동일** (유지) | 모두 실경험 확인 |

## Drill-down 정보 TBD 항목 (발표 전 기입 필수)

Phase 1 진입은 허용되지만, 아래 drill-down 정보는 **리허설(Phase 5) 전까지 발표자가 직접 기입해야 함**:
- Hero 1-1: PR/JIRA 번호, 날짜
- Hero 2-2: CI job URL, 실패 테스트명, PR 번호
- Hero 3-1: JIRA 번호, PR 번호
- 각 Mention: 예시 파일/코멘트/PR 최소 1개씩

**이유:** Q&A에서 "어느 PR이었어요?" 드릴다운이 나오면 구체 번호를 답할 수 있어야 함.
