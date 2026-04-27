---
marp: true
theme: bookk
paginate: true
size: 16:9
---

<!-- _class: lead -->

# CUBRID with Claude Max

**Claude Code Max 2개월 적용 사례 — 성공·실패담**

<br>

김대현 · 개발 2팀 & AI TFT · 2026-04-29

<!-- timing: 10 -->

---

# 발표자 소개

- **김대현** · 개발 2팀 & AI TFT
- **2개월간 매일 사용** — Claude Code Max 20x (Opus 4.7 1M Context)
- 보조: OpenAI Codex, Grok
- **참여 중인 스터디**
  - Claude Code 플러그인 개발 스터디
  - 고독한 토큰털이 스터디 (토큰 100% 소모 인증)
- **돈과 시간을 들여 2개월 이상 직접 부딪혀 본** 사용자의 관점에서 공유
<!-- timing: 30 -->

---

# 발표 목적

## 오늘 공유할 것

- **성공 사례** — 2개월간 실제로 자동화된 업무
- **실패 사례 + 그 이유** — 무엇이, 왜 안 되는가
- **성공시키려면 무엇이 필요한가** (Vision)

<!-- timing: 45 -->

---

# 발표하게 된 배경

- 써보니 **Claude Code Max + Opus 4.7 (1M Context)** 의 성능이 예상보다 좋다
- 많은 잡무를 자동화할 수 있어 **2개월간의 시행착오를 동료 개발자들에게 공유**하고 싶음

<!-- timing: 25 -->

---

# 발표의 빠른 결론

## Pros

- 개발팀 반복 업무의 **큰 비중을 부분 자동화 가능** — 단, 검증·디렉션은 사람 몫

## Cons

- 생산성은 **경험 혹은 경력**에 비례할 것이다 - AI가 사용자에게 끊임없이 디렉션을 요구하기 때문
- 고급 업무를 위해서는 팀 단위로 **Knowledge Base** 구축이 필요하다
- 체감 상 Claude Max Opus 4.7 1M 한정 - (16만원 이상 😢😢)

---

# 발표의 범위와 한계

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2em; text-align: left;">

<div>

**다룰 것**

- R&D 업무 **부분 자동화** 경험 (성공 + 실패 + 이유)
- Claude Max (Opus 4.7 1M) 환경 한정
- 초심자 진입 가이드 + 주의사항

</div>

<div>

**다루지 않는 것**

- AI 만능 / N배 생산성 주장 ❌
- 타사 AI 비교·평가 ❌
- 본부 단위 도입 방안 ❌

</div>

</div>

> AI Agent 시장은 매주 변동 — **이번 주의 모델·플랜이 다음 주에 바뀔 수 있음.** 모델 이름보다 **워크플로 패턴**에 주목해 주십시오.

<!-- timing: 50 -->

---

# Claude Code란? (1분 개요)

**모르시는 분을 위한 최소 맥락**

- 터미널 기반 AI 코딩 어시스턴트 — IDE 플러그인이 아닌 CLI 도구
- Anthropic이 만든 제품 (Claude 모델 기반)
- **Max 플랜** = 월정액으로 높은 사용량 한도 제공
- 파일 읽기 · 쓰기 · 명령 실행까지 수행 — 단순 자동완성이 아닌 agentic 도구

<br>

```
[ Claude 모델 ] ←→ [ 로컬 파일 접근 ] + [ 도구 실행 (shell, read, write) ]
```
<!-- timing: 50 -->

---

# Claude Code 는 그냥 "챗봇" 이 아니다 — 강력한 Agent Harness

**Harness = 모델을 둘러싼 도구·메모리·실행 환경의 총합**

- **파일 시스템 직접 조작** — Read / Write / Edit / Glob / Grep 으로 코드베이스 자유 탐색
- **임의 명령 실행** — Bash 도구로 빌드·테스트·git·gh·jq 등 CLI 전부 호출 가능
- **장기 실행 / 백그라운드** — 빌드·테스트를 백그라운드로 돌리고 결과만 가져오는 패턴
- **MCP (Model Context Protocol)** — clangd LSP, GitHub, JIRA, DB 등 외부 시스템 표준 연결
- **Skill / Slash command / Plugin** — 반복 워크플로를 재사용 단위로 굳혀 호출
- **Sub-agent / Team** — 여러 agent 가 병렬·계층적으로 협업 (architect, executor, reviewer 등)
- **Hook / Auto-memory** — 작업 전후 자동 점검·학습, 세션 간 컨텍스트 유지

> 단순 자동완성·코드 제안 도구와는 **완전히 다른 카테고리** — "사람처럼 일하는 환경" 이 핵심

<!-- timing: 75 -->

---

# Claude Code × CUBRID — 진짜 개발자처럼 일한다

**Claude 가 CUBRID repo 에서 실제로 할 수 있는 일들**

- **빌드** — `cmake` / `make` 호출, 에러 로그 분석, 의존성 자동 설치
- **DB 인스턴스 운영** — `cubrid server start/stop`, demodb 준비, csql 실행
- **SQL / 예제 실행** — 테스트 시나리오를 직접 굴려보며 가설 검증
- **clangd LSP 호출** — 함수 정의·참조·호출 계층을 코드 전체에서 자동 추적
- **shell-test 디버깅** — expected/actual diff 분석, 실패 원인 자동 정리
- **GDB attach + coredump 분석** — 스택 트레이스 읽고 해석, 함수별 의심 지점 좁히기
- **Valgrind / sanitizer 결과 해석** — 메모리 leak·undefined behavior 진단
- **CI 로그 가져오기** — `gh run view` 로 실패 워크플로 직접 fetch 후 분석

> "**코드 reading**" 만 하는 도구가 아니라 **"빌드·실행·관찰·디버깅"** 전 영역을 사람과 같은 방식으로 다룸
<!-- timing: 80 -->

---

# 왜 Claude Max + Opus 4.7 (1M Context) 인가

**본 발표 사례는 모두 이 환경에서 측정됨**

- **Pro / Sonnet** — CUBRID 함수 재사용 못 함, 불필요 코드 양산, 짧은 대화에서도 토큰 고갈
- **Max + Opus 1M Context** (Pro 에서는 사용 불가)
  - 코드베이스 전반 자동 탐색 + 긴 대화에서 흐름 유지
  - 아키텍팅 능력 탁월 — 부분 패치보다 설계 수준 접근을 먼저 제안
  - 주변 코드 패턴 유지 → **수정량 적음**, 리뷰 부담 감소

> 이 환경 미만에서는 본 발표 사례가 **그대로 재현되지 않을 수 있음**

<!-- timing: 90 -->

---

# 자동화 성공 사례 (오늘 다룰 것들)

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5em; text-align: left; font-size: 0.88em;">

<div>

**코드베이스 탐색**

- 15,000줄 `heap_file.c` 호출 체인 자동 파악
- "vector type 어디에 추가?" 즉답
- 에러 메시지 → 코드 위치 추적
- 다른 개발자 PR 변경 범위 요약

**실제 개발 작업**

- CI shell-test 실패 근본 원인 분석
- isolation test (.ctl) 초안 즉시 생성
- 5시간 자율: vector type · DDL · DML 재구현
- Coredump 디버깅 자동화 루프

</div>

<div>

**문서 / 커뮤니케이션**

- JIRA 이슈 / PR description 자동 작성
- Greptile 봇 리뷰 일괄 응답
- PR 리뷰 코멘트 응답 보조
- **이 발표 자료 자체** — Claude Code 와의 대화로 생성

**메타 워크플로**

- Skill 자동 생성 루프 (`/learner` → `/skill-creator`)
- 자동화 자체를 자동화 — 시행착오를 자산으로

</div>

</div>

<!-- timing: 40 -->

---

# Part 1: 코드베이스 탐색, 분석 보조

**15,000줄의 `heap_file.c` 안에서 길찾기**

<!-- timing: 5 -->

---

# heap_file.c 레코드 삽입 흐름 파악

**Scenario**: OOS 기능 개발 중 `heap_insert_logical` → `heap_insert_physical` 호출 체인을 이해해야 했음.

**Before**

- clangd LSP 로 함수 호출 체인을 하나씩 따라가며 수동 탐색
- `heap_file.c` 가 15,000줄 이상 — 맥락을 따라가다 자주 잃었음

**After**

- Claude 가 clangd LSP 를 직접 호출해 정의·참조·호출 계층을 자동으로 수집
- 호출 체인 + 각 단계 역할 요약을 한 번에 확보

<span class="qualifier">이 특정 경험에서의 결과</span>

<!-- timing: 45 -->

---

# 탐색의 핵심 가치 — "어디를 봐야 할지" 바로 알려줌

**정답률 100%는 아니지만, navigational 가치가 매우 높음**

실제로 이런 질문을 바로 던졌음:

- "vector type 을 추가하고 싶은데 **어떤 부분에 추가하면 될까?**"
- "vacuum 을 직접 수동으로 수행시키는 방법 없을까?"
- "CUBRID 의 varbit 는 내부적으로 varchar 보다 더 효율적으로 동작할까?"

→ 관련 파일·함수 위치를 바로 지목 — **초기 탐색 시간이 극적으로 단축됨**

<span class="qualifier">항상 정확하지는 않지만, 어디부터 볼지 모를 때 시작점을 빠르게 잡아줌</span>

<!-- timing: 60 -->

---

# 탐색 영역 — 이런 것도 했습니다

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2em; text-align: left;">

<div>

**에러 메시지 → 코드 위치 추적**

- Before: 에러 메시지 일부를 grep + msgcat 교차 참조로 수동 탐색
- After: Claude에 에러 메시지 주고 "어디서 발생하나?" 질문 → 후보 파일/함수 지정
- 후보가 복수일 때 잘못된 걸 먼저 지정한 경우 있음

</div>

<div>

**다른 개발자 PR 이해**

- Before: PR diff + 커밋 로그 수동 독해, 컨텍스트 조립에 시간
- After: Claude가 변경 범위 + 영향 범위 요약 → **리뷰 준비 시간 단축**
- PR 구조/변경 범위를 빠르게 파악하는 데 유용

</div>

</div>

<div class="caveat">주의: AI 요약은 리뷰 시작점. PR 작성자 의도는 작성자에게 직접 확인해야 합니다.</div>

<!-- timing: 50 -->

---

# Part 2: 실제 개발 작업

**로그 읽고, 테스트 쓰고, 함수 짜기**

<!-- timing: 5 -->

---

# CI shell-test 실패 분석

**Scenario**: PR merge 후 CI shell test 실패. 로그가 길고 원인이 불명확했음.

**Before**

- CI 로그 다운로드 → expected/actual diff 비교 → 로컬 재현 시도
- 원인을 찾기까지 시간이 오래 걸렸음

**After**

- Claude에 실패 로그 + 테스트 스크립트를 읽히고 분석 요청 → 근본 원인 파악

<span class="qualifier">이 특정 경험에서의 결과</span>

<!-- timing: 45 -->

---

# 개발 영역 — 이런 것도 했습니다

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2em; text-align: left;">

<div>

**isolation test (.ctl) 초안 작성**

- Before: 기존 `.ctl` 파일 복사 + 수동 수정, 시행착오
- After: 기존 패턴을 Claude에 학습시킨 후 초안 즉시 생성
- 보일러플레이트 구조는 빠르게 확보됨

</div>

<div>

**헬퍼 함수 + 단위 테스트 동시 작성**

- Before: 함수 → 빌드 → 테스트 수동 사이클
- After: 함수와 테스트를 동시에 생성
- NULL, empty, boundary edge case가 빠져 있어 직접 보완해야 했음

</div>

</div>

<div class="caveat">주의: 자동 생성된 테스트에서 NULL/경계값 edge case가 빠져 있었습니다. 테스트도 반드시 리뷰 대상입니다.</div>

<!-- timing: 50 -->

---

# 5시간 자율 작업: vector type / DDL / DML 재구현

**Part 2 심화 에피소드 — 가장 인상 깊었던 실험**

> **"토큰 비용 고려 없이 최대한의 개발 자동화를 맡겼을 때 어떤 게 가능한지?"**

**배경**

- 발표자가 **2개월 이상** 직접 작업했던 vector type 추가, DDL(CREATE TABLE), DML(INSERT/SELECT) 구현
- Claude Code 에게 해당 작업 전체를 맡기고 **혼자 약 5시간** 고민/작업하도록 둠

**결과**

- 실제 발표자가 작성한 결과물과 **놀라울 정도로 유사**한 구현 산출
- 발표자가 공수 부족으로 미처 못 넣었던 **에러 처리·세심한 예외 처리까지 포함**

<!-- timing: 60 -->

---

# 5시간 자율 작업 — 관찰과 교훈

**단번에 성공한 게 아니었음**

- **초기에는 작동 안 함** — 계속 디버깅하도록 강제했더니 결국 완성
- **Claude의 "lazy" 경향 관찰:** 작업 범위를 스스로 축소하려는 경향 있음 — 굴복하지 않고 계속 밀어붙여야 완성됨
- **토큰 소모 많음** — 5시간 자율 세션은 Max 20x 월정액이 아니었다면 API 청구서로 환산 시 상당한 비용 (발표자 직접 운영 데이터 기준)

<div class="caveat">주의: 실수도 있었음. 강제 디버깅 루프가 필수였음. 단번에 완성되지 않음.</div>

<span class="qualifier">이 규모의 자율 작업은 Max 20x 구독이 없었다면 API 비용 측면에서 현실적이지 않았을 것</span>

<!-- timing: 70 -->

---

# Coredump 디버깅 자동화 루프

**Scenario**: 5시간 자율 작업 중, 빌드는 되지만 실행 시 코어덤프 나는 상황 반복.

**Claude 가 알아서 돌린 루프**

1. 빌드 → 실행
2. 코어덤프 발생 → `gdb` 로 `bt` 자동 수집
3. 스택 트레이스 + 관련 소스 읽고 **원인 가설 수립**
4. 코드 수정 → 다시 빌드
5. 다시 실행 → 새 코어덤프 or 성공까지 **무한 반복**

<!-- timing: 40 -->

---

# Coredump 루프 — 관찰

- 사람이 개입하지 않아도 에러 위치를 스스로 좁혀감
- NULL deref, 잘못된 포인터 해제, lock 순서 오류까지 루프만으로 해결된 케이스 있었음
- 단, 루프가 무한정 돌지 않도록 **세션 시간·토큰 상한은 사람이 걸어둬야 함**

<span class="qualifier">Max 20x 의 긴 자율 세션 + 대규모 컨텍스트가 있어야 현실적으로 돌아감</span>

<!-- timing: 35 -->

---

# Part 3: 문서/커뮤니케이션

**쓰는 일에도 초안이 필요**

<!-- timing: 5 -->

---

# JIRA 이슈 / PR description 작성

**Scenario**: OOS 기능 새 JIRA 이슈 작성. 팀 컨벤션 = 한국어 본문 + 영어 섹션 헤더.

**Before**

- 기존 이슈를 참조하며 수동 작성
- 기술적 맥락 정리에 시간이 걸렸음

**After**

- 변경 코드 범위를 Claude에 보여주고 초안 요청 → 컨벤션에 맞는 초안 빠르게 확보

<span class="qualifier">이 특정 경험에서의 결과</span>

<!-- timing: 45 -->

---

# 문서 영역 — 이런 것도 했습니다

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2em; text-align: left;">

<div>

**Greptile 봇 리뷰 일괄 응답**

- Before: 코멘트당 개별 읽고 응답 작성
- After: PR의 Greptile bot 코멘트 전체에 대한 응답 초안을 한 번에 획득
- 초안을 기반으로 수정하는 방식으로 시간 단축

</div>

<div>

**조사 노트 → 내부 문서 변환**

- Before: 메모를 처음부터 재구조화
- After: Claude가 구조화된 초안 생성
- 원 메모에 없던 내용을 "보충"으로 추가한 적 있음

</div>

</div>

<div class="caveat">주의: Claude가 원 메모에 <b>없던 내용</b>을 "보충"으로 추가한 적이 있습니다. 문서화의 자동화는 확인의 자동화가 아닙니다.</div>

<!-- timing: 50 -->

---

# PR 리뷰 코멘트 응답 보조

<!-- TBD: 구체 PR 번호 발표 전 기입 -->

**Scenario**: PR 리뷰어 코멘트에 답변을 작성할 때 Claude를 활용했음.

- Before: 코멘트 읽기 → 관련 코드 다시 찾기 → 응답 직접 작성
- After: 코멘트 + 관련 코드를 Claude에 주고 응답 초안 요청 → 검토 후 게시

<br>

<span class="qualifier">리뷰 응답 속도가 줄었음. 단, 초안을 그대로 올리지 않고 반드시 읽고 수정했음.</span>

<div class="caveat">주의: 응답 초안은 시작점일 뿐. 리뷰어와의 소통은 개발자가 직접 해야 합니다.</div>

<!-- timing: 45 -->

---

# 발표 자료 생성 자동화 — 이 발표 자체가 사례

> **본 발표자료는 모두 Claude Code 와의 대화 방식으로 생성됨**

**Scenario**: 2개월 사용 경험을 정리한 60+ 슬라이드 발표 자료 — 직접 마크다운을 한 줄씩 쓰지 않음

**Before**

- 슬라이드 한 장씩 keynote/PPT 에서 제목 → 본문 → 디자인 수동 편집
- 흐름이 막히면 처음부터 다시 구성

**After (이 발표의 실제 작업 방식)**

- Marp + 마크다운 기반으로 **Claude Code 와 대화**하며 슬라이드 추가·수정·재배치
- "X 사례 추가해줘" / "이 슬라이드 더 짧게" / "Pros/Cons 로 재구성" 같은 자연어 지시
- 매 변경마다 **자동 커밋** — 변경 이력이 그대로 자료의 변천사가 됨

<span class="qualifier">발표 자료 자체가 "AI 와 함께 만든 결과물" — 디자인·디버깅·문서 모두 같은 워크플로</span>

<!-- timing: 50 -->

---

# 다른 개발자 성공 사례 — 본부 동료 피드백

**익명의 연구개발본부 동료 (jyj 님) — Claude Max 20x 사용자**

**① 간헐적 재현 버그 자동 추적**

- 몇 시간이고 Claude 가 기다려 재현 → 재현 범위 축소 → 빌드 → 재현 반복
- 결국 원인 찾음 — 개발자가 한 일은 **"기다리기"**

**② CTP 대량 실패 자동 분류**

- 로컬 결과 + CircleCI URL 만 줘도 실패 케이스별 분석
- test_sql / test_shell 모두 적용

**③ 복잡한 코드 흐름 시각화**

- Claude 가 슈도 코드 / 텍스트 그래프 자동 생성 → 코드 이해도 가속
- 사례: CBRD-26666 (parallel hash join split phase 개선)

<span class="qualifier">본 발표는 1인 사례 중심이지만 타 개발자도 유사 패턴 검증 — 일반화 가능성 시사</span>

<!-- timing: 90 -->

---

# 한계 — 네 가지 주의점

<!-- timing: 10 -->

---

# 한계 1: 검증은 여전히 개발자 몫

**개인 원칙**

- **"AI 출력은 항상 초안"** — 그대로 쓰는 코드는 없음
- **"모르는 코드일수록 더 의심"** — 자신 있어 보일수록 직접 확인
- **"빌드·테스트·리뷰는 여전히 개발자의 일"** — AI 가 대신할 수 없는 책임

**왜 이 원칙으로 충분한가**

- 과거의 "없는 함수/필드 지어내기" 류 환각은 빌드·테스트 루프로 대부분 걸러짐
- 남은 위험은 **컴파일은 통과하지만 의도가 다른 코드** — 리뷰어의 눈이 필요

<!-- timing: 70 -->

---

# 한계 2: 자동 생성 테스트는 의심하라

**관찰된 두 가지 패턴**

- **형식만 채우는 테스트** — 경계값·NULL·빈 입력 빠뜨림
- **통과만 목적인 mock 테스트** — 실제 코드 경로 미실행, 빌드는 통과하지만 버그 못 잡음

**대응**

- 테스트 코드도 **PR 리뷰 항목**으로 명시
- "이 테스트는 어떤 코드 경로를 실행하는가?" 를 본인이 직접 추적
- coverage / mutation testing 으로 **테스트가 정말 검증하는지** 측정

<span class="qualifier">개인 경험에서의 관찰 — 모든 생성 테스트에서 발생하지는 않았음</span>

<!-- timing: 75 -->

---

# 한계 3: 생성된 코드가 느릴 수 있음

**AI 가 만든 코드 ≠ 성능이 나오는 코드**

- build → test → build → test 피드백 루프에 집중하다 보면 **AI agent 는 성능을 신경 쓰지 않음**
- 기능만 맞는 코드, 비효율적 자료구조·알고리즘 선택 사례 관찰됨
- **목표 성능치를 애초에 주는 것부터 도전적** — "얼마나 빨라야 하는가" 가 사람에게도 불분명한 경우 많음

**대응 (현재 발표자 운영 방식)**

- **기능 구현은 AI, 성능 critical 영역은 사람이 직접 튜닝** — 책임 영역 분리
- 향후: 성능 측정 벤치마크를 피드백 루프에 추가하면 AI 가 성능까지 고려 가능 (미경험)

<div class="caveat">개인 사용 경험의 한계. 기능 구현 위주 루프만 돌려봤기 때문.</div>

<!-- timing: 75 -->

---

# 한계 4: AI 피로도 — Brain Fry, 새로운 피로

<!-- timing: 90 -->

- **고급 모델일수록 응답이 길어짐** — 작업당 수 초 ~ 수십 초 대기가 반복됨
- **대기 시간을 채우려고 다른 작업과 병렬 진행** — 컨텍스트 스위칭 비용 증가
- 결과: **AI 피로, 번아웃, 두통 유발 가능** — 모니터링·검증 부담까지 더해져 "Brain Fry" 상태
- 2개월 집중 사용하며 체감함. **대기와 병렬 처리 습관이 누적되면 신체적 피로**
- **개인 대응:** 주기적 휴식, 한 번에 여는 세션 수 제한, 타이머로 강제 이탈

<div class="caveat">Max 가 더 오래 생각하기 때문에 대기가 길어질 수 있음 → 피로도 더 높을 수 있음. 이는 Max 의 강점(깊은 사고)의 trade-off.</div>

<span class="qualifier" style="font-size:0.75em;">
참고: <a href="https://hbr.org/2026/03/when-using-ai-leads-to-brain-fry">HBR — When Using AI Leads to Brain Fry (BCG+UC Riverside)</a> ·
<a href="https://www.axios.com/2026/04/04/ai-agents-burnout-addiction-claude-code-openclaw">Axios — AI Agents Burnout & Addiction</a> ·
<a href="https://fortune.com/2026/03/10/ai-brain-fry-workplace-productivity-bcg-study/">Fortune — AI Brain Fry (BCG Study)</a>
</span>

---

# 작업 흐름의 변화

**2개월 동안 제가 달라진 것들**

<!-- timing: 10 -->

---

# 인간의 Feedback Loop 도 가속

**가설 검증 방식이 바뀌었음**

**이전 방식**

가설 → 조사 → 코드 분석 → 설계 → 구현 → 개발자 검증 → TC 생성 → 스펙 변경 …

**지금 방식**

가설 → Claude 로 빠른 POC 검증 → 설계 → 스펙 검증 → unit test · TC 작성 → TC 검증 → AI 가 구현 → 코드 리뷰

**장점** — 각 단계마다 **좀 더 명확하고 빠른 피드백**을 받으며 진행할 수 있음

<!-- timing: 50 -->

---

# Feedback Loop 가속 — 실제 사용 패턴

- "이 접근법이 heap_file.c 구조에서 동작할까?" 를 구현 전에 Claude와 먼저 확인하는 습관이 생겼음
- Part 2의 **5시간 자율 작업 에피소드**도 이 흐름 변화의 연장선 (→ Part 2 참고)

<span class="qualifier">개인 워크플로우에서의 변화. 모든 작업에 적용한 건 아님.</span>

<!-- timing: 30 -->

---

# POC 검증 중심으로

**작은 실험을 먼저 해보는 방향**

- 구현을 시작하기 전에 작은 POC를 Claude에 요청해서 방향을 먼저 확인하는 방식으로 바뀌었음
- "이런 구조가 가능한가?"를 코드로 빠르게 확인하고, 막히면 방향을 틀었음

<br>

<span class="qualifier">개인 경험에서의 변화</span>

- 큰 구현을 시작하기 전에 작은 탐색을 먼저 하는 것이 시간을 아끼는 경우가 있었음

<!-- timing: 80 -->

---

# 조심스럽게 예측해보는 개발 프로세스의 변화

<!-- timing: 10 -->

---

# Spec Driven Development (SDD)

**요구사항·스펙을 먼저 글로 명확히 작성한 뒤 구현에 들어가는 개발 방식**

- AI와 협업할 때 요구사항을 먼저 명확히 적어두면 결과 품질이 올라가는 걸 체감했음
- "무엇을 만들어야 하는가"를 글로 정리하는 것이 AI 지시에 더 효과적
- "요구사항을 먼저 글로 쓰는 것"이 AI 활용 ROI를 높이는 데 도움이 됐다는 경험 공유

<!-- timing: 45 -->

---

# SDD 의 핵심 — SSOT 와 JIRA 이슈

**SSOT (Single Source of Truth) 를 만드는 것이 중요**

- 스펙이 여러 곳에 흩어져 있으면 AI 도 사람도 혼란 — 단일 원본이 있어야 함
- **JIRA 이슈를 최대한 자세히 작성**하는 것이 중요 — JIRA 이슈 자체가 SSOT 역할
- 배경, 목적, 요구사항, 예상 동작, 예외 케이스까지 글로 남길수록 재사용 가치가 올라감

**앞으로의 방향성**

- Claude Code 가 **JIRA 이슈를 직접 읽고 구현을 자동 수행**하는 흐름으로 갈 것으로 예상
- 이슈 작성에 들이는 시간이 **곧 구현 품질** 로 환산되는 구조
- "잘 쓴 이슈 = 잘 구현된 코드" 의 연결이 더 강해짐

<!-- timing: 75 -->

---

# Test Driven Development (TDD)

**실패하는 테스트를 먼저 작성하고, 그 테스트를 통과시키도록 구현하는 개발 방식**

- 테스트를 먼저 쓰면 AI가 그 테스트를 통과하는 구현을 맞춰 생성하는 방식이 잘 동작했음
- 검증 기준이 먼저 있으면 AI 출력의 품질 판단이 쉬워졌음
<!-- timing: 60 -->

---

# AI 친화 = 사람 친화 — 암묵지를 글로 내려놔라

**신규 입사자와 AI 는 같은 입장에서 프로젝트를 바라봄**

- AI 효율을 위해 정리한 문서·스크립트는 **신규 입사자 온보딩 그대로 가속**
- 반대도 성립 — **Win-win** 구조, 한쪽 투자가 양쪽을 돕는 구조

**예시 — 명시화할 가치가 있는 암묵지**

- `ctp.sh --help`, `README`, 빌드 스크립트 주석 — AI 가 먼저 읽고 업무 파악
- 트러블슈팅: "서버가 갑자기 죽으면 `$CUBRID/log/server/<db>_stdout.log` 부터" 같은 지식
- 머릿속에만 있는 암묵지는 AI 가 접근 불가 → 글로 내려놔야 **AI·신입·기존 개발자 모두 같이 빨라짐**

<!-- timing: 90 -->

---

# AI 운영 방어 — 환경 갖추기 + Fail fast + Timeout

**AI Agent 가 사람처럼 일하려면 사람과 같은 환경 + 잘못된 길에서 빠르게 빠져나오는 장치 필요**

- 빌드 → DB 구동 → 예제 실행 → coredump 분석 → GDB attach 까지 가능해야 진짜 agent
- 단순 코드 reading 만으로는 가설 검증 불가 → 추측에 머무름
- 빌드·테스트·외부 호출이 **멈춰도 AI 는 계속 기다림** — 가장 비싼 비용

**대응 — 헛수고 방지 3단계**

- **환경 명시**: worktree 위치 / 빌드 가능 상태 / DB 실행 가능 / coredump 위치를 AI 에게 알려주기
- **Skill 앞단 prerequisite**: branch 불일치·미빌드 상태에서 즉시 에러 중단 — "Fail fast" 가 가장 싼 디버깅
- **Hang/무한 루프 방지**: timeout 짧게, "N분 경과 시 다른 방법을 찾아라" 지시, iteration 상한 알림

**더 나은 방식 모색 중**

- 세션 시작 hook, MCP 도구, 자동 복구(branch checkout / rebuild)
- 팀·본부 차원 **표준 prerequisite 라이브러리** 가 있으면 더 효과적

<!-- timing: 120 -->

---

# 모듈 분석서 (Obsidian Graph) — 조직 자산화 제안

**개발 4팀 송일한님 사례 · CUBRID 전체 모듈 코드 분석서**

- 공개 데모: <https://xmilex-git.github.io/claude-obsidian/>
- Obsidian **graph view** 로 모듈·함수·개념을 위키처럼 양방향 링크
- AI 가 그래프 노드를 따라가며 **필요한 컨텍스트만 골라 읽음** → 분석 비용·토큰 절약
- 사람에게도 그대로 **인수인계 문서** — 1석 2조

**조직 자산화 제안**

- **팀 단위**: 각 팀이 담당 모듈을 Obsidian / 마크다운 위키로 정리 (graph view 호환)
- **본부 단위**: 팀별 분석서를 수집·인덱싱 → AI 가 본부 전체 코드베이스에 일관된 컨텍스트로 접근

<span class="qualifier">현재는 한 사람에 의존도 집중 — 조직 자산화 시 신규 입사자 온보딩 + AI 컨텍스트 동시 해결</span>

<!-- timing: 90 -->

---

# 연구개발본부 업무 자동화 후보 — Git / GitHub 영역

**① Git 일상 흐름 자동화**

- `git stage → add → commit → push` 한 번에 — 변경 분석으로 **커밋 메시지 자동 작성**
- 팀 컨벤션(prefix, JIRA 키, 영문/한글 요약)을 학습시켜 **일관된 메시지 품질**

**② Git Merge Conflict 해결 — 컨텍스트 기반**

- "develop 쪽 의도가 우선" / "특정 모듈은 feature 우선" 같은 **자연어 지시를 받아** AI 가 hunk 단위로 판단
- 단순 `--ours` / `--theirs` 보다 **세분화된 conflict 해결 정책** 적용 가능
- 충돌 패턴이 반복되면 skill 로 굳혀 매번 사람이 일일이 풀 필요 없어짐

**③ gh CLI / API 자동화**

- PR 생성·draft 전환, **리뷰어 자동 등록·re-request**, 댓글·대댓글, 머지 후 정리
- **Greptile 봇 응답 일괄 처리** — 이미 발표자 운영 중 (skill 화)
- PR 리뷰 후 코멘트 자동 게시 등 **반복 GitHub 업무 전반**

<!-- timing: 75 -->

---

# 연구개발본부 업무 자동화 후보 — JIRA / 문서 영역

**④ JIRA REST API 연동 — CBRD 이슈 양방향 자동화**

- **CBRD-XXXXX 다운로드** → JIRA grammar 를 **마크다운으로 변환** → AI 가 읽기 쉬운 형태로 보관
- AI 와 작성한 **마크다운을 JIRA grammar 로 역변환** → API 로 이슈 본문 직접 업데이트
- 이슈 검색·코멘트 추가·status 전환까지 자동화 가능 → **JIRA 가 SSOT 로 작동하는 SDD 흐름과 연결**

**왜 이 4가지를 우선 후보로 꼽았는가**

- **매일 반복** 되는 작업 — ROI 가 즉시 눈에 보임
- **개인 작업물이 아닌 협업 인터페이스** (git/PR/JIRA) — 팀 단위로 효과 증폭
- 외부 API/CLI 가 잘 정비돼 있어 **AI 가 안전하게 다루기 쉬움**
- 한 번 skill 화하면 **본부 전체가 공유** 가능

<span class="qualifier">발표자 현재 운영 — Greptile 응답·PR 리뷰 보조·JIRA 이슈 작성 보조까지는 이미 skill 화. 나머지는 발전 중</span>

<!-- timing: 75 -->

---

# 시작 가이드

**바로 적용해볼 수 있는 세 가지**

---

# 이 세 가지부터 + 꿀팁

```bash
# 낯선 코드 탐색
claude "이 파일이 뭘 하는지 설명해줘"

# 디버깅 첫 걸음
claude "이 에러 로그의 원인을 분석해줘"

# 문서 초안
claude "이 diff 기반으로 PR description 작성해줘"
```

**꿀팁 — 직접 짜지 말고 추천받아라**

> *"X 를 하고 싶다. 지금 사용 가능한 skill / 명령어를 조합해서 가장 좋은 프롬프트를 추천해줘."*

- Claude Code 는 설치된 **skill / slash command / MCP 도구**를 다 알고 있음 → 후보 중 고르기만
- `CLAUDE.md`: 프로젝트 루트에 빌드 방법·디렉토리 구조·컨벤션 적어두면 매번 설명 줄어듦
- `/compact`: 대화 길어지면 컨텍스트 압축으로 응답 속도 회복

<span class="qualifier">프롬프트 엔지니어링보다 "무엇을 요청할지 아는 것"이 핵심</span>

<!-- timing: 120 -->

---

# All-in-one 플러그인 — 초심자에게 추천

**처음부터 skill 을 직접 만들 필요 없음 — 잘 만들어진 플러그인 위에서 시작**

- **oh-my-claudecode (omc)** — multi-agent orchestration, 50+ skill 묶음 (`/autopilot`, `/ralph`, `/team`, `/deep-interview` 등)
- **superpowers** — 개발 워크플로 자동화 skill 모음 (TDD, refactoring, git 흐름)
- **serena** — 시맨틱 코드 분석·탐색 MCP 서버 (LSP 기반, 거대 코드베이스 친화)

**왜 플러그인부터 시작하면 좋은가**

- "내가 뭘 자동화할 수 있는지" 를 **선행 사례로 학습** — 시야가 넓어짐
- 각 플러그인이 **현장에서 검증된 패턴** 을 담고 있음 → 시행착오 단축
- 익숙해지면 **자기 워크플로에 맞춰 fork·수정·삭제** 하면 됨

<span class="qualifier">단, 플러그인이 많아지면 컨텍스트 오염·skill 충돌 발생 — 익숙해진 뒤 정리 필수</span>

<!-- timing: 75 -->

---

# Skill — "가장 개인적인 것이 가장 창의적이다"

**Skill** = 반복 수행할 작업 절차를 재사용 가능한 형태로 저장해둔 Claude Code 확장 기능

- **범용 skill 은 결국 언젠가 누군가가 만들어 낸다** — 공용 도구는 시간 문제
- 진짜 가치는 **팀·개인 워크플로에 특화된 skill** — 남이 대신 만들어 줄 수 없는 부분
- CUBRID 빌드/테스트 스크립트, 팀 내부 컨벤션, JIRA 이슈 포맷, 회사 PR 규칙 등 → 나만의 skill 로 축적 가능
- 한 번 만들어두면 **매번 같은 지시를 반복할 필요가 없어짐**

<!-- timing: 70 -->

---

# 자동화 자동화 — skill → script → plugin

**`/learner` → `/skill-creator` → script → plugin 흐름**

1. 오래 걸린 작업을 한 번 끝까지 수행
2. `/learner` 로 절차 학습 → `/skill-creator` 로 정식 skill 등록
3. 안정화되면 **결정론적 스크립트**로 내려 토큰·속도·재현성 확보
4. 관련 스크립트·skill 묶어 **Claude Code Plugin** 으로 배포

**왜 게임체인저인가**

- 첫 시도 비용을 **미래의 모든 반복에 분할 상환**
- "어떻게 하라" 가 아닌 **"무엇을 원한다"** 만 말해도 AI 가 절차 저장
- 팀 단위 공유 시 "한 사람이 뚫은 길" 을 팀 전체가 빠르게

**배포 계층**

- 개인 플러그인 → 팀 플러그인 → 연구개발본부 플러그인
- **장기 제안**: 플러그인 운영 자체를 공식 업무로 추가하면 자산이 축적됨

<span class="qualifier">"자동화하는 작업을 자동화" — 한 번 익히면 평생 재산</span>

<!-- timing: 120 -->

---

# Q&A

**모르는 건 솔직하게 답변드리겠습니다.**

<br>

<!-- timing: 10 -->

---

# 감사합니다

**Claude Code Max 2개월 사용 경험 공유**

<br>

자주 물어보시는 내용은 다음 슬라이드(FAQ)에 미리 준비했습니다.

김대현 · 개발 2팀 & AI TFT · kimdhyungg@gmail.com

<!-- timing: 10 -->

---

# FAQ (부록)

---

- 오류가 너무 많아요
  - 검증 가능한 **feedback loop** (build + testcase) 를 설정하시면 줄어듭니다.

- 기존 코드를 재사용하지 않고 너무 장황하게 코드를 양산해요
  - 빌드 가능한 환경에서 **clangd LSP + MCP** 설정 확인이 도움됩니다.

- 대화가 길어지니까 제 말을 잘 이해하지 못해요 / prompt 지시사항을 안 지켜요
  - **Claude Code Max + Opus 4.7 (1M Context)** 인지 확인 — 1M Context 가 핵심 (책 22권 분량)

- skill 이나 tool 을 안 사용해요
  - prompt 에 직접 특정 skill 을 사용하라고 명시하면 호출 빈도 ↑
