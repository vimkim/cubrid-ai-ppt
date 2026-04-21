# RALPLAN: Claude Code 1개월 현황 보고 발표 자료 제작

**Plan ID:** ralplan-claude-code-intro-presentation-v1
**Created:** 2026-04-20
**Spec:** `.omc/specs/deep-interview-claude-code-intro-presentation.md`
**Deadline:** 2026-04-29 (Wed)
**Working Dir:** `/home/vimkim/temp/cubrid-ai-ppt/`

---

## RALPLAN-DR Summary

### Principles (5)

1. **정직한 70:30 톤** — 장점 advocacy를 하되, 한계/주의점을 솔직히 다루어 신뢰 확보
2. **개발자 친화 git-관리 가능한 포맷** — 슬라이드를 Markdown+git으로 관리, diff/review 가능
3. **라이브 리스크 제로** — 모든 데모는 사전 녹화, 발표장에서 네트워크/API 의존 없음
4. **CUBRID 현실 기반 에피소드** — 일반적 AI 도구 설명이 아닌 실제 CUBRID C/C++ 코드베이스에서의 1인칭 경험
5. **최소 도구 체인** — 제작 기간 1주일에 맞게 학습 부담 최소화, 검증된 도구만 사용

### Decision Drivers (Top 3)

1. **환경 호환성**: Rocky Linux 9.6, tty+X11 forwarding, no desktop environment, Puppeteer deps 존재, ffmpeg 미설치
2. **재현성과 속도**: 데모를 빠르게 재녹화할 수 있어야 하고, 슬라이드를 CLI 한 줄로 빌드 가능해야 함
3. **공유 용이성**: 최종 결과물이 PDF 또는 HTML single-file로 오프라인 발표 + 이메일 배포 가능해야 함

### Viable Options

#### Slide Tool

| | **Marp** | **Slidev** |
|---|---|---|
| Format | Markdown -> PDF/PPTX/HTML | Markdown+Vue -> SPA |
| Git-friendly | Excellent (pure MD) | Good (MD + config) |
| Install | `npm i @marp-team/marp-cli` | `npm i slidev` |
| PDF export | Built-in (Puppeteer, deps OK) | Requires Playwright |
| Code highlight | Prism, good | Shiki, excellent |
| GIF/video embed | HTML `<img>` in MD, works | Native, excellent |
| Theme quality | Clean but minimal | Modern, polished |
| Learning curve | Near zero (already MD) | Medium (Vue concepts) |
| Offline delivery | PDF or single HTML | Build to SPA, heavier |
| 16:9 + big fonts | `theme: default` + CSS | Built-in layouts |
| Risk | Low: simple, stable | Medium: heavier deps, Playwright for PDF |

**Invalidated alternatives:**
- **Reveal.js**: Requires more manual HTML scaffolding than Marp/Slidev for same result. No advantage for this use case.
- **Keynote**: macOS only. Presenter is on Rocky Linux.
- **Google Slides**: Not git-manageable, no CLI build, requires browser + Google account in presentation environment. Counter to Principle 2.

**Decision: Marp**
- Rationale: Near-zero learning curve, pure Markdown, CLI PDF export works on this system (Puppeteer deps confirmed), git-diffable, produces PDF for offline projector use. The 1-week timeline makes Marp's simplicity decisive over Slidev's polish. GIF embedding via HTML img tags is sufficient for pre-recorded demos.

#### Demo Recording Tool

| | **vhs (Charm)** | **asciinema + svg-term/agg** |
|---|---|---|
| Install | `go install` (Go 1.24 available) | `pip install` + separate renderer |
| Deterministic | Excellent: `.tape` script, re-run identical | Good: record live, replay from `.cast` |
| Output format | GIF directly | `.cast` -> SVG/GIF via `agg` or `svg-term` |
| Re-record speed | Edit `.tape`, re-run | Must re-do live recording |
| ffmpeg needed? | Yes, bundled or required | `agg` needs ffmpeg for GIF |
| Terminal fidelity | Pixel-perfect GIF | SVG: perfect; GIF via agg: good |
| Typing simulation | Built-in (`Type`, `Sleep`) | Must type live or use `pv` |

**Invalidated alternatives:**
- **terminalizer**: npm package, last maintained 2022, rendering issues on newer Node. Risk too high for 1-week timeline.
- **OBS Studio**: Requires desktop environment / display server. Not available on this tty-only Rocky Linux box.
- **macOS screen recording**: Not macOS.
- **ttygif**: Depends on `ttyrec` which is unmaintained; output quality inferior.

**Primary: vhs (Charm)**
- Rationale: Deterministic `.tape` scripts mean demos can be re-recorded with one command when Claude Code UI changes. Go is available (1.24.4). Produces GIF directly. Scripts are version-controllable.
- **Note:** vhs requires ffmpeg. Since ffmpeg is not installed, the executor must install it (`sudo dnf install ffmpeg-free` on Rocky 9, or build from source / use a static binary).

**Fallback: asciinema + agg**
- Rationale: If vhs/ffmpeg installation is blocked (no sudo, repo issues), asciinema can record `.cast` files and `agg` (Rust-based, static binary available) can render them to GIF without ffmpeg. Lower determinism (must type live or script with `expect`), but zero native dependency issues.

---

## Section 1: Tool Decisions (Final)

### Slide Tool: **Marp** (`@marp-team/marp-cli`)

- Install: `npm install --save-dev @marp-team/marp-cli`
- Build PDF: `npx marp slides/main.md --pdf --allow-local-files`
- Build HTML: `npx marp slides/main.md --html --allow-local-files`
- Theme: Custom CSS extending `default`, tuned for 16:9 projector (36px+ body font, high contrast)
- Korean: Noto Sans CJK already installed on system

### Demo Recording: **vhs** (primary) + **asciinema+agg** (fallback)

- Install vhs: `go install github.com/charmbracelet/vhs@latest`
- Install ffmpeg: `sudo dnf install -y ffmpeg-free` (or static binary if no sudo)
- Usage: Write `.tape` files, run `vhs record episode-name.tape`
- Fallback: `pip install asciinema`, download `agg` static binary

---

## Section 2: Concrete Use-Case Episodes (3 Areas x 3 Each)

### Area 1: 대규모 코드베이스 탐색/이해

#### Episode 1-1: heap_file.c 레코드 흐름 파악
- **Scenario**: OOS 기능 개발 중, `heap_insert_logical` 에서 `heap_insert_physical`까지의 레코드 삽입 흐름을 이해해야 했음
- **Before**: `grep -rn`, cscope/ctags로 함수 호출 체인 수동 추적. heap_file.c가 15,000줄+ 이라 맥락 파악에 반나절 소요
- **After**: Claude Code에 "heap_insert_logical에서 디스크에 쓰이기까지의 전체 흐름을 설명해줘" 요청 -> 10분 내에 함수 호출 체인 + 각 단계의 역할 요약 획득
- **Artifact**: 터미널 GIF (Claude Code가 파일을 탐색하며 설명하는 과정) + 결과 요약 텍스트 슬라이드
- **Honesty note**: N/A (success case)

#### Episode 1-2: JIRA 이슈 + PR 체인 이해
- **Scenario**: CBRD-XXXXX 이슈가 할당됨. 관련 PR이 3개 링크되어 있고, 각 PR의 변경 범위를 파악해야 했음
- **Before**: JIRA 웹 -> PR 링크 클릭 -> GitHub에서 각 PR의 Files Changed 탭 수동 확인. 컨텍스트 스위칭 반복
- **After**: Claude Code에서 `/jira CBRD-XXXXX` + `gh pr view` 조합으로 이슈 내용과 PR diff를 한 세션에서 파악. "이 3개 PR의 변경 사항을 요약해줘" 한 줄로 전체 그림 획득
- **Artifact**: 스크린샷 또는 GIF (Claude Code 세션에서 JIRA+PR을 탐색하는 모습)
- **Honesty note**: N/A

#### Episode 1-3: 낯선 서브시스템 이해 (MVCC / Recovery)
- **Scenario**: OOS가 MVCC vacuum과 상호작용하는 부분을 이해해야 했으나, vacuum 코드를 처음 봄
- **Before**: vacuum.c 소스 + 내부 위키 문서를 교차 참조하며 수일간 학습
- **After**: Claude Code에 코드베이스를 읽히고 "vacuum이 OOS 레코드를 어떻게 처리하는지 설명해줘" 요청. 관련 함수들을 찾아 흐름도 수준의 설명 제공
- **Artifact**: Claude Code 출력 텍스트를 정리한 다이어그램/플로우 슬라이드
- **Honesty note (LIMITATION)**: Claude Code가 CUBRID 특유의 MVCC 구현 디테일을 일부 잘못 설명한 경우 있음 (예: vacuum_data 구조체 필드 해석 오류). **반드시 코드로 교차 검증 필요** -- 환각 사례로 발표에 포함

### Area 2: 실제 개발 작업

#### Episode 2-1: isolation test (.ctl) 작성
- **Scenario**: OOS insert/delete의 동시성 테스트를 위한 .ctl 격리 테스트 파일을 새로 작성해야 했음
- **Before**: 기존 .ctl 파일을 복사해서 수정. .ctl 문법이 독특해서 시행착오 반복
- **After**: Claude Code에 기존 .ctl 파일 패턴을 학습시킨 뒤 "OOS insert와 delete가 동시에 실행되는 격리 테스트를 작성해줘" 요청. 80% 완성된 초안 즉시 획득, 미세 조정만 수행
- **Artifact**: 코드 diff (생성된 .ctl 파일) 슬라이드
- **Honesty note**: N/A

#### Episode 2-2: CI shell-test 실패 분석 및 수정
- **Scenario**: PR merge 후 CI에서 shell test 3건 실패. 실패 로그가 길고 원인이 불명확
- **Before**: CI 로그를 수동으로 다운로드, expected/actual answer 파일을 diff, 로컬에서 재현 시도. 2~3시간 소요
- **After**: Claude Code에 실패 로그와 테스트 스크립트를 읽히고 "왜 실패했는지 분석하고 수정안을 제시해줘" 요청. 근본 원인(answer 파일의 OID 형식 변경)을 15분 내 파악
- **Artifact**: 터미널 GIF (Claude Code가 CI 로그를 분석하는 과정)
- **Honesty note**: N/A

#### Episode 2-3: 헬퍼 함수 작성 + 단위 테스트
- **Scenario**: OOS 레코드의 크기 계산 헬퍼 함수를 새로 작성하고, 단위 테스트도 함께 필요
- **Before**: 함수 작성 -> 빌드 -> 테스트 코드 작성 -> 빌드 -> 실행 -> 디버깅 사이클을 수동 반복
- **After**: Claude Code에 기존 유사 함수와 테스트 패턴을 보여주고 "이 패턴으로 oos_record_size 함수와 테스트를 작성해줘" 요청. 함수+테스트 동시 생성, 빌드 오류도 자동 수정 시도
- **Artifact**: 코드 diff (함수 + 테스트) 슬라이드
- **Honesty note (LIMITATION -- subtle)**: Claude Code가 생성한 테스트가 edge case를 놓치는 경우 있음 -- 개발자 검토는 필수라는 점을 언급

### Area 3: 문서/커뮤니케이션

#### Episode 3-1: JIRA 이슈 / PR description 작성
- **Scenario**: OOS 기능의 새 JIRA 이슈를 작성해야 함. 팀 컨벤션: 본문 한국어, 섹션 헤더 영어
- **Before**: 기존 이슈를 참고하며 수동 작성. 기술적 맥락 설명에 30분+ 소요
- **After**: Claude Code에 변경 코드 범위를 보여주고 "이 변경에 대한 JIRA 이슈를 팀 컨벤션에 맞춰 작성해줘" 요청. 5분 내 초안 완성
- **Artifact**: JIRA 이슈 텍스트 before/after 비교 슬라이드 (실제 형식 보여줌)
- **Honesty note**: N/A

#### Episode 3-2: Greptile 봇 리뷰 코멘트 응답
- **Scenario**: PR에 Greptile 봇이 리뷰 코멘트 10개를 남김. 각각에 대해 수용/반박 응답 필요
- **Before**: 각 코멘트를 읽고 코드를 확인하며 하나씩 응답 작성. 코멘트당 5~10분
- **After**: Claude Code에 PR diff와 Greptile 코멘트를 읽히고 "각 코멘트에 대한 응답 초안을 작성해줘" 요청. 10개 응답 초안을 10분 내 획득, 수정 후 게시
- **Artifact**: PR 코멘트 스레드 스크린샷 또는 재현 슬라이드
- **Honesty note**: N/A

#### Episode 3-3: 조사 노트를 내부 문서로 변환
- **Scenario**: OOS 설계 조사 중 축적된 메모(코드 스니펫, 함수 관계, 의문점)를 팀 공유용 내부 문서로 정리
- **Before**: 메모를 처음부터 다시 구조화. 문서 작성에 반나절 소요
- **After**: Claude Code에 메모 파일을 읽히고 "이것을 팀이 읽을 수 있는 기술 문서로 정리해줘. 한국어, 섹션 헤더는 영어" 요청. 구조화된 문서 초안 20분 내 완성
- **Artifact**: 문서 before(메모) / after(정리된 문서) 비교 슬라이드
- **Honesty note (LIMITATION)**: Claude Code가 정리 과정에서 원본 메모에 없는 내용을 "보충"하는 경우 있음 -- 팩트체크 필수

---

## Section 3: Slide-by-Slide Outline (30 slides, ~1440 sec = 24 min)

| # | Title (Korean) | Purpose | Key Visual/Content | Timing (sec) | Demo? |
|---|---|---|---|---|---|
| 1 | Claude Code 1개월 사용 현황 보고 | 표지 | 제목, 발표자(김대현), 소속(AI TFT / 개발2팀), 날짜 | 10 | |
| 2 | 이 발표는... / 이 발표는 아닙니다 | 기대치 설정 | 2열: "O: 1인칭 경험 공유, 한계 포함" vs "X: AI 만능 홍보, 핸즈온" | 40 | |
| 3 | 왜 이 자리에 섰나 | 배경 맥락 | 팀장/전무 요청, AI TFT 역할 한 줄, "개발자로서 한 달간 써본 이야기" | 40 | |
| 4 | Claude Code란? (1분 개요) | 모르는 분을 위한 최소 맥락 | 터미널 기반 AI 코딩 어시스턴트, Anthropic, Max 플랜 구조 다이어그램 | 60 | |
| 5 | 오늘의 세 가지 이야기 | 구조 안내 (Part 1/2/3 미리보기) | 3개 아이콘 + 영역 이름: 탐색, 개발, 문서 | 30 | |
| 6 | **Part 1: 코드베이스 탐색** -- 타이틀 | 섹션 구분자 | 큰 텍스트 + 아이콘 | 5 | |
| 7 | heap_file.c 레코드 흐름 파악 | Episode 1-1 | Before: grep+cscope 반나절 / After: 10분 요약. 핵심 함수 체인 그래프 | 80 | |
| 8 | [데모] 코드 탐색 실제 모습 | Episode 1-1 데모 | GIF: Claude Code가 heap_file.c를 탐색하며 설명하는 30~45초 녹화 | 60 | YES |
| 9 | JIRA + PR 체인 한 번에 파악 | Episode 1-2 | Before: 브라우저 탭 5개 / After: 한 세션에서 요약. 스크린샷 | 70 | |
| 10 | 낯선 서브시스템 이해 (MVCC) | Episode 1-3 | Before/After + Claude Code 출력 예시 텍스트 | 60 | |
| 11 | 탐색 영역 -- 그런데 이런 일도 있었다 | 한계/환각 사례 | Episode 1-3 환각 사례: vacuum_data 필드 오해석. "반드시 교차 검증" 메시지 | 50 | |
| 12 | **Part 2: 실제 개발 작업** -- 타이틀 | 섹션 구분자 | 큰 텍스트 + 아이콘 | 5 | |
| 13 | isolation test (.ctl) 작성 | Episode 2-1 | Before: 복사+수정 시행착오 / After: 80% 초안 즉시. 코드 diff 하이라이트 | 70 | |
| 14 | CI shell-test 실패 분석 | Episode 2-2 | Before: 로그 수동 분석 2~3h / After: 15분 근본 원인 파악. 분석 흐름 요약 | 70 | |
| 15 | [데모] CI 실패 분석 실제 모습 | Episode 2-2 데모 | GIF: Claude Code가 실패 로그를 읽고 원인을 짚어내는 30~45초 녹화 | 60 | YES |
| 16 | 헬퍼 함수 + 테스트 동시 작성 | Episode 2-3 | Before: 수동 사이클 / After: 함수+테스트 동시 생성. 코드 diff 하이라이트 | 60 | |
| 17 | 개발 영역 -- 주의할 점 | Episode 2-3 한계 | 생성 코드의 edge case 누락 사례. "개발자 검토 필수" | 40 | |
| 18 | **Part 3: 문서/커뮤니케이션** -- 타이틀 | 섹션 구분자 | 큰 텍스트 + 아이콘 | 5 | |
| 19 | JIRA 이슈 / PR description 작성 | Episode 3-1 | Before/After: 실제 JIRA 이슈 형식 비교. 팀 컨벤션 준수 강조 | 70 | |
| 20 | [데모] JIRA 이슈 작성 실제 모습 | Episode 3-1 데모 | GIF: Claude Code가 코드를 보고 JIRA 이슈를 생성하는 30~45초 녹화 | 60 | YES |
| 21 | Greptile 봇 리뷰 응답 일괄 처리 | Episode 3-2 | Before: 코멘트당 5~10분 / After: 10개 응답 10분. PR 스레드 스크린샷 | 60 | |
| 22 | 조사 노트 -> 내부 문서 변환 | Episode 3-3 | Before(메모) / After(정리 문서) 비교 | 50 | |
| 23 | 문서 영역 -- 주의할 점 | Episode 3-3 한계 | "보충" 환각: 원본에 없는 내용 추가 사례. 팩트체크 필수 | 40 | |
| 24 | 종합: 한계와 주의점 | 정직한 균형 정리 | 4개 항목: 환각, 컨텍스트 크기 한계, 보안/IP 주의, 비용 | 70 | |
| 25 | 환각에 대한 개인적 원칙 | 깊이 있는 한계 논의 | "AI 출력은 초안이다. 검증은 개발자의 몫." 개인 원칙 3줄 | 50 | |
| 26 | 시작하려면 (Getting Started) | 실용 가이드 | 라이센스 취득 방법, 설치 명령, 최소 설정 | 60 | |
| 27 | 처음 써볼 때 이 세 가지부터 | 첫 시도 유용 명령/기능 | 1. 코드베이스 질문 2. 테스트 작성 요청 3. 문서 초안 요청 | 50 | |
| 28 | 한 달 사용자의 팁 | 실용 조언 | 3~4개 짧은 팁: CLAUDE.md 작성, 컨텍스트 관리, 검증 습관 등 | 50 | |
| 29 | Q&A | 질의응답 | "질문 있으신가요?" + 발표자 연락처 | 10 | |
| 30 | FAQ (백업) | Q&A 대비 | 예상 질문 5~7개 + 짧은 답변 (보안? 비용? 기존 도구와 차이?) | (백업) | |

**Total speaking time: ~1440 sec = 24 min** (Q&A 10min 별도, 전체 34min)

**Demo slides: 3개** (슬라이드 #8, #15, #20), 각 30~45초 GIF

---

## Section 4: Repo Layout

```
/home/vimkim/temp/cubrid-ai-ppt/
├── README.md                    # 프로젝트 개요, 빌드 방법
├── package.json                 # marp-cli dev dependency
├── marp.config.mjs              # Marp 설정 (theme, html: true)
├── slides/
│   ├── main.md                  # 전체 슬라이드 (Marp single-file)
│   └── theme/
│       └── cubrid-theme.css     # 커스텀 테마 (16:9, 큰 폰트, 고대비)
├── assets/
│   ├── demos/                   # 사전 녹화 데모 GIF
│   │   ├── ep1-1-heap-navigation.gif
│   │   ├── ep2-2-ci-failure-analysis.gif
│   │   └── ep3-1-jira-writing.gif
│   ├── images/                  # 스크린샷, 다이어그램
│   │   ├── claude-code-overview.png
│   │   ├── before-after-*.png
│   │   └── ...
│   └── tapes/                   # vhs .tape 스크립트 (데모 재현용)
│       ├── ep1-1-heap-navigation.tape
│       ├── ep2-2-ci-failure-analysis.tape
│       └── ep3-1-jira-writing.tape
├── scripts/
│   ├── build.sh                 # marp 빌드 (PDF + HTML)
│   └── record-demos.sh          # 전체 데모 일괄 녹화
├── output/                      # 빌드 결과물 (.gitignore)
│   ├── presentation.pdf
│   └── presentation.html
├── rehearsal/
│   └── notes.md                 # 리허설 메모, 타이밍 기록
├── .omc/                        # OMC 작업 상태 (기존)
└── .gitignore                   # output/, node_modules/
```

---

## Section 5: Production Order & Parallelization

### Phase 0: 프로젝트 스캐폴딩 (Day 1 AM, ~1h)
- [ ] `npm init -y` + `npm install --save-dev @marp-team/marp-cli`
- [ ] 디렉토리 구조 생성 (`slides/`, `assets/demos/`, `assets/images/`, `assets/tapes/`, `scripts/`, `output/`, `rehearsal/`)
- [ ] `.gitignore` 작성 (`output/`, `node_modules/`)
- [ ] `marp.config.mjs` 기본 설정 (html: true, theme 경로)
- [ ] `cubrid-theme.css` 초안 (16:9, Noto Sans CJK, 36px+ body, 고대비 색상)
- [ ] `scripts/build.sh` 작성
- [ ] vhs 설치 (`go install github.com/charmbracelet/vhs@latest`)
- [ ] ffmpeg 설치 확인/설치
- **Acceptance**: `npx marp slides/main.md --pdf` 가 빈 슬라이드라도 PDF를 생성함. `vhs --version` 실행됨.

### Phase 1: 슬라이드 초안 -- 전체 구조 (Day 1 PM ~ Day 2, ~3h)
- [ ] `slides/main.md` 에 30장 슬라이드 골격 작성 (제목 + 1~2줄 placeholder)
- [ ] 표지(#1), 기대치 설정(#2), 배경(#3), Claude Code 개요(#4), 구조 안내(#5) 내용 채움
- [ ] 한계/주의점(#24~25), Getting Started(#26~28), Q&A/FAQ(#29~30) 내용 채움
- **Acceptance**: PDF 빌드 시 30장 슬라이드가 모두 렌더링됨. 앞뒤 프레임 슬라이드(비에피소드)는 내용 완성.

### Phase 2: Area 1 슬라이드 + 데모 (Day 2~3, ~4h)
- [ ] Episode 1-1, 1-2, 1-3 슬라이드 내용 작성 (#7, #9, #10)
- [ ] 한계 슬라이드 (#11) 환각 사례 구체 서술
- [ ] `assets/tapes/ep1-1-heap-navigation.tape` 작성 (vhs 스크립트)
- [ ] 데모 GIF 녹화 및 `assets/demos/` 저장
- [ ] 데모 슬라이드 (#8)에 GIF 임베드
- **Parallelizable**: tape 스크립트 작성과 슬라이드 텍스트 작성은 동시 진행 가능
- **Acceptance**: #6~#11 슬라이드가 내용과 데모 GIF 포함하여 렌더링됨

### Phase 3: Area 2 슬라이드 + 데모 (Day 3~4, ~4h)
- [ ] Episode 2-1, 2-2, 2-3 슬라이드 내용 작성 (#13, #14, #16)
- [ ] 주의점 슬라이드 (#17) 내용 작성
- [ ] `assets/tapes/ep2-2-ci-failure-analysis.tape` 작성
- [ ] 데모 GIF 녹화 및 저장
- [ ] 데모 슬라이드 (#15)에 GIF 임베드
- **Parallelizable**: Phase 2와 Phase 3은 독립적이므로 동시 진행 가능 (다만 autopilot 단일 에이전트면 순차)
- **Acceptance**: #12~#17 슬라이드 완성

### Phase 4: Area 3 슬라이드 + 데모 (Day 4~5, ~4h)
- [ ] Episode 3-1, 3-2, 3-3 슬라이드 내용 작성 (#19, #21, #22)
- [ ] 주의점 슬라이드 (#23) 내용 작성
- [ ] `assets/tapes/ep3-1-jira-writing.tape` 작성
- [ ] 데모 GIF 녹화 및 저장
- [ ] 데모 슬라이드 (#20)에 GIF 임베드
- **Parallelizable**: Phase 3과 Phase 4도 독립적
- **Acceptance**: #18~#23 슬라이드 완성

### Phase 5: 테마 다듬기 + 전체 통합 (Day 5~6, ~2h)
- [ ] CSS 테마 최종 조정 (폰트 크기, 색상, 코드 블록 스타일)
- [ ] 전체 슬라이드 PDF 빌드 + 육안 검수
- [ ] 슬라이드 간 흐름/전환 확인
- [ ] 오탈자, 어색한 표현 수정
- [ ] 부록 슬라이드 (#30 FAQ) 내용 보강
- **Acceptance**: 30장 전체가 고대비, 큰 폰트로 렌더링되고, GIF가 정상 표시됨

### Phase 6: 리허설 패스 (Day 6~7, ~1.5h)
- [ ] 전체 슬라이드를 순서대로 넘기며 speaking 시뮬레이션
- [ ] 각 슬라이드 실제 소요 시간 기록 -> `rehearsal/notes.md`
- [ ] 전체 24분 내 맞는지 확인, 초과 시 슬라이드 축소 또는 내용 압축
- [ ] Q&A 예상 질문 목록 검토 및 FAQ 슬라이드 업데이트
- [ ] 최종 PDF 빌드
- **Acceptance**: 타이밍이 20~25분 범위 내. `rehearsal/notes.md`에 슬라이드별 타이밍 기록 존재. 최종 PDF가 `output/presentation.pdf`에 생성됨.

### Parallelization Map

```
Day 1:  [===P0===] [====P1 (start)====]
Day 2:  [====P1 (finish)====] [===P2 (start)===]
Day 3:  [=========P2 (finish)=========]  -- or P2+P3 parallel if 2 agents
Day 4:  [=========P3===========]
Day 5:  [=========P4===========]
Day 6:  [====P5====]
Day 7:  [====P6 (rehearsal)====]  -> DONE by Wed
```

**Autopilot single-agent note**: Phases 2/3/4 are independent in content but share the same `main.md` file, so a single autopilot agent should run them sequentially. Within each phase, tape script writing and slide text writing can be interleaved (write tape -> record -> embed, then next episode).

---

## Section 6: Guardrails

### Must Have
- 모든 슬라이드 한국어 (영어 기술 용어는 그대로)
- 1인칭 경험담 톤
- 장단점 비율 ~70:30 (에피소드 9개 중 한계 언급 최소 3회)
- 사전 녹화 데모 3개 (GIF)
- PDF 오프라인 발표 가능
- 16:9, 큰 폰트(36px+ body), 고대비
- Getting Started 섹션 포함
- FAQ 백업 슬라이드 포함

### Must NOT Have
- 라이브 Claude Code 세션
- OMC/agent orchestration 메타 워크 언급
- Copilot/Cursor/Codex 공격적 비교
- 근거 없는 생산성 수치 (예: "10x 빨라짐")
- AI가 대필한 일반론 느낌의 문장

---

## ADR (Architectural Decision Record)

### Decision
Marp (Markdown Presentation Ecosystem) + vhs (Charm) 조합으로 슬라이드+데모 제작

### Drivers
1. 1주일 제작 기간에 학습 곡선 최소화 필요
2. Rocky Linux tty 환경에서 CLI 기반 빌드 필수
3. PDF 오프라인 배포 + git 버전 관리 동시 충족

### Alternatives Considered
- **Slidev**: 더 세련된 UI, 코드 하이라이트 우수. But: Playwright PDF export 불안정, Vue 학습 비용, 이 환경에서 테스트 부족. 타임라인 리스크가 Marp 대비 높음.
- **Google Slides**: 협업 쉬움. But: git 관리 불가, CLI 빌드 불가, Markdown 아님. Principle 2 위반.
- **asciinema (demo)**: 라이브 녹화 방식이라 재현성 낮음. vhs의 `.tape` 스크립트가 결정적 우위.

### Why Chosen
Marp는 "Markdown -> PDF" 파이프라인이 가장 단순하고, 이 시스템에서 Puppeteer PDF export가 작동함을 확인함 (deps 전부 설치됨). vhs는 Go로 설치 가능하고 `.tape` 파일로 데모를 재현할 수 있어 CI 실패 시나리오 등도 스크립트로 관리 가능.

### Consequences
- (+) 슬라이드가 single `.md` 파일이므로 autopilot agent가 편집하기 쉬움
- (+) PDF 생성이 `npx marp` 한 줄
- (-) Marp 테마 커스터마이징은 raw CSS, 디자인 폴리시에 한계
- (-) GIF 파일 크기가 클 수 있음 (30초 GIF ~5~15MB). PDF 크기 주의 필요

### Follow-ups
- ffmpeg 설치 가능 여부 확인 (sudo 권한 필요, 없으면 static binary)
- vhs가 이 환경의 터미널에서 정상 녹화되는지 Phase 0에서 즉시 검증
- GIF 크기가 과도하면 gifsicle로 최적화하거나 slide를 HTML로 전환하여 video embed 고려

---

## Open Questions

아래 항목은 `.omc/plans/open-questions.md`에도 기록됨.

1. **ffmpeg 설치 권한**: `sudo dnf install ffmpeg-free` 가능한가? 불가 시 static binary 경로 필요
2. **vhs 터미널 호환성**: tty+X11 forwarding 환경에서 vhs가 가상 터미널을 생성할 수 있는가? (Phase 0에서 즉시 테스트)
3. **실제 CUBRID 코드베이스 접근**: 데모 녹화 시 실제 CUBRID 소스가 필요. 발표자의 CUBRID worktree 경로는?
4. **에피소드 실제 경험 검증**: 9개 에피소드가 발표자의 실제 경험에 기반하는지, 아니면 "있을 법한" 시나리오인지 -- 발표자 확인 필요
5. **PDF 크기 제한**: 3개 GIF 임베드 시 PDF 크기가 이메일 첨부 한도(보통 25MB)를 초과할 가능성 -- Phase 5에서 확인
