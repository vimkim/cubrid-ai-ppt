# Q&A 드릴다운 카드

발표 중 "그 PR 번호가 뭐였어요?" 류 질문이 들어올 때 빠르게 참조할 수 있도록 **발표자 개인 노트** (청중에게 보여주지 않음).

> 발표 전 `TBD` 항목을 실제 번호로 채워주세요.

---

## Hero 1-1: heap_file.c 레코드 삽입 흐름

- **JIRA:** `TBD`
- **PR:** `TBD`
- **날짜:** `TBD`
- **핵심 함수 체인:** `heap_insert_logical` → `heap_insert_internal` → `heap_insert_physical`
- **받은 Claude 답변 요점:** (TBD — 실제 세션 요약 1~2줄)

## Hero 2-2: CI shell-test 실패 분석

- **CI job URL:** `TBD`
- **실패 테스트명:** `TBD`
- **PR:** `TBD`
- **원인 카테고리:** `TBD` (예: 환경 변수 누락 / expected 파일 업데이트 미반영 / 등)
- **Claude가 지적한 부분:** `TBD`

## Hero 3-1: JIRA 이슈 / PR description 작성

- **JIRA 번호:** `TBD (CBRD-XXXXX)`
- **PR 번호:** `TBD`
- **문서 컨벤션:** 한국어 본문 + 영어 섹션 헤더 (##)
- **주로 활용한 프롬프트:** `TBD` (예: "feat/oos 브랜치 현재 diff 기반으로 JIRA 이슈 작성해줘")

---

## Mention 1-2: 에러 메시지 추적

- **예시 에러:** `TBD`
- **지정받은 파일:** `TBD`

## Mention 1-3: 다른 개발자 PR 이해 (환각 주의)

- **참고 PR:** `TBD`
- **환각 사례:** `TBD` (Claude가 잘못 짚은 변경 의도 1문장)

## Mention 2-1: isolation test (.ctl) 작성

- **작성한 .ctl:** `TBD`

## Mention 2-3: 헬퍼 함수 + 테스트 (edge case 누락)

- **함수명:** `TBD`
- **누락된 edge case:** `TBD` (예: NULL 인자 / 빈 문자열 / 경계값 등)

## Mention 3-2: Greptile 응답

- **예시 PR:** `TBD`

## Mention 3-3: 노트 → 문서 (보충 환각)

- **변환 예시:** `TBD`
- **보충된 내용:** `TBD`
