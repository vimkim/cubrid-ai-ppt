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
- TFT 업무: AI Agent (Open Code, OMC, OMO) 소스코드 분석
- **2개월간 매일 사용** — Claude Code Max 20x (Opus 4.7 1M Context)
- 보조: OpenAI Codex, Grok
- **참여 스터디**
  - Claude Code 소스코드 분석 스터디
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

- 개발팀 반복 업무의 **큰 비중을 부분 자동화 가능**
- Claude Code에서 대부분의 업무를 처리 가능
  - jira, ppt, github, vscode 등 모두 포함

## Cons

- 생산성은 **경험 혹은 경력**에 비례할 것이다 - AI가 사용자에게 끊임없이 디렉션을 요구하기 때문
- 복잡한 TC 검증·디렉션은 사람 몫
- 고급 업무를 위해서는 팀 단위로 **Knowledge Base** 구축이 필요하다
- 체감 상 Claude Max Opus 4.7 1M 한정 - (16만원 이상 😢😢)

---

# 한 줄 요약 — 성공한 영역 vs 실패한 영역

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5em; text-align: left; font-size: 0.92em;">

<div style="padding: 0.8em; background: #eef9ee; border: 2px solid #6c6; border-radius: 8px;">

**✅ 성공한 영역 — 검증 루프가 명확**

- **Code POC 작성** — "우선 돌아가는가?" 빠른 확인
- **버그 수정** — 빌드·테스트 루프로 즉시 검증
- **JIRA 이슈 작성** — 코드 변경 기반 초안
- **PR description 작성** — diff 기반 자동 정리
- **PR 리뷰 보조** — 변경 범위 요약, 코멘트 응답
- **성능 측정 / 분석** — 벤치마크 결과 해석

</div>

<div style="padding: 0.8em; background: #fdeded; border: 2px solid #c66; border-radius: 8px;">

**❌ 실패한 영역 — 검증이 어려운 곳**

- **좋은 동시성 TC 작성** — race condition 재현·검증 난해
- **비동기 TC 작성 (vacuum 등)** — 타이밍·상태 의존성 높음
- **성능 높은 코드 작성** — "얼마나 빨라야 하나" 자체가 모호
- **공통점**: build / unit test 루프로 옳고 그름을 가릴 수 없음
- → AI 가 "통과시키기" 가 아니라 **"옳음" 을 학습할 신호가 없음**

</div>

</div>

<!-- timing: 80 -->

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

> AI Agent 시장은 매주 변동

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

<div style="text-align: center; margin: 0.4em 0;">

<div style="display: inline-block; padding: 0.6em 1.5em; background: #2d4a8a; color: white; border-radius: 10px; font-weight: bold; font-size: 1.05em;">
🤖 Claude Code Agent Harness — "사람처럼 일하는 환경"
</div>

<div style="margin: 0.3em 0; color: #888; font-size: 0.85em;">↓ 모델을 둘러싼 도구·메모리·실행 환경 ↓</div>

<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.4em; margin-bottom: 0.4em; font-size: 0.78em;">
<div style="padding: 0.4em; background: #f5f0ff; border: 1px solid #b9a; border-radius: 6px;"><b>📁 파일 시스템 조작</b><br>Read / Write / Edit / Glob / Grep</div>
<div style="padding: 0.4em; background: #f5f0ff; border: 1px solid #b9a; border-radius: 6px;"><b>⚡ 임의 명령 실행</b><br>Bash · git · gh · jq · CLI 전반</div>
<div style="padding: 0.4em; background: #f5f0ff; border: 1px solid #b9a; border-radius: 6px;"><b>⏳ 장기 / 백그라운드</b><br>빌드·테스트 비동기 실행</div>
<div style="padding: 0.4em; background: #f5f0ff; border: 1px solid #b9a; border-radius: 6px;"><b>🔌 MCP</b><br>clangd / GitHub / JIRA / DB</div>
</div>

<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.4em; font-size: 0.78em;">
<div style="padding: 0.4em; background: #f5f0ff; border: 1px solid #b9a; border-radius: 6px;"><b>🛠️ Skill / Slash / Plugin</b><br>반복 워크플로 재사용</div>
<div style="padding: 0.4em; background: #f5f0ff; border: 1px solid #b9a; border-radius: 6px;"><b>👥 Sub-agent / Team</b><br>병렬·계층 협업</div>
<div style="padding: 0.4em; background: #f5f0ff; border: 1px solid #b9a; border-radius: 6px;"><b>🪝 Hook / Auto-memory</b><br>세션 간 컨텍스트 유지</div>
</div>

</div>

> 단순 자동완성·코드 제안과는 **완전히 다른 카테고리**

<!-- timing: 75 -->

---

# "이렇게 강한 권한, 위험하지 않나?"

**자연스러운 우려 — 파일 쓰기 + 임의 명령 + 백그라운드 실행**

<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.5em; margin: 0.5em 0; font-size: 0.82em;">

<div style="padding: 0.6em; background: #eef4ff; border: 2px solid #4a80c0; border-radius: 8px;">
<b>🔒 Permission Mode</b>
<small>매 도구 호출마다 사용자 확인 (default) / acceptEdits / plan / bypass — 위험도에 따라 단계적 권한 부여</small>
</div>

<div style="padding: 0.6em; background: #eef4ff; border: 2px solid #4a80c0; border-radius: 8px;">
<b>🌳 Bash Tree-sitter 파싱</b>
<small>실행 전 명령을 AST 단위로 분해해 위험 패턴 탐지 — `rm -rf /` 류는 자동 차단·경고</small>
</div>

<div style="padding: 0.6em; background: #eef4ff; border: 2px solid #4a80c0; border-radius: 8px;">
<b>🪝 Hook 시스템</b>
<small>PreToolUse / PostToolUse hook 으로 도구 호출 가로채기 — 팀 정책 강제, 감사 로그</small>
</div>

<div style="padding: 0.6em; background: #eef4ff; border: 2px solid #4a80c0; border-radius: 8px;">
<b>📋 Plan / Auto Mode</b>
<small>실행 전 계획 검토 단계 / Auto mode 의 destructive 가드 — 데이터 삭제·공유 시스템 변경은 확인 필수</small>
</div>

<div style="padding: 0.6em; background: #eef4ff; border: 2px solid #4a80c0; border-radius: 8px;">
<b>🐳 Sandbox / Worktree</b>
<small>git worktree 격리·devcontainer·DangerouslySkipPermissions 컨테이너 등 격리 실행 옵션</small>
</div>

<div style="padding: 0.6em; background: #eef4ff; border: 2px solid #4a80c0; border-radius: 8px;">
<b>⚙️ Settings.json 권한</b>
<small><code>allow</code> / <code>deny</code> / <code>ask</code> 리스트 — 도구·명령·MCP 단위로 세분화된 화이트/블랙리스트</small>
</div>

</div>

<div class="caveat">보안·거버넌스 영역만으로 별도 발표 한 번 분량 — <b>본 발표 범위에서는 제외</b>, 관심 있으시면 별도 자리에서 공유 드릴 수 있습니다.</div>

<!-- timing: 60 -->

---

# Claude Code × CUBRID — 진짜 개발자처럼 일한다

**Claude 가 CUBRID repo 에서 실제로 할 수 있는 일들**

- **코드 수정 후 빌드 무한 반복** — `cmake` / `make` 호출, 에러 로그 분석, 의존성 자동 설치
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

> 이 환경 미만 (예시: Claude Pro & Sonnet)에서는 본 발표 사례가 **그대로 재현되지 않을 수 있음**

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

**Scenario**: 기능 개발 중 `heap_insert_logical` → `heap_insert_physical` 호출 체인을 이해해야 했음.

**Before**

- IDE, gdb로 함수 호출 체인을 하나씩 따라가며 수동 탐색
- `heap_file.c` 가 15,000줄 이상 — 맥락을 따라가다 자주 잃었음

**After**

- Claude 가 clangd LSP 를 직접 호출해 정의·참조·호출 계층을 자동으로 수집
- Claude 가 gdb ex mode 로 직접 콜스택 분석
- 호출 체인 + 각 단계 역할 요약을 한 번에 확보 -> 분석서 작성

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

# 코드 탐색

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

<!-- timing: 45 -->

---

# AI 개발 - POC 생성

> vector type을 추가해줘.

> vacuum 에서 OOS 값을 비동기적으로 삭제하도록 지원해줘.

> 내가 짠 코드의 unit test를 만들어줘.
> CS_MODE, SA_MODE, SERVER_MODE 용 유닛테스트를 다 만들어줘.
> sql test, shell test, isolation test 작성해줘.

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2em; text-align: left;">


<div>

**헬퍼 함수 + 단위 테스트 동시 작성**

- Before: 함수 → 빌드 → 테스트 수동 사이클
- After: 함수와 테스트를 동시에 생성

</div>

</div>

<!-- timing: 50 -->

---

# 5시간 자율 작업: vector type / DDL / DML 재구현

**배경**

- 발표자가 2025년 **2개월 이상** 직접 작업했던 vector type 추가, DDL(CREATE TABLE), DML(INSERT/SELECT) 구현
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

<!-- timing: 70 -->

---

# Coredump 디버깅 자동화 루프

**Scenario**: 5시간 자율 작업 중, 빌드는 되지만 실행 시 코어덤프 나는 상황 반복.

**Claude 가 알아서 돌린 루프 — 사람 개입 없이 닫힌 cycle**

<div style="display: flex; gap: 0.4em; align-items: center; flex-wrap: wrap; justify-content: center; font-size: 0.85em; margin: 0.6em 0;">
<div style="padding: 0.5em 0.7em; background: #eef; border: 1px solid #99c; border-radius: 6px;">① 빌드 → 실행</div>
<div style="color: #999;">→</div>
<div style="padding: 0.5em 0.7em; background: #eef; border: 1px solid #99c; border-radius: 6px;">② <code>gdb bt</code> 자동 수집<br><small>(코어덤프 발생)</small></div>
<div style="color: #999;">→</div>
<div style="padding: 0.5em 0.7em; background: #eef; border: 1px solid #99c; border-radius: 6px;">③ 스택+소스 → <b>원인 가설</b></div>
<div style="color: #999;">→</div>
<div style="padding: 0.5em 0.7em; background: #eef; border: 1px solid #99c; border-radius: 6px;">④ 코드 수정 → 다시 빌드</div>
<div style="color: #999;">→</div>
<div style="padding: 0.5em 0.7em; background: #d4f4d4; border: 1px solid #6c6; border-radius: 6px;">⑤ 성공? ✅</div>
</div>

<div style="text-align: center; color: #c33; font-weight: bold; font-size: 0.9em; margin-top: 0.3em;">↻ 새 코어덤프 시 ① 로 돌아가 <b>무한 반복</b> — 사람 개입 0</div>

<!-- timing: 50 -->

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

- 변경 코드 범위를 Claude에 보여주고 초안 요청 → 
- /cubrid-jira-issue-write 스킬로 jira 작성
- /jira 이슈와 코드 검토 후 /cubrid-pr-create 스킬로 생성

---

# PR 리뷰 코멘트 응답 보조

<!-- TBD: 구체 PR 번호 발표 전 기입 -->

**Scenario**: PR 리뷰어 코멘트에 답변을 작성할 때 Claude를 활용했음.

- Before: 코멘트 읽기 → 관련 코드 다시 찾기 → 응답 직접 작성
- After: 코멘트 + 관련 코드를 Claude에 주고 응답 초안 요청 → /jira 이슈와 코드 검토 후 게시

> PR 링크를 읽고 댓글에 모두 대응하고, 맞으면 코드 수정해줘.

> PR 댓글에 대해 모두 대응 댓글 달아줘.

<br>

<!-- timing: 45 -->
---

# JIRA REST API 연동 — CBRD 이슈 양방향 자동화

**Scenario**: CBRD 이슈를 매번 웹 UI 에서 다운로드/업로드하기 번거로움. JIRA grammar 변환도 손이 많이 감.

**Before**

- 웹 UI 에서 이슈 본문 수동 복사 → 마크다운으로 정리 → 다시 JIRA grammar 로 수동 변환
- 컨텍스트 스위칭 비용 높음

**After**

- REST API 로 CBRD-XXXXX 자동 다운로드 → pandoc 으로 JIRA → 마크다운 변환 → AI 가 다루기 쉬운 형태로 보관
- AI 가 작성한 마크다운을 JIRA grammar 로 역변환 → API 로 본문 직접 업데이트
- `/jira CBRD-XXXXX` skill 한 줄로 풀 컨텍스트 fetch

<!-- timing: 60 -->

---

# 발표 자료 생성 자동화 — 이 발표 자체가 사례

> **본 발표자료는 모두 Claude Code 와의 대화 방식으로 생성됨**

**Scenario**: 2개월 사용 경험을 정리한 60+ 슬라이드 발표 자료 — 직접 한 줄 쓰지 않음

**Before**

- 슬라이드 한 장씩 keynote/PPT 에서 제목 → 본문 → 디자인 수동 편집
- 흐름이 막히면 처음부터 다시 구성

**After (이 발표의 실제 작업 방식)**

- Marp + 마크다운 기반으로 **Claude Code 와 대화**하며 슬라이드 추가·수정·재배치
- "X 사례 추가해줘" / "이 슬라이드 더 짧게" / "Pros/Cons 로 재구성" 같은 자연어 지시
- 매 변경마다 **자동 커밋** — 변경 이력이 그대로 자료의 변천사가 됨

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

# Credits — 이 발표를 도와주신 분들

**연구개발본부 동료분들의 피드백·사례 공유 덕분에 본 발표가 완성되었습니다.**

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5em; text-align: left; margin-top: 1.5em;">

<div>

- **주영진** 님
- **류형규** 님

</div>

<div>

- **김태우** 님
- **송일한** 님

</div>

</div>

<br>

> 사용 사례·실패담·리뷰 피드백을 아낌없이 공유해 주셔서 감사합니다. 🙏

<!-- timing: 30 -->

---

# 한계 — 다섯 가지 주의점

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

<!-- timing: 75 -->

---

# 한계 3: 생성된 코드가 느릴 수 있음

**AI 가 만든 코드 ≠ 성능이 나오는 코드**

- build → test → build → test 피드백 루프에 집중하다 보면 **AI agent 는 성능을 신경 쓰지 않음**
- 기능만 맞는 코드, 비효율적 자료구조·알고리즘 선택 사례 관찰됨
- **목표 성능치를 애초에 주는 것부터 도전적** — "얼마나 빨라야 하는가" 가 사람에게도 불분명한 경우 많음
- 향후: 성능 측정 벤치마크를 피드백 루프에 추가하면 AI 가 성능까지 고려 가능

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

# 한계 5: AI 동조 (Sycophancy) — "맞지?" 에 무비판 OK


- 사용자가 긍정적·단정적으로 표현하면 AI 가 그대로 따라가는 경향
- 예: *"이 부분 이렇게 고치는 게 낫지 않아?"* → 안 좋아도 그대로 진행
> 익명의 jyj님 피드백

**대응 — 두 가지**

- **질문 화법을 중의적으로**
  - ❌ *"이렇게 고치는 게 낫지 않아?"* — 긍정 유도
  - ✅ *"다른 좋은 방법이 있을까? 지금 방법이 최선이야?"* — 열린 질문
- **`grill-me` 스킬** — AI 가 사용자를 거꾸로 *relentlessly* 심문하며 약점 발견
  - **본 발표 자료도 `grill-me` 로 무한 자기검증 중** — 슬라이드 흐름·모순·약점을 AI 가 먼저 지적
  - 단점: 촌철살인이 강해 자존감 깎일 수 있음


<!-- timing: 90 -->

---

# 작업 흐름의 변화

**2개월 동안 제가 달라진 것들**

<!-- timing: 10 -->

---

# 인간의 Feedback Loop 도 가속

**가설 검증 방식이 바뀌었음**

<div style="margin: 0.5em 0;">

<div style="margin-bottom: 0.6em;">
<b>이전 방식</b>
<div style="display: flex; gap: 0.3em; flex-wrap: wrap; align-items: center; font-size: 0.78em; margin-top: 0.3em;">
<div style="padding: 0.4em 0.6em; background: #fff0f0; border: 1px solid #c99; border-radius: 4px;">가설</div>
<div style="color: #999;">→</div>
<div style="padding: 0.4em 0.6em; background: #fff0f0; border: 1px solid #c99; border-radius: 4px;">조사</div>
<div style="color: #999;">→</div>
<div style="padding: 0.4em 0.6em; background: #fff0f0; border: 1px solid #c99; border-radius: 4px;">코드 분석</div>
<div style="color: #999;">→</div>
<div style="padding: 0.4em 0.6em; background: #fff0f0; border: 1px solid #c99; border-radius: 4px;">설계</div>
<div style="color: #999;">→</div>
<div style="padding: 0.4em 0.6em; background: #fff0f0; border: 1px solid #c99; border-radius: 4px;">구현</div>
<div style="color: #999;">→</div>
<div style="padding: 0.4em 0.6em; background: #fff0f0; border: 1px solid #c99; border-radius: 4px;">개발자 검증</div>
<div style="color: #999;">→</div>
<div style="padding: 0.4em 0.6em; background: #fff0f0; border: 1px solid #c99; border-radius: 4px;">TC 생성</div>
<div style="color: #999;">→</div>
<div style="padding: 0.4em 0.6em; background: #fff0f0; border: 1px solid #c99; border-radius: 4px;">스펙 변경 …</div>
<div style="color: #999;">→</div>
<div style="padding: 0.4em 0.6em; background: #fff0f0; border: 1px solid #c99; border-radius: 4px;">반복 …</div>
</div>
</div>

<div>
<b>지금 방식</b>
<div style="display: flex; gap: 0.3em; flex-wrap: wrap; align-items: center; font-size: 0.78em; margin-top: 0.3em;">
<div style="padding: 0.4em 0.6em; background: #f0fff0; border: 1px solid #9c9; border-radius: 4px;">가설</div>
<div style="color: #999;">→</div>
<div style="padding: 0.4em 0.6em; background: #f0fff0; border: 1px solid #9c9; border-radius: 4px;"><b>AI POC (Claude)</b></div>
<div style="color: #999;">→</div>
<div style="padding: 0.4em 0.6em; background: #f0fff0; border: 1px solid #9c9; border-radius: 4px;">설계</div>
<div style="color: #999;">→</div>
<div style="padding: 0.4em 0.6em; background: #f0fff0; border: 1px solid #9c9; border-radius: 4px;"><b>스펙 (SSOT) 작성 및 검증</b></div>
<div style="color: #999;">→</div>
<div style="padding: 0.4em 0.6em; background: #f0fff0; border: 1px solid #9c9; border-radius: 4px;">unit test · TC 작성 및 검증</div>
<div style="color: #999;">→</div>
<div style="padding: 0.4em 0.6em; background: #f0fff0; border: 1px solid #9c9; border-radius: 4px;"><b>AI 구현</b></div>
<div style="color: #999;">→</div>
<div style="padding: 0.4em 0.6em; background: #f0fff0; border: 1px solid #9c9; border-radius: 4px;"><b>AI 리뷰</b></div>
<div style="color: #999;">→</div>
<div style="padding: 0.4em 0.6em; background: #f0fff0; border: 1px solid #9c9; border-radius: 4px;">코드 리뷰</div>
</div>
</div>

</div>

**장점** — 각 단계마다 **명확하고 빠른 피드백**을 받으며 진행

<!-- timing: 50 -->

---

# Feedback Loop 가속 — 실제 사용 패턴

- "이 접근법이 heap_file.c 구조에서 동작할까?" 를 구현 전에 Claude와 먼저 확인하는 습관이 생겼음
- Part 2의 **5시간 자율 작업 에피소드**도 이 흐름 변화의 연장선 (→ Part 2 참고)

<!-- timing: 30 -->

---

# POC 검증 중심으로

**작은 실험을 먼저 해보는 방향**

- 구현을 시작하기 전에 작은 POC를 Claude에 요청해서 방향을 먼저 확인하는 방식으로 바뀌었음
- "이런 구조가 가능한가?"를 코드로 빠르게 확인하고, 막히면 방향을 틀었음

<!-- timing: 80 -->

---

# 개발 프로세스의 변화 예상

- SDD
- SSOT
- TDD

<!-- timing: 10 -->

---

# Spec Driven Development (SDD)

**요구사항·스펙을 먼저 글로 명확히 작성한 뒤 구현에 들어가는 개발 방식**

- AI와 협업할 때 요구사항을 먼저 명확히 적어두면 결과 품질이 올라가는 걸 체감했음
- "무엇을 만들어야 하는가"를 글로 정리하는 것이 AI 지시에 더 효과적
- "요구사항을 먼저 글로 쓰는 것"이 AI 사용에 유리

<!-- timing: 45 -->

---

# SSOT — 왜 SDD 의 핵심인가

> **SSOT (Single Source of Truth, 단일 진실 공급 원천)** — 같은 정보(요구사항·스펙·설계 결정)에 대해 **권위 있는 단일 출처**를 두는 원칙. 코드·문서·이슈·메모에 흩어져 있던 진실을 한 곳으로 모아 모든 작업이 그곳을 참조하도록 함.

**왜 핵심인가**

- **분산되면 모순이 누적** — 스펙이 코드 주석·JIRA·Slack·머릿속에 흩어지면 사람도 AI 도 *어느 게 진실인지* 모름
- **AI 출력의 일관성은 입력의 일관성에서 나옴** — SSOT 가 명확할수록 AI 결과 품질·재현성 ↑
- **변경·리뷰·온보딩 비용 절감** — "어디부터 봐야 하나" 문제가 즉시 해결됨

**SDD 와의 연결**

- SDD 의 spec 자체가 SSOT — 모든 구현·테스트·이슈·PR 이 SSOT 를 참조
- SSOT 가 없는 SDD 는 *"여러 spec 이 따로 도는 SDD"* 로 변질 → 시간이 지나면서 분산

<!-- timing: 75 -->

---

# 실제 일화 — OOS 프로젝트의 stale JIRA

**SSOT 가 분산되면 AI 가 잘못된 진실을 신뢰함**

- OOS 기능 개발 중 **스펙을 변경**하고 새 스펙대로 진행하기로 결정
- 하지만 **JIRA 이슈는 옛 스펙 그대로 미업데이트 상태**로 남아 있었음
- AI 에게 작업을 맡기자 → **오래된 JIRA 티켓을 SSOT 로 신뢰해 옛 스펙 고집**
- 새 스펙으로 안내해도 다시 JIRA 를 인용하며 옛 스펙으로 회귀

**교훈**

- "어디가 진실인가" 가 흐려지면 **AI 도 사람도 같이 헤맴**
- JIRA 처럼 **사람이 잊고 업데이트 안 하기 쉬운 매체**를 SSOT 로 두면 위험
- → **MD SSOT 한 곳에서 JIRA 가 자동 갱신**되어야 stale 문제 사라짐

<!-- timing: 90 -->

---

# SDD 의 핵심 — MD 가 SSOT, JIRA·PR 은 자동 생성

**SSOT 포맷 선택은 AI 친화성을 먼저 고려해야 함**

- JIRA / Confluence 문법은 **AI 비친화적** — 변환·왕복 손실이 크고 AI 가 직접 읽고 쓰기 어려움
- AI 가 다루기 힘든 포맷을 SSOT 로 두면 마찰만 누적 → **마크다운이 가장 AI 친화적인 SSOT**

**실제로 자리잡은 패턴 — MD 파일이 SSOT**

- 배경·목적·요구사항·예상 동작·예외 케이스를 **모두 마크다운으로 관리**
- MD 가 충분히 자세하면 **JIRA 이슈 본문 + PR description 을 AI 가 자동 생성**
- JIRA·PR 은 트래킹 인터페이스로만 사용 — **진실은 항상 MD 에**

**앞으로의 방향성**

- Claude Code 가 **MD SSOT 를 읽고 구현 자동 수행** + JIRA 본문·PR description 자동 게시
- "잘 쓴 MD = 잘 구현된 코드 + 자동 생성된 이슈/PR" 의 연결이 강해짐

<!-- timing: 90 -->

---

# SSOT 에서 모든 산출물이 자동 동기화

**MD SSOT 가 진실, 그 외는 자동 생성·갱신되는 부산물**

<div style="text-align: center; margin: 1em 0;">

<div style="display: inline-block; padding: 0.6em 1.5em; background: #2d4a8a; color: white; border-radius: 8px; font-weight: bold; font-size: 1.05em;">
📄 MD SSOT (spec.md) — 진실
</div>

<div style="margin: 0.4em 0; color: #888;">↓ AI 자동 동기화 ↓</div>

<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.5em; max-width: 90%; margin: 0 auto;">
<div style="padding: 0.5em; background: #eef; border: 1px solid #99c; border-radius: 4px;">Code</div>
<div style="padding: 0.5em; background: #eef; border: 1px solid #99c; border-radius: 4px;">Code Comment</div>
<div style="padding: 0.5em; background: #eef; border: 1px solid #99c; border-radius: 4px;">Tests / TC</div>
<div style="padding: 0.5em; background: #eef; border: 1px solid #99c; border-radius: 4px;">JIRA Ticket</div>
<div style="padding: 0.5em; background: #eef; border: 1px solid #99c; border-radius: 4px;">PR Description</div>
<div style="padding: 0.5em; background: #eef; border: 1px solid #99c; border-radius: 4px;">내부 문서</div>
<div style="padding: 0.5em; background: #eef; border: 1px solid #99c; border-radius: 4px;">매뉴얼</div>
<div style="padding: 0.5em; background: #eef; border: 1px solid #99c; border-radius: 4px;">--help 메시지</div>
</div>

</div>

**핵심 동작**

- **SSOT 와 다른 내용** 이 발견되면 → AI 가 SSOT 기준으로 **자동 수정**
- 진실이 바뀌면 **MD 한 곳만** 고치면 나머지는 따라옴
- 사람이 모든 산출물을 수동 동기화하지 않음 → **일관성 유지 비용 ↓**

<!-- timing: 90 -->

---

# spec.md 를 버전 관리 — Spec-as-Code 패턴

**MD SSOT 를 git 으로 관리하는 사례가 빠르게 늘어남**

- 코드와 **동일한 워크플로** — `git add spec.md`, PR 리뷰, `git log` / `git blame` 으로 변경 이력 추적
- JIRA 처럼 외부에서 잊혀지지 않음 → **stale 위험 ↓**

**Spec ↔ Prompt 통합 — spec 자체가 AI 에 전달되는 prompt**

- 도구 생태계 표준화 중 — `.claude/skills/`, `.omc/specs/`, `AGENTS.md`, `.cursor/rules`, `.windsurf/rules` 등
- spec 한 줄 수정 → AI 동작 / 산출물 변경 — **모두 git 위에서 추적**

**효과** — 코드 품질 관리 노하우(리뷰·lint·테스트)를 **spec 품질 관리에 그대로 적용**

> "잘 쓴 spec.md = 잘 동작하는 AI = 잘 구현된 코드 + 잘 생성된 이슈/PR"

<!-- timing: 90 -->

---

# Test Driven Development (TDD), Revisited

**실패하는 테스트를 먼저 작성하고, 그 테스트를 통과시키도록 구현하는 개발 방식**

**과거 — TDD 가 비직관적이었던 이유**

- 테스트 작성 자체에 **상당한 시간·비용** 투입 — 구현보다 테스트 코드가 더 길어지는 경우도 빈번
- "일단 구현부터 해보고 동작을 확인하는 편이 빠르다" 는 직관이 더 강했음
- 결과적으로 TDD 는 "이론적으로 옳지만 현실에서는 부담스러운 방식" 으로 인식됨

**지금 — AI 시대에 TDD 가 다시 매력적으로**

- 테스트 코드 초안 작성 비용이 **극적으로 낮아짐** — AI 가 케이스·픽스처·assert 까지 빠르게 생성
- 테스트를 먼저 쓰면 AI 가 그 테스트를 통과하는 구현을 **맞춰 생성** — 사양·검증 기준을 동시에 고정
- 검증 기준이 먼저 있으면 AI 출력의 품질 판단이 쉬움 — sycophancy / 환각 방어선

> **TDD Revisited** — "쓰기 비싸서 미루던" 시대에서 "AI 와 함께 먼저 쓰는 게 자연스러운" 시대로

<!-- timing: 90 -->

---

# AI 친화 == 사람 친화: 암묵지를 없애자

> **암묵지 (暗默知, Tacit Knowledge)** — 개인의 경험·노하우·직관처럼 말이나 글로 명확히 표현하기 어려운 잠재적 지식. 문서화 가능한 **형식지 (形式知, Explicit Knowledge)** 와 대비. 보통 도제·멘토링으로 전수되는 현장 숙련(know-how) 이 핵심.

**AI와 신규 입사자는 같은 입장에서 CUBRID를 바라봄**

- AI 효율을 위해 정리한 문서·스크립트는 **신규 입사자 온보딩 그대로 가속**
- 반대도 성립 — **Win-win** 구조, 한쪽 투자가 양쪽을 돕는 구조

**예시 — 명시화할 가치가 있는 암묵지**

- 명시적 가이드: `ctp.sh --help`, `README`, 빌드 스크립트 주석 — AI 가 자동으로 읽고 업무 파악
- 묵시적 트러블슈팅: "서버가 갑자기 죽으면 `$CUBRID/log/server/<db>_stdout.log` 부터" 같은 지식
- 머릿속에만 있는 암묵지는 AI 가 접근 불가 → 모두 명시해야 **AI·신입·기존 개발자 모두 같이 빨라짐**

<!-- timing: 110 -->

---

# AI 운영 방어 — 환경 갖추기 + Fail fast + Timeout

**AI Agent 가 멈춰도 사람도 모른 채 함께 정지 — 가장 비싼 "시간 낭비"**

<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.4em; margin: 0.5em 0; font-size: 0.82em;">

<div style="padding: 0.6em; background: #e6f4ff; border: 2px solid #4a80c0; border-radius: 8px; text-align: center;">
<div style="font-size: 0.85em; color: #4a80c0; font-weight: bold;">1단계 방어</div>
<div style="font-weight: bold; margin: 0.3em 0;">🛡️ 환경 명시</div>
<small>worktree 위치 / 빌드 상태 / DB 실행 / coredump 위치 → AI 에 미리 알려주기</small>
</div>

<div style="padding: 0.6em; background: #fff4e6; border: 2px solid #c08040; border-radius: 8px; text-align: center;">
<div style="font-size: 0.85em; color: #c08040; font-weight: bold;">2단계 방어</div>
<div style="font-weight: bold; margin: 0.3em 0;">⚡ Fail Fast (prerequisite)</div>
<small>Skill 앞단에서 branch 불일치·미빌드 즉시 중단 — 잘못된 환경에서 흘러간 토큰이 가장 비쌈</small>
</div>

<div style="padding: 0.6em; background: #ffe6e6; border: 2px solid #c04040; border-radius: 8px; text-align: center;">
<div style="font-size: 0.85em; color: #c04040; font-weight: bold;">3단계 방어</div>
<div style="font-weight: bold; margin: 0.3em 0;">⏱️ Timeout / Hang 방지</div>
<small>timeout 짧게 / "N분 경과 시 다른 방법" 지시 / iteration 상한 알림</small>
</div>

</div>

**더 나은 방식 모색 중**

- 세션 시작 hook, MCP 도구, 자동 복구(branch checkout / rebuild)
- 팀·본부 차원 **표준 prerequisite 라이브러리** 가 있으면 더 효과적

<!-- timing: 120 -->

---

# 모듈 분석서 필요

**개발 4팀 송일한님 사례 · CUBRID 모듈 코드 분석서**

<div style="display: grid; grid-template-columns: 1fr 1.2fr; gap: 1em; align-items: center;">

<div style="text-align: center;">
<svg width="100%" viewBox="0 0 500 280" style="max-height: 240px;">
  <line x1="250" y1="140" x2="120" y2="80" stroke="#aaa" stroke-width="1.5"/>
  <line x1="250" y1="140" x2="380" y2="80" stroke="#aaa" stroke-width="1.5"/>
  <line x1="250" y1="140" x2="100" y2="200" stroke="#aaa" stroke-width="1.5"/>
  <line x1="250" y1="140" x2="400" y2="200" stroke="#aaa" stroke-width="1.5"/>
  <line x1="250" y1="140" x2="180" y2="40" stroke="#aaa" stroke-width="1.5"/>
  <line x1="250" y1="140" x2="320" y2="40" stroke="#aaa" stroke-width="1.5"/>
  <line x1="250" y1="140" x2="220" y2="245" stroke="#aaa" stroke-width="1.5"/>
  <line x1="250" y1="140" x2="290" y2="245" stroke="#aaa" stroke-width="1.5"/>
  <line x1="120" y1="80" x2="180" y2="40" stroke="#bbb" stroke-width="1"/>
  <line x1="380" y1="80" x2="320" y2="40" stroke="#bbb" stroke-width="1"/>
  <line x1="100" y1="200" x2="220" y2="245" stroke="#bbb" stroke-width="1"/>
  <line x1="400" y1="200" x2="290" y2="245" stroke="#bbb" stroke-width="1"/>
  <line x1="120" y1="80" x2="100" y2="200" stroke="#bbb" stroke-width="1"/>
  <line x1="380" y1="80" x2="400" y2="200" stroke="#bbb" stroke-width="1"/>

  <circle cx="250" cy="140" r="26" fill="#2d4a8a"/>
  <text x="250" y="145" text-anchor="middle" fill="white" font-size="11" font-weight="bold">heap_file</text>

  <circle cx="120" cy="80" r="16" fill="#5a7fc0"/>
  <text x="120" y="84" text-anchor="middle" fill="white" font-size="9">btree</text>
  <circle cx="380" cy="80" r="16" fill="#5a7fc0"/>
  <text x="380" y="84" text-anchor="middle" fill="white" font-size="9">vacuum</text>
  <circle cx="100" cy="200" r="16" fill="#5a7fc0"/>
  <text x="100" y="204" text-anchor="middle" fill="white" font-size="9">page</text>
  <circle cx="400" cy="200" r="16" fill="#5a7fc0"/>
  <text x="400" y="204" text-anchor="middle" fill="white" font-size="9">log</text>

  <circle cx="180" cy="40" r="12" fill="#7ab57a"/>
  <text x="180" y="44" text-anchor="middle" fill="white" font-size="8">OOS</text>
  <circle cx="320" cy="40" r="12" fill="#7ab57a"/>
  <text x="320" y="44" text-anchor="middle" fill="white" font-size="8">MVCC</text>
  <circle cx="220" cy="248" r="12" fill="#7ab57a"/>
  <text x="220" y="252" text-anchor="middle" fill="white" font-size="8">DDL</text>
  <circle cx="290" cy="248" r="12" fill="#7ab57a"/>
  <text x="290" y="252" text-anchor="middle" fill="white" font-size="8">DML</text>
</svg>
<div style="font-size: 0.7em; color: #666;">graph view 시각화 (실제 데모는 아래 링크 참고)</div>
</div>

<div>

- 공개 데모: <https://xmilex-git.github.io/claude-obsidian/>
- Obsidian **graph view** 로 모듈·함수·개념을 양방향 링크
- AI 가 그래프 노드를 따라가며 **필요한 컨텍스트만 골라 읽음** → 분석 비용·토큰 절약
- 사람에게도 **인수인계 문서** — 1석 2조

<span class="qualifier">현재는 한 사람에 의존도 집중 — 조직 자산화 시 신규 입사자 온보딩 + AI 컨텍스트 동시 해결</span>

</div>

</div>


<!-- timing: 90 -->

---

# 업무 자동화 후보 — Git 흐름 영역

**아직 skill 화하지 못한 것 — 곧 가능해질 영역**

**① Git 일상 흐름 자동화**

- `git stage → add → commit → push` 한 번에 — 변경 분석으로 **커밋 메시지 자동 작성**
- 팀 컨벤션(prefix, JIRA 키, 영문/한글 요약)을 **자동 학습하여 일관된 메시지 품질**

**② Git Merge Conflict 해결 — 컨텍스트 기반**

- "develop 쪽 의도가 우선" / "특정 모듈은 feature 우선" 같은 **자연어 지시를 받아** AI 가 hunk 단위로 판단
- 단순 `--ours` / `--theirs` 보다 **세분화된 conflict 해결 정책** 적용 가능
- 충돌 패턴이 반복되면 skill 로 굳혀 매번 사람이 일일이 풀 필요 없어짐

> gh CLI / JIRA REST API 연동은 **이미 성공담 (Part 3 참조)** — Git 영역만 남은 셈

<!-- timing: 60 -->

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

# 발표자의 CUBRID 전용 skill 모음 — 실제 사례

**`vimkim/my-cubrid-skills`** — CUBRID 작업에 특화된 개인 skill 저장소
<https://github.com/vimkim/my-cubrid-skills>

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5em; text-align: left; margin-top: 0.6em;">

<div>

**`/jira CBRD-12345`**

- CUBRID JIRA 이슈를 한 줄로 fetch
- REST API + pandoc 으로 본문/코멘트/링크 이슈를 마크다운 변환
- AI 가 즉시 컨텍스트로 활용 가능

</div>

<div>

**`/cubrid-pr-create`**

- 현재 브랜치 변경사항 분석 → **draft PR 자동 생성**
- `[CBRD-XXXXX]` 제목 컨벤션 + 한국어 본문 + 영어 섹션 헤더
- 팀 PR 규칙을 skill 한 곳에 박제

</div>

</div>

<span class="qualifier">"남이 대신 만들어 줄 수 없는 부분" 의 실제 예시 — CUBRID 팀 컨벤션은 본인이 만들어야 함</span>

<!-- timing: 75 -->

---

# 자동화 자동화 — skill → script → plugin

**4단계 진화 — 시행착오 자체를 자산으로**

<div style="display: grid; grid-template-columns: repeat(7, auto); gap: 0.3em; align-items: center; justify-content: center; font-size: 0.78em; margin: 0.5em 0;">

<div style="padding: 0.4em 0.6em; background: #ffe6e6; border: 1px solid #c66; border-radius: 6px; text-align: center;"><b>① 첫 시도</b><br><small>시행착오·고비용</small></div>
<div style="color: #999; font-size: 1.1em;">→</div>

<div style="padding: 0.4em 0.6em; background: #fff5e6; border: 1px solid #c96; border-radius: 6px; text-align: center;"><b>② Skill 등록</b><br><small><code>/learner</code> → <code>/skill-creator</code></small></div>
<div style="color: #999; font-size: 1.1em;">→</div>

<div style="padding: 0.4em 0.6em; background: #fffbe6; border: 1px solid #cc6; border-radius: 6px; text-align: center;"><b>③ Script 화</b><br><small>결정론적 실행<br>AI 호출 없이 OK</small></div>
<div style="color: #999; font-size: 1.1em;">→</div>

<div style="padding: 0.4em 0.6em; background: #e6ffe6; border: 1px solid #6c6; border-radius: 6px; text-align: center;"><b>④ Plugin 배포</b><br><small>개인 → 팀 → 본부</small></div>

</div>

<div style="text-align: center; color: #888; font-size: 0.85em;">→ 토큰 ↓ · 속도 ↑ · 재현성 ↑</div>

**왜 게임체인저인가**

- 첫 시도 비용을 **미래의 모든 반복에 분할 상환**
- "어떻게 하라" 가 아닌 **"무엇을 원한다"** 만 말해도 AI 가 절차 저장
- 팀 단위 공유 시 **"한 사람이 뚫은 길" 을 팀 전체가 빠르게**
- **장기 제안**: 플러그인 운영 자체를 공식 업무로 추가하면 자산이 축적됨

<span class="qualifier">"자동화하는 작업을 자동화" — 한 번 익히면 평생 재산</span>

<!-- timing: 120 -->

---

# 결론 — 마차에서 자율주행까지

**두 가지 자세를 동시에 가져갈 것**

- **지금 가능한 것은 최대한 자동화** — AI 로 풀리는 영역에 빨리 익숙해지기
- **불편한 영역은 곧 풀린다** — 사람이 시간과 노력을 들이면 자동화 가능 영역으로 편입됨

<br>

> **"마차에서 자동차로 변화했듯이, 개발자에게는 Claude Code Max 가 역사적인 전환입니다.<br>
> 말을 끌고 다니다가 한 번에 자율주행까지 도달한 느낌입니다."**
>
> — 익명의 rhg 님

<br>

<span class="qualifier">변화는 이미 일어나고 있고, 우리가 할 일은 마부가 아니라 운전자가 되는 것</span>

<!-- timing: 60 -->

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
