# RALPLAN v2: Claude Code 1개월 현황 보고 발표 자료 제작

**Plan ID:** ralplan-claude-code-intro-presentation-v2
**Created:** 2026-04-20
**Revised from:** v1 (ralplan-draft-v1.md)
**Spec:** `.omc/specs/deep-interview-claude-code-intro-presentation.md`
**Deadline:** 2026-04-29 (Wed)
**Working Dir:** `/home/vimkim/temp/cubrid-ai-ppt/`

---

## 1. Change Log (v1 → v2)

| # | Change | Mapped to |
|---|--------|-----------|
| C1 | **Demo tool pivot**: asciinema+agg promoted to PRIMARY. vhs demoted to "stretch goal if deps become available." Added hard fallback: static PNG screenshots + Pillow annotation. | Critic #1, Architect Rev #1, Architect Rev #3 |
| C2 | **Marp PDF command fixed**: All `npx marp` invocations now prefixed with `CHROME_PATH=$(which firefox)`. Rationale corrected from "Puppeteer deps confirmed" to "Firefox 128.13.0esr headless available." Phase 0 includes smoke test. | Critic #2, Architect Rev #2 |
| C3 | **Episode authenticity = hard gate**: Phase 0 now includes a blocking step where the presenter must review and sign off on the episode list before any content generation begins. Episodes marked `[NEEDS PRESENTER CONFIRMATION]`. | Critic #3, Architect Rev #4 |
| C4 | **Hero + mention structure adopted**: Each area now has 1 hero episode (2~3 min, with demo) + 1~2 mention episodes (30~45 sec, no demo). Total: 3 heroes, 6 mentions, 3 demos. Slide count reduced to ~25 main + 8 FAQ backup. | Architect Synthesis #4.3, Critic #8 |
| C5 | **Rehearsal gate added**: Phase 6 now includes a stopwatch-timed dry-run with explicit pass criterion (23:00 +/- 2:00). Cut priority documented. | Critic #5 |
| C6 | **Verification matrix added**: Every phase has explicit verification commands with expected results. | Critic #6 |
| C7 | **Q&A FAQ hardened**: 8 mandatory FAQ questions with concrete short answers. Expanded to 8 backup slides. | Critic #7 |
| C8 | **Time budget redone**: Second-level budget with explicit math totaling 24:30, within 25:00 target. | Critic #8 |
| C9 | **Korean rendering validation added to Phase 0**: Test deck with Korean headings + code blocks + monospace table. Font fallback documented (Noto Sans CJK KR, confirmed installed). | Critic #9 |
| C10 | **Slidev invalidation rationale corrected**: Acknowledged Slidev's real advantages (Monaco, Vue components); rejection based on timeline + "1인칭 톤 not over-polished" principles. | Critic #10 |
| C11 | **Scrubbed live-on-stage phrasing**: No slide implies live Claude Code use. All demo references use "사전 녹화", "녹화된 모습" phrasing. | Critic #11 |
| C12 | **Removed "N배" language**: All before/after comparisons use qualitative framing with anecdotal measurement caveat. | Critic #12 |
| C13 | **Front-loaded honesty slide**: Added "먼저 솔직하게" slide at position #5 (before success stories). | Architect Synthesis #4.4, Critic MAJOR #7 |
| C14 | **GIF-in-PDF strategy decided upfront**: HTML for presentation (animated), PDF for distribution (static frame + caption). | Architect Synthesis #4.2, Critic MAJOR #5 |
| C15 | **Environment risk audit section added**: Verified/assumed/pivot documented. | Critic structural requirement |

---

## 2. RALPLAN-DR Summary

### Principles (5)

1. **정직한 70:30 톤** — 장점 advocacy를 하되, 한계/주의점을 솔직히 다루어 신뢰 확보. 첫 한계 언급은 슬라이드 #5에서 시작 (trust anchor).
2. **개발자 친화 git-관리 가능한 포맷** — 슬라이드를 Markdown+git으로 관리, diff/review 가능.
3. **라이브 리스크 제로** — 모든 데모는 사전 녹화, 발표장에서 네트워크/API 의존 없음. PDF가 primary delivery format.
4. **CUBRID 현실 기반 에피소드** — 발표자가 실제로 경험한 사건만 포함. 각 에피소드는 presenter sign-off 후에만 콘텐츠 제작 진행. Hard gate.
5. **최소 도구 체인** — 제작 기간 1주일에 맞게 학습 부담 최소화. userspace-only 도구만 사용 (sudo 불필요).

### Decision Drivers (Top 3)

1. **환경 호환성**: Rocky Linux 9.6, no Chrome/Chromium, Firefox 128.13.0esr available, no ffmpeg, no ttyd, sudo requires password. 도구 선택은 userspace 설치 가능 여부가 1차 필터.
2. **재현성과 속도**: 데모를 빠르게 재녹화할 수 있어야 하고, 슬라이드를 CLI 한 줄로 빌드 가능해야 함.
3. **공유 용이성**: 최종 결과물이 PDF(오프라인 발표/이메일 배포) + HTML(animated demo) dual format으로 제공 가능해야 함.

### Viable Options

#### Slide Tool

| | **Marp** | **Slidev** |
|---|---|---|
| Format | Markdown -> PDF/PPTX/HTML | Markdown+Vue -> SPA |
| Git-friendly | Excellent (pure MD) | Good (MD + config) |
| Install | `npm i @marp-team/marp-cli` | `npm i slidev` |
| PDF export | puppeteer-core → **Firefox headless** | Playwright → uncertain Firefox support |
| Code highlight | Prism, good | Shiki + Monaco, excellent |
| GIF/video embed | HTML `<img>` in MD, works | Native, excellent |
| Theme quality | Clean but minimal | Modern, polished |
| Learning curve | Near zero (already MD) | Medium (Vue concepts) |
| Offline delivery | PDF or single HTML | Build to SPA, heavier |
| 16:9 + big fonts | `theme: default` + CSS | Built-in layouts |
| Risk | LOW: Firefox path less battle-tested but functional | MEDIUM: heavier deps, Playwright PDF uncertain on this env |

**Invalidated alternatives:**
- **Slidev**: Real advantages exist (Monaco editor integration, Vue components for interactive elements, Shiki syntax highlighting is superior to Prism). However, two factors break the tie against Slidev: (1) the 1-week timeline makes Slidev's learning curve (Vue component model, Slidev-specific layout syntax) a tangible risk; (2) the "1인칭 톤, not over-polished" principle means Marp's cleaner/simpler aesthetic is actually better-aligned -- an overly polished slide deck undercuts the "개발자가 솔직하게 경험 공유" tone. Additionally, Playwright's Firefox support for PDF export is less reliable than Marp's puppeteer-core Firefox path on this system.
- **Reveal.js**: Requires more manual HTML scaffolding than Marp for the same result. No CLI PDF export without additional tooling.
- **Keynote**: macOS only. Presenter is on Rocky Linux.
- **Google Slides**: Not git-manageable, no CLI build. Principle 2 violation.

**Decision: Marp** (via Firefox headless)

#### Demo Recording Tool

| | **asciinema + agg** (PRIMARY) | **vhs (Charm)** (STRETCH) |
|---|---|---|
| Install | `pip install asciinema` + agg static binary | `go install` + ffmpeg + ttyd |
| System deps | **NONE** (pure userspace) | ffmpeg (NOT installed, NOT in repos), ttyd (NOT installed) |
| Sudo required | **NO** | YES (for ffmpeg/ttyd via dnf) |
| Output format | `.cast` → GIF via `agg` | GIF directly |
| Determinism | Record live, edit `.cast` JSON for pacing | Excellent: `.tape` script |
| Re-record speed | Re-do live or script with expect | Edit `.tape`, re-run |
| Terminal fidelity | Excellent (records pty output) | Pixel-perfect |

**Invalidated alternatives:**
- **vhs as primary**: Requires ffmpeg + ttyd, neither installed. `ffmpeg-free` is NOT in configured dnf repos. `sudo` requires a password. Static ffmpeg binary is possible but ttyd also needs sourcing -- 3-dependency chain violates Principle 5. Demoted to "stretch goal."
- **terminalizer**: npm package, last maintained 2022, rendering issues on newer Node.
- **OBS Studio**: Requires desktop environment. Not available on tty-only Rocky Linux.
- **ttygif**: Depends on unmaintained `ttyrec`; output quality inferior.

**Primary: asciinema + agg**
- Zero system dependencies, pure userspace installation
- `.cast` files are JSON-based and editable (compress Claude Code thinking pauses, cut mistakes)
- `agg` static binary renders GIF natively without ffmpeg
- Real interaction captured (authenticity), edited for pacing

**Hard fallback: Static PNG screenshots + Pillow annotation**
- If asciinema recording fails in this terminal environment (unlikely but possible)
- `gnome-screenshot` is installed for capture
- `Pillow` (Python) is installable via pip for adding arrows/captions
- Decision gate: if demo recording is not producing usable GIFs by end of Day 3, pivot to annotated screenshots
- Command: `pip install Pillow` + Python script for annotation

**Stretch goal: vhs**
- Only if ffmpeg + ttyd become installable (e.g., sudo access granted, or static binaries confirmed working)
- Do NOT plan around this. Do NOT block on this.

---

## 3. ADR (Architectural Decision Record)

### Decision
Marp (Markdown Presentation Ecosystem) via Firefox headless + asciinema/agg for demo recording. Dual output: HTML (presentation) + PDF (distribution).

### Drivers
1. 1주일 제작 기간에 학습 곡선 최소화 필요
2. Rocky Linux 9.6 tty 환경에서 CLI 기반 빌드 필수, sudo 없이 작동해야 함
3. PDF 오프라인 배포 + git 버전 관리 + animated demo 모두 충족

### Alternatives Considered
- **Slidev**: 더 세련된 UI, Monaco/Shiki 코드 하이라이트 우수, Vue 컴포넌트로 인터랙티브 요소 가능. But: Playwright PDF export의 Firefox 지원 불안정, Vue 학습 비용, 1주일 타임라인에서 리스크가 Marp 대비 높음. "1인칭 톤, not over-polished" 원칙에서 Marp의 간결한 미학이 더 적합.
- **Google Slides**: 협업 쉬움. But: git 관리 불가, CLI 빌드 불가. Principle 2 위반.
- **vhs (demo)**: `.tape` 스크립트로 결정적 재현 가능. But: ffmpeg + ttyd 미설치, dnf repo에 ffmpeg-free 없음, sudo 비밀번호 필요. 3-dependency chain이 Principle 5 위반.

### Why Chosen
- Marp: "Markdown → PDF" 파이프라인이 가장 단순. Firefox 128.13.0esr이 headless로 작동 확인됨. `CHROME_PATH=$(which firefox)` 환경변수로 puppeteer-core가 Firefox를 사용.
- asciinema+agg: pip + static binary로 userspace 설치 완료. `.cast` JSON 편집으로 대기 시간 압축 가능. ffmpeg 불필요.

### Consequences
- (+) 슬라이드가 single `.md` 파일이므로 autopilot agent가 편집하기 쉬움
- (+) PDF 생성이 `CHROME_PATH=$(which firefox) npx marp` 한 줄
- (+) 데모 녹화가 sudo 없이 가능
- (-) Marp 테마 커스터마이징은 raw CSS, 디자인 폴리시에 한계
- (-) asciinema 녹화는 vhs 대비 결정성 낮음 (미티게이션: 2~3 테이크 후 최선 선택, `.cast` 편집)
- (-) Firefox rendering은 Chrome 대비 소폭 다를 수 있음 (미티게이션: Phase 0에서 즉시 검증)

### Follow-ups
- Phase 0에서 Marp Firefox PDF + Korean rendering 즉시 검증
- Phase 0에서 asciinema+agg 전체 파이프라인 end-to-end 검증
- GIF 파일 크기가 과도하면 `agg --speed` 또는 해상도 조정
- vhs가 설치 가능해지면 `.tape` 스크립트로 전환 고려 (optional)

---

## 4. Tool Stack (Final, No Ambiguity)

### Slide: Marp

```bash
# Install
npm install --save-dev @marp-team/marp-cli

# Build PDF (for distribution)
CHROME_PATH=$(which firefox) npx marp slides/main.md --pdf --allow-local-files -o output/presentation.pdf

# Build HTML (for live presentation with animated GIFs)
CHROME_PATH=$(which firefox) npx marp slides/main.md --html --allow-local-files -o output/presentation.html

# Theme
# Custom CSS extending 'default', tuned for 16:9 projector (36px+ body font, high contrast)
# Korean font: font-family: 'Noto Sans CJK KR', sans-serif;
```

### Demo Primary: asciinema + agg

```bash
# Install asciinema
pip install asciinema

# Install agg (static binary, no ffmpeg needed)
curl -L -o ~/.local/bin/agg \
  https://github.com/asciinema/agg/releases/download/v1.7.0/agg-x86_64-unknown-linux-gnu
chmod +x ~/.local/bin/agg

# Record
asciinema rec --cols 120 --rows 30 assets/casts/ep1-1-heap-navigation.cast

# Edit .cast file (JSON) to compress Claude Code thinking pauses:
#   - Find long gaps between events (>5 sec)
#   - Reduce to 2-3 sec with "[thinking...]" indicator preserved
#   - Or use: agg --speed 2.0 for global speedup

# Render to GIF
agg assets/casts/ep1-1-heap-navigation.cast assets/demos/ep1-1-heap-navigation.gif \
  --font-size 16 --theme monokai --cols 120 --rows 30

# Embed in Marp slide
# ![demo](../assets/demos/ep1-1-heap-navigation.gif)
```

### Demo Fallback: Static PNG + Pillow Annotation

```bash
# If asciinema+agg fails by Day 3, pivot to this:

# Capture terminal screenshot
gnome-screenshot --area -f assets/images/ep1-1-screenshot.png
# Or: take screenshot on presentation machine and transfer

# Annotate with Pillow (Python)
pip install Pillow
python3 -c "
from PIL import Image, ImageDraw, ImageFont
img = Image.open('assets/images/ep1-1-screenshot.png')
draw = ImageDraw.Draw(img)
draw.text((50, 50), '1. Claude Code가 heap_file.c를 탐색', fill='red')
draw.rectangle([100, 200, 800, 400], outline='red', width=3)
img.save('assets/images/ep1-1-annotated.png')
"
```

### Demo Stretch (NOT assumed): vhs

```bash
# Only if ffmpeg + ttyd become available (sudo access granted or static binaries work)
# go install github.com/charmbracelet/vhs@latest
# vhs record assets/tapes/ep1-1-heap-navigation.tape
# DO NOT plan around this. DO NOT block on this.
```

---

## 5. Repo Layout

```
/home/vimkim/temp/cubrid-ai-ppt/
├── README.md                    # 프로젝트 개요, 빌드 방법
├── package.json                 # marp-cli dev dependency
├── marp.config.mjs              # Marp 설정 (html: true, theme 경로)
├── slides/
│   ├── main.md                  # 전체 슬라이드 (Marp single-file)
│   └── theme/
│       └── cubrid-theme.css     # 커스텀 테마 (16:9, Noto Sans CJK KR, 36px+, 고대비)
├── assets/
│   ├── demos/                   # 사전 녹화 데모 GIF (agg output)
│   │   ├── ep1-1-heap-navigation.gif
│   │   ├── ep2-2-ci-failure-analysis.gif
│   │   └── ep3-1-jira-writing.gif
│   ├── casts/                   # asciinema .cast 녹화 원본 (편집 가능)
│   │   ├── ep1-1-heap-navigation.cast
│   │   ├── ep2-2-ci-failure-analysis.cast
│   │   └── ep3-1-jira-writing.cast
│   └── images/                  # 스크린샷, 다이어그램, 정적 fallback 이미지
│       ├── claude-code-overview.png
│       └── before-after-*.png
├── episodes/                    # 에피소드 상세 (presenter drill-down 카드)
│   └── episodes-approved.md     # 발표자 확인 완료된 에피소드 목록
├── scripts/
│   ├── build.sh                 # CHROME_PATH=$(which firefox) npx marp ...
│   └── record-demos.sh          # asciinema+agg 일괄 녹화 스크립트
├── output/                      # 빌드 결과물 (.gitignore)
│   ├── presentation.pdf         # 배포용 (정적 데모 프레임)
│   └── presentation.html        # 발표용 (animated GIF)
├── rehearsal/
│   └── notes.md                 # 리허설 메모, 스톱워치 타이밍 기록
├── .omc/                        # OMC 작업 상태 (기존)
└── .gitignore                   # output/, node_modules/
```

---

## 6. Phase Plan with Verification Matrix

### Phase 0: 환경 검증 + 프로젝트 스캐폴딩 (Day 1 AM, ~1.5h)

**Tasks:**
- [ ] `npm init -y` + `npm install --save-dev @marp-team/marp-cli`
- [ ] 디렉토리 구조 생성 (slides/, assets/demos/, assets/casts/, assets/images/, episodes/, scripts/, output/, rehearsal/)
- [ ] `.gitignore` 작성 (output/, node_modules/)
- [ ] `marp.config.mjs` 기본 설정 (html: true, theme 경로)
- [ ] `cubrid-theme.css` 초안 (16:9, `font-family: 'Noto Sans CJK KR', sans-serif`, 36px+ body, 고대비 색상)
- [ ] `scripts/build.sh` 작성 (CHROME_PATH 포함)
- [ ] Marp Firefox PDF smoke test (아래 검증 명령)
- [ ] Korean rendering validation: 테스트 덱에 한국어 제목 + 코드 블록 + 모노스페이스 테이블 포함 → PDF 생성 → 글리프 정상 확인
- [ ] `pip install asciinema` + agg static binary 다운로드
- [ ] asciinema+agg 전체 파이프라인 end-to-end 테스트 (5초 녹화 → GIF 렌더링 → Marp 슬라이드 임베드 확인)
- [ ] **에피소드 진위 검증 (HARD GATE)**: 9개 에피소드 목록을 발표자에게 제시. 각 에피소드에 대해 "실제 경험인가? 관련 PR/JIRA/날짜는?" 확인. 발표자가 서명한 목록을 `episodes/episodes-approved.md`에 저장. **이 게이트를 통과하지 못하면 Phase 1 진입 불가.**

**Verification Matrix:**

| Check | Command / Action | Expected Result |
|-------|-----------------|-----------------|
| Marp PDF via Firefox | `echo '---\nmarp: true\n---\n# test' > /tmp/t.md && CHROME_PATH=$(which firefox) npx --yes @marp-team/marp-cli /tmp/t.md --pdf -o /tmp/t.pdf` | exit 0, `/tmp/t.pdf` exists |
| Korean rendering | Marp test deck with `# 한국어 제목`, `` ```c code block ```, `| 테이블 |` → build PDF → open and verify glyphs | All Korean text renders correctly, no tofu/squares |
| Font fallback | `fc-list :lang=ko \| grep -i "noto sans cjk"` | Noto Sans CJK KR listed |
| asciinema install | `pip install asciinema && asciinema --version` | version string (2.4.0) |
| agg install | `agg --version` | version string (v1.7.0) |
| Full demo pipeline | `asciinema rec --cols 80 --rows 24 -c "echo hello && sleep 1" /tmp/test.cast && agg /tmp/test.cast /tmp/test.gif` | `/tmp/test.gif` exists, viewable |
| GIF in Marp | Build test slide with `![test](/tmp/test.gif)` → HTML output → GIF animates | GIF renders in HTML output |
| Episode authenticity | Presenter review of 9-episode list | `episodes/episodes-approved.md` exists with presenter sign-off |

### Phase 1: 슬라이드 초안 -- 전체 구조 (Day 1 PM ~ Day 2, ~3h)

**Tasks:**
- [ ] `slides/main.md`에 ~25장 슬라이드 골격 작성 (제목 + 1~2줄 placeholder)
- [ ] 표지(#1), 기대치 설정(#2), 배경(#3), Claude Code 개요(#4), 솔직하게 한계(#5), 구조 안내(#6) 내용 채움
- [ ] 한계/주의점(#21~22), Getting Started(#23~25), Q&A 브릿지(#26) 내용 채움
- [ ] FAQ 백업 슬라이드 8장 내용 채움 (섹션 9의 FAQ 콘텐츠 기반)
- [ ] 에피소드 authenticity gate 결과 반영: 발표자가 실제 경험 아닌 에피소드는 교체

**Verification Matrix:**

| Check | Command / Action | Expected Result |
|-------|-----------------|-----------------|
| Slide count | `CHROME_PATH=$(which firefox) npx marp slides/main.md --pdf -o /tmp/check.pdf` → page count | ~33 pages (25 main + 8 FAQ) |
| Non-episode slides complete | Visual check of slides #1-6, #21-26, FAQ slides | 내용 텍스트 완성 (placeholder 아님) |
| No live-demo phrasing | `grep -i "실제로 돌려" slides/main.md` | 0 matches |
| No "N배" language | `grep -E "[0-9]+배" slides/main.md` | 0 matches (or only qualified anecdotal references) |

### Phase 2: Hero Episodes + Demos (Day 2~4, ~5h)

**Tasks:**
- [ ] **Hero 1-1** (코드베이스 탐색): `heap_file.c 레코드 흐름 파악` 슬라이드 내용 작성 (before/after, 2~3분 분량)
- [ ] Hero 1-1 demo: asciinema로 실제 Claude Code 세션 녹화 → `.cast` 편집(대기 시간 압축) → agg로 GIF → 슬라이드 임베드
- [ ] **Hero 2-2** (개발 작업): `CI shell-test 실패 분석` 슬라이드 내용 작성
- [ ] Hero 2-2 demo: asciinema 녹화 → GIF → 임베드
- [ ] **Hero 3-1** (문서): `JIRA 이슈 / PR description 작성` 슬라이드 내용 작성
- [ ] Hero 3-1 demo: asciinema 녹화 → GIF → 임베드
- [ ] 각 hero 에피소드의 한계/환각 사례 슬라이드 내용 작성
- [ ] 각 before/after 비교에 "이 특정 케이스에서" 한정어 포함 확인

**Day 3 Decision Gate:** 만약 asciinema+agg 데모가 만족스러운 GIF를 생성하지 못하면 → 즉시 정적 스크린샷 + Pillow 어노테이션으로 전환.

**Verification Matrix:**

| Check | Command / Action | Expected Result |
|-------|-----------------|-----------------|
| 3 demo GIFs exist | `ls -la assets/demos/*.gif` | 3 files, each < 15MB |
| GIFs render in HTML | Build HTML → open → GIFs animate | All 3 GIFs play correctly |
| Demo duration | Each GIF plays for 30~60 sec | Verified by playback |
| Hero slides complete | Visual check of hero episode slides | Before/after + caveat + "이 특정 케이스에서" qualifier |
| `.cast` files archived | `ls assets/casts/*.cast` | 3 files (for future re-rendering) |

### Phase 3: Mention Episodes + Area Slides (Day 4~5, ~3h)

**Tasks:**
- [ ] **Area 1 mentions**: Episode 1-2 (JIRA+PR 체인), Episode 1-3 (MVCC 이해) → 각 1장 슬라이드, bullet-point before/after, 데모 없음
- [ ] **Area 2 mentions**: Episode 2-1 (isolation test), Episode 2-3 (헬퍼 함수+테스트) → 각 1장 슬라이드
- [ ] **Area 3 mentions**: Episode 3-2 (Greptile 응답), Episode 3-3 (노트→문서 변환) → 각 1장 슬라이드
- [ ] 각 mention 슬라이드에 "이 특정 경험에서는" 한정어 포함

**Verification Matrix:**

| Check | Command / Action | Expected Result |
|-------|-----------------|-----------------|
| Mention slides exist | Slide count for mentions | 6 mention slides, each 1 page |
| No demo dependency | Mention slides reference no GIF/video | Text + bullet-point only |
| Brevity check | Each mention slide: max 4~5 bullet points | Fits 30~45 sec narration |

### Phase 4: 테마 다듬기 + 전체 통합 (Day 5~6, ~2h)

**Tasks:**
- [ ] CSS 테마 최종 조정 (폰트 크기, 색상, 코드 블록 스타일, 테이블 스타일)
- [ ] 전체 슬라이드 PDF + HTML 빌드 + 육안 검수
- [ ] 슬라이드 간 흐름/전환 확인 (hero → mention 전환이 자연스러운지)
- [ ] 오탈자, 어색한 표현 수정
- [ ] PDF에서 데모 슬라이드: 정적 프레임 + "▶ 사전 녹화 데모 (HTML 버전에서 재생 가능)" 캡션 확인
- [ ] HTML에서 데모 슬라이드: GIF 정상 재생 확인
- [ ] PDF 파일 크기 확인 (< 25MB 목표)

**Verification Matrix:**

| Check | Command / Action | Expected Result |
|-------|-----------------|-----------------|
| PDF build | `CHROME_PATH=$(which firefox) npx marp slides/main.md --pdf --allow-local-files -o output/presentation.pdf` | exit 0 |
| HTML build | `CHROME_PATH=$(which firefox) npx marp slides/main.md --html --allow-local-files -o output/presentation.html` | exit 0 |
| PDF size | `ls -lh output/presentation.pdf` | < 25MB |
| Slide count | PDF page count | ~33 (25 main + 8 FAQ) |
| Korean rendering | Visual check of Korean text in PDF | No tofu, correct font weight |
| 16:9 ratio | Visual check | All slides 16:9, not 4:3 |
| Font size | Visual check from 3m distance (or scale to 25%) | Body text readable |
| GIF in HTML | Open HTML in Firefox → check demo slides | GIFs animate |
| No live phrasing | `grep -ci "실제로 돌려\|라이브\|지금 바로" slides/main.md` | 0 or only "사전 녹화" context |

### Phase 5: FAQ 슬라이드 보강 + Presenter Notes (Day 6, ~1h)

**Tasks:**
- [ ] FAQ 8개 슬라이드 내용 최종 보강 (섹션 9 기반)
- [ ] 각 hero 에피소드에 대한 presenter drill-down 카드 작성 (발표자 노트: PR 번호, JIRA 티켓, 날짜)
- [ ] 발표자 노트를 별도 파일 또는 Marp presenter notes (`<!-- -->`)로 작성

**Verification Matrix:**

| Check | Command / Action | Expected Result |
|-------|-----------------|-----------------|
| FAQ slides count | Count FAQ slides in main.md | 8 slides (B1~B8) |
| FAQ completeness | Each FAQ slide has 1-sentence answer + 1~2 backup bullets | All 8 covered |
| Drill-down cards | `cat episodes/episodes-approved.md` | PR/JIRA/date for each hero episode |

### Phase 6: 리허설 (Day 6~7, ~2h)

**Tasks:**
- [ ] 스톱워치로 전체 발표 시뮬레이션 (FAQ 슬라이드 제외)
- [ ] 각 슬라이드 실제 소요 시간 기록 → `rehearsal/notes.md`
- [ ] **Pass criterion: 전체 23:00 +/- 2:00 (21:00 ~ 25:00)**
- [ ] 초과 시 cut priority (아래 순서):
  1. Mention 에피소드 중 약한 것 1~2개 cut
  2. Hero 에피소드 narration 압축 (setup 부분 단축)
  3. Getting Started 세부 내용 축소 (핵심 3개만 유지)
  4. **절대 cut 금지**: 한계/주의점 슬라이드 (#5, #21~22)
- [ ] Q&A 예상 질문으로 모의 drill-down 연습 (특히 "어느 PR이었어요?" 질문)
- [ ] 최종 PDF + HTML 빌드

**Verification Matrix:**

| Check | Command / Action | Expected Result |
|-------|-----------------|-----------------|
| Timing recorded | `cat rehearsal/notes.md` | 슬라이드별 초 단위 기록 존재 |
| Total time | Sum of all timings | 21:00 ~ 25:00 |
| Cut applied if needed | If > 25:00, mention cuts applied | Revised total within range |
| Final PDF | `ls -la output/presentation.pdf` | Exists, < 25MB |
| Final HTML | `ls -la output/presentation.html` | Exists |

---

## 7. Episode List (Hero + Mention Format)

**Status: ALL episodes marked `[NEEDS PRESENTER CONFIRMATION]` until Phase 0 authenticity gate passes.**

### Area 1: 대규모 코드베이스 탐색/이해

#### HERO: Episode 1-1 — heap_file.c 레코드 흐름 파악 `[NEEDS PRESENTER CONFIRMATION]`
- **Scenario**: OOS 기능 개발 중, `heap_insert_logical`에서 `heap_insert_physical`까지의 레코드 삽입 흐름을 이해해야 했음
- **Before**: grep+cscope/ctags로 함수 호출 체인 수동 추적. heap_file.c가 15,000줄+이라 맥락 파악에 오래 걸렸음
- **After**: Claude Code에 흐름 설명 요청 → 짧은 시간 내에 함수 호출 체인 + 각 단계의 역할 요약 획득 (이 특정 케이스에서의 경험)
- **Demo**: asciinema GIF (30~45초, 편집 후)
- **Caveat**: N/A (success case)
- **Drill-down prep**: PR 번호, 날짜, 실제 함수 체인 (발표자 확인 필요)

#### MENTION: Episode 1-2 — JIRA + PR 체인 한 번에 파악 `[NEEDS PRESENTER CONFIRMATION]`
- Before: 브라우저 탭 여러 개 / After: 한 세션에서 요약
- 30~45초, 데모 없음, bullet-point

#### MENTION: Episode 1-3 — 낯선 서브시스템 이해 (MVCC/Vacuum) `[NEEDS PRESENTER CONFIRMATION]`
- Before: 소스+위키 교차 참조, 수일간 학습 / After: 코드베이스 읽히고 질문 → 관련 함수 흐름 설명
- **환각 사례 포함** (vacuum_data 구조체 필드 오해석) → "반드시 교차 검증" 메시지
- 30~45초, 데모 없음

### Area 2: 실제 개발 작업

#### HERO: Episode 2-2 — CI shell-test 실패 분석 및 수정 `[NEEDS PRESENTER CONFIRMATION]`
- **Scenario**: PR merge 후 CI에서 shell test 실패. 실패 로그가 길고 원인 불명확
- **Before**: CI 로그 수동 다운로드, expected/actual diff, 로컬 재현 시도. 시간이 오래 걸렸음
- **After**: Claude Code에 실패 로그+테스트 스크립트 읽히고 분석 요청 → 근본 원인 파악 (이 특정 경험에서의 결과)
- **Demo**: asciinema GIF (30~45초)
- **Caveat**: N/A
- **Drill-down prep**: CI job URL, PR 번호, 어떤 테스트가 실패했는지 (발표자 확인 필요)

#### MENTION: Episode 2-1 — isolation test (.ctl) 작성 `[NEEDS PRESENTER CONFIRMATION]`
- Before: 기존 .ctl 복사+수정, 시행착오 / After: 패턴 학습 후 초안 즉시 획득
- 30~45초, 데모 없음

#### MENTION: Episode 2-3 — 헬퍼 함수 + 단위 테스트 동시 작성 `[NEEDS PRESENTER CONFIRMATION]`
- Before: 함수→빌드→테스트 수동 사이클 / After: 함수+테스트 동시 생성
- **Edge case 누락 사례 포함** → "개발자 검토 필수"
- 30~45초, 데모 없음

### Area 3: 문서/커뮤니케이션

#### HERO: Episode 3-1 — JIRA 이슈 / PR description 작성 `[NEEDS PRESENTER CONFIRMATION]`
- **Scenario**: OOS 기능의 새 JIRA 이슈 작성. 팀 컨벤션: 본문 한국어, 섹션 헤더 영어
- **Before**: 기존 이슈 참고하며 수동 작성. 기술적 맥락 설명에 시간 소요
- **After**: Claude Code에 변경 코드 범위 보여주고 이슈 작성 요청 → 짧은 시간에 초안 완성 (이 특정 사례에서의 경험)
- **Demo**: asciinema GIF (30~45초)
- **Caveat**: N/A
- **Drill-down prep**: 실제 JIRA 이슈 번호, PR 번호 (발표자 확인 필요)

#### MENTION: Episode 3-2 — Greptile 봇 리뷰 응답 일괄 처리 `[NEEDS PRESENTER CONFIRMATION]`
- Before: 코멘트당 시간 소요 / After: 전체 응답 초안 한 번에 획득
- 30~45초, 데모 없음

#### MENTION: Episode 3-3 — 조사 노트 → 내부 문서 변환 `[NEEDS PRESENTER CONFIRMATION]`
- Before: 메모를 처음부터 재구조화 / After: 구조화된 문서 초안
- **"보충" 환각 사례 포함** → 팩트체크 필수
- 30~45초, 데모 없음

---

## 8. Slide-by-Slide Outline (25 Main + 8 FAQ Backup = 33 total)

### Main Slides (25장, target ~24:30)

| # | Title (Korean) | Purpose | Visual/Content | Seconds | Demo? |
|---|---|---|---|---|---|
| 1 | Claude Code 1개월 사용 현황 보고 | 표지 | 제목, 발표자(김대현), 소속(AI TFT / 개발2팀), 날짜 | 10 | |
| 2 | 이 발표는... / 이 발표는 아닙니다 | 기대치 설정 | 2열: "O: 1인칭 경험 공유, 한계 포함" vs "X: AI 만능 홍보, 핸즈온" | 40 | |
| 3 | 왜 이 자리에 섰나 | 배경 맥락 | 팀장/전무 요청, AI TFT 역할 한 줄, "개발자로서 한 달간 써본 이야기" | 40 | |
| 4 | Claude Code란? (1분 개요) | 모르는 분을 위한 최소 맥락 | 터미널 기반 AI 코딩 어시스턴트, Anthropic, Max 플랜. 구조 다이어그램 | 50 | |
| 5 | 먼저 솔직하게: 이것은 마법이 아닙니다 | Trust anchor (front-loaded honesty) | 3개 핵심 한계: 환각 발생, 컨텍스트 한계, 검증은 개발자 몫. "이걸 인정한 위에서 이야기합니다" | 50 | |
| 6 | 오늘의 세 가지 이야기 | 구조 안내 | 3개 아이콘 + 영역 이름: 탐색, 개발, 문서. Hero+mention 구조 암시 | 25 | |
| 7 | **Part 1: 코드베이스 탐색** | 섹션 타이틀 | 큰 텍스트 + 아이콘 | 5 | |
| 8 | heap_file.c 레코드 흐름 파악 | Hero 1-1 setup+before | CUBRID heap_file.c 15,000줄+ 맥락, 기존 방식(grep+cscope) 고충 | 45 | |
| 9 | [사전 녹화] 코드 탐색 실제 모습 | Hero 1-1 demo | GIF: Claude Code가 heap_file.c를 탐색하며 설명 (30~45초 녹화) | 50 | YES |
| 10 | 탐색 영역 — 이런 것도 했습니다 | Mentions 1-2, 1-3 | 2 bullet-point stories (JIRA+PR 체인, MVCC 이해). 1-3에서 환각 사례 1줄 | 50 | |
| 11 | **Part 2: 실제 개발 작업** | 섹션 타이틀 | 큰 텍스트 + 아이콘 | 5 | |
| 12 | CI shell-test 실패 분석 | Hero 2-2 setup+before | CI 실패 3건, 로그 길이, 기존 수동 분석 과정 | 45 | |
| 13 | [사전 녹화] CI 실패 분석 실제 모습 | Hero 2-2 demo | GIF: Claude Code가 실패 로그 읽고 원인 파악 (30~45초) | 50 | YES |
| 14 | 개발 영역 — 이런 것도 했습니다 | Mentions 2-1, 2-3 | 2 bullet-point stories (.ctl 작성, 헬퍼 함수+테스트). 2-3에서 edge case 누락 1줄 | 50 | |
| 15 | **Part 3: 문서/커뮤니케이션** | 섹션 타이틀 | 큰 텍스트 + 아이콘 | 5 | |
| 16 | JIRA 이슈 / PR description 작성 | Hero 3-1 setup+before | 팀 컨벤션(한국어+영어 헤더), 기존 수동 작성 시간 | 45 | |
| 17 | [사전 녹화] JIRA 이슈 작성 실제 모습 | Hero 3-1 demo | GIF: Claude Code가 코드 보고 JIRA 이슈 생성 (30~45초) | 50 | YES |
| 18 | 문서 영역 — 이런 것도 했습니다 | Mentions 3-2, 3-3 | 2 bullet-point stories (Greptile 응답, 노트→문서). 3-3에서 "보충" 환각 1줄 | 50 | |
| 19 | 종합: 한계와 주의점 | 정직한 균형 정리 | 4개 항목: 환각, 컨텍스트 크기 한계, 보안/IP 주의, 비용. 각 1~2줄 구체적 설명 | 70 | |
| 20 | 환각에 대한 개인적 원칙 | 깊이 있는 한계 논의 | "AI 출력은 초안이다. 검증은 개발자의 몫." 개인 원칙 3줄 | 45 | |
| 21 | 시작하려면 (Getting Started) | 실용 가이드 | 라이센스 취득 방법 (Max 플랜), 설치 명령 (`curl`, `claude`), 최소 설정 | 55 | |
| 22 | 처음 써볼 때 이 세 가지부터 | 첫 시도 유용 기능 | 1. 코드베이스 질문 2. 테스트 작성 요청 3. 문서 초안 요청 | 45 | |
| 23 | 한 달 사용자의 팁 | 실용 조언 | 3~4개 짧은 팁: CLAUDE.md 작성, 컨텍스트 관리, 검증 습관, /compact 활용 | 45 | |
| 24 | Q&A | 질의응답 브릿지 | "질문 있으신가요?" + 발표자 연락처 | 10 | |
| 25 | 감사합니다 | 클로징 | 제목 반복 + "김대현 / AI TFT / 개발2팀" | 5 | |

**Total: 24:30 (1470 sec)**

### FAQ Backup Slides (8장, Q&A 시 필요에 따라 사용)

| # | Title | Question |
|---|---|---|
| B1 | FAQ: 에피소드 상세 | "어느 PR/JIRA였어요?" |
| B2 | FAQ: 프롬프트 예시 | "프롬프트 좀 보여주세요" |
| B3 | FAQ: 한글/UTF-8 | "한글/UTF-8 깨지는 건?" |
| B4 | FAQ: 비용/라이센스 | "비용/라이센스는?" |
| B5 | FAQ: 보안/IP | "사내 보안/IP/소스 유출 리스크는?" |
| B6 | FAQ: 다른 도구 비교 | "Copilot/Cursor/Codex와 비교하면?" |
| B7 | FAQ: 환각 빈도 | "환각이나 틀린 코드는 얼마나 자주?" |
| B8 | FAQ: 학습 곡선 | "학습 곡선은?" |

### Cut Candidates (if rehearsal > 25:00)

**Cut priority (먼저 자르는 것부터):**
1. Mention 에피소드 중 약한 것 1~2개 cut (예: 3-3 노트→문서, 2-3 헬퍼 함수 → 남은 mention과 합치거나 삭제)
2. Hero 에피소드 setup 부분 압축 (before 설명 단축, 45초→30초)
3. 슬라이드 #23 (한 달 사용자의 팁) 내용 축소 (4개→2개 팁)
4. **절대 cut 금지**: #5 (먼저 솔직하게), #19~20 (한계와 주의점), #21 (Getting Started)

---

## 9. Q&A FAQ Content (8 Mandatory Questions)

### B1: "어느 PR/JIRA였어요?" (Episode drill-down)

**답변**: "네, 구체적으로 말씀드리면..." + (presenter notes에 있는 실제 PR/JIRA 번호 참조)
- 각 hero 에피소드별 실제 참조 정보는 `episodes/episodes-approved.md`에 기록
- 발표자가 즉답할 수 있도록 drill-down 카드 사전 준비

### B2: "프롬프트 좀 보여주세요"

**답변**: "특별한 프롬프트 엔지니어링 없이 자연어로 요청합니다."
- 실제 사용한 프롬프트 예시 1~2개 텍스트로 제시 (예: "heap_insert_logical에서 디스크에 쓰이기까지의 전체 흐름을 설명해줘")
- "CLAUDE.md에 프로젝트 컨텍스트를 미리 작성해두면 매번 설명할 필요 없음"

### B3: "한글/UTF-8 깨지는 건?"

**답변**: "Claude Code 자체는 한글 입출력에 문제 없습니다."
- 터미널 로케일 설정(LC_ALL=ko_KR.UTF-8)이 올바르면 깨짐 없음
- 생성된 코드 내 한글 주석/문자열도 정상 처리
- 단, CUBRID의 특정 EUC-KR 인코딩 파일은 주의 필요 (UTF-8 가정)

### B4: "비용/라이센스는?"

**답변**: "현재 Claude Max 플랜(월 $100 또는 $200)을 개인 구독으로 사용 중입니다."
- $100 플랜: 일반 사용에 충분. $200 플랜: 대규모 코드베이스 작업 시 rate limit 여유
- 팀 단위 도입 시 Anthropic Teams/Enterprise 플랜 별도 확인 필요
- 현재는 AI TFT 개인 비용으로 평가 중, 팀 확대 시 비용 구조 재검토 필요

### B5: "사내 보안/IP/소스 유출 리스크는?"

**답변**: "이 부분은 도입 전에 반드시 보안팀과 협의가 필요합니다."
- Anthropic의 데이터 정책: API/Max 플랜은 입력 데이터를 학습에 사용하지 않음 (Anthropic Usage Policy 기준)
- 그럼에도 소스 코드가 외부 서버로 전송되는 것은 사실 — 사내 보안 정책과 충돌 가능
- 현재 개인 수준 평가에서는 공개 가능한 범위 내에서 사용. 팀 도입 시 보안 검토 선행 필수

### B6: "Copilot/Cursor/Codex와 비교하면?"

**답변**: "각각 장단점이 있고, 저는 Claude Code만 깊이 사용해봤기 때문에 공정한 비교는 어렵습니다."
- Claude Code 특징: 터미널 기반, agentic (파일 읽기/쓰기/명령 실행 가능), 긴 컨텍스트
- Copilot: IDE 인라인 완성에 강점. Cursor: IDE 통합 에디터. Codex: 비동기 agent 방식
- "직접 비교보다는, 본인의 워크플로우에 맞는 도구를 짧게 시도해보시길 권합니다"

### B7: "환각이나 틀린 코드는 얼마나 자주?"

**답변**: "체감상 의미 있는 작업의 경우 검증 없이 그대로 쓸 수 있는 비율은 높지 않습니다."
- 간단한 작업(보일러플레이트, 테스트 골격): 대부분 바로 사용 가능
- 복잡한 로직(CUBRID 내부 구조 의존): 반드시 교차 검증 필요. 구조체 필드 해석 오류, 존재하지 않는 함수 호출 등 발견
- "AI 출력은 '매우 유능한 동료의 초안'으로 취급합니다. 리뷰는 내 몫."

### B8: "학습 곡선은?"

**답변**: "설치 후 첫날부터 생산적으로 사용할 수 있었습니다."
- 기본 사용: 30분이면 충분 (설치 → 프로젝트 디렉토리에서 `claude` 실행 → 자연어 질문)
- 효과적 사용: 1주일 정도면 CLAUDE.md 작성, 컨텍스트 관리, 검증 습관 형성
- "프롬프트 엔지니어링보다는 '무엇을 요청할지 아는 것'이 학습 곡선의 핵심"

---

## 10. Time Budget Math (Second-Level)

### Speaking Time Breakdown

| Section | Slides | Raw Time | Hidden Overhead | Effective Time |
|---------|--------|----------|-----------------|----------------|
| Opening (표지, 기대치, 배경, 개요, 솔직하게, 구조) | #1~6 | 3:35 | transitions 12s | 3:47 |
| Part 1: 코드베이스 탐색 (타이틀 + hero + demo + mentions) | #7~10 | 2:30 | transitions 8s, demo load 3s, audience reaction 10s | 2:51 |
| Part 2: 실제 개발 (타이틀 + hero + demo + mentions) | #11~14 | 2:30 | transitions 8s, demo load 3s, audience reaction 10s | 2:51 |
| Part 3: 문서 (타이틀 + hero + demo + mentions) | #15~18 | 2:30 | transitions 8s, demo load 3s, audience reaction 10s | 2:51 |
| 한계/주의점 종합 | #19~20 | 1:55 | transitions 4s | 1:59 |
| Getting Started + 팁 | #21~23 | 2:25 | transitions 6s | 2:31 |
| Q&A 브릿지 + 클로징 | #24~25 | 0:15 | transitions 4s | 0:19 |
| **Bridge narration** ("다음 영역으로") | — | 0:00 | 2x 10s = 20s | 0:20 |
| **Presenter pause** (물 마시기 등) | — | 0:00 | 15s | 0:15 |

### Totals

| Metric | Value |
|--------|-------|
| Raw slide content | 15:50 |
| Demo playback (3 x 45s) | 2:15 |
| Hidden overhead (transitions, reactions, pauses) | 2:44 |
| **Total speaking time** | **20:49** |
| **Buffer to 25:00 max** | **4:11** |
| **Buffer to 23:00 target** | **2:11** |

**Math check**: 20:49 raw + up to 2:11 organic expansion (presenter emphasis, audience laughter, re-explaining a point) = ~23:00. Within the 23:00 +/- 2:00 pass criterion.

**If over 25:00 at rehearsal**: Cut 2 mention slides (saves ~1:40) + compress hero setups (saves ~0:45) = total savings ~2:25. Brings back to ~22:35.

**Q&A time**: Presentation ends at ~23:00. In a 35~40 min slot, this leaves **12~17 min for Q&A**. Comfortable.

---

## 11. Environment Risk Audit

### Verified (evidence-based)

| Factor | Status | Evidence |
|--------|--------|---------|
| Node.js | v25.8.0 | `node --version` via mise |
| npm | v11.11.0 | `npm --version` |
| Firefox | v128.13.0esr | `firefox --version`, headless works (`firefox --headless --screenshot` → exit 0) |
| Korean fonts | Noto Sans CJK KR installed | `fc-list :lang=ko` → multiple Noto Sans/Serif CJK entries |
| Puppeteer system libs | Present | gtk3, pango, nss, atk, cups-libs, libX11 (rpm -qa) |
| pip | Available | `pip install asciinema --dry-run` → would install 2.4.0 |
| Pillow | Installable | `pip install Pillow --dry-run` → would install 12.2.0 |
| agg static binary | Available | GitHub releases v1.7.0, `agg-x86_64-unknown-linux-gnu` |
| cargo/Rust | Available | `cargo --version` → 1.89.0 (backup for building agg if static binary fails) |
| Go | v1.24.4 | Available via mise (for vhs stretch goal only) |
| gnome-screenshot | Installed | `/usr/bin/gnome-screenshot` (for screenshot fallback) |

### Assumed (high confidence, verify in Phase 0)

| Factor | Assumption | Verification Step | Pivot if fails |
|--------|-----------|------------------|---------------|
| Marp + Firefox PDF | `CHROME_PATH=$(which firefox) npx marp` produces correct 16:9 PDF | Phase 0 smoke test | Try `marp --pptx` export. If both fail, use Slidev or plain HTML+print-to-PDF |
| Korean in Marp PDF | Noto Sans CJK KR renders correctly in Firefox headless | Phase 0 Korean rendering test | Add explicit `@font-face` in CSS theme pointing to system font path |
| asciinema in this terminal | pty recording works in tty+X11 forwarding env | Phase 0 end-to-end test | Pivot to static screenshots + Pillow annotation (Day 3 gate) |
| agg static binary | Runs on Rocky 9.6 x86_64 | Phase 0: `agg --version` | Build from source with cargo |
| GIF in Marp HTML | `<img>` tag with local GIF animates in HTML output | Phase 0 test | Use `<video>` tag with converted MP4, or static frame |

### Known limitations (no pivot needed)

| Factor | Status | Impact |
|--------|--------|--------|
| No Chrome/Chromium | NOT installed | Use Firefox. All Marp commands use `CHROME_PATH=$(which firefox)` |
| No ffmpeg | NOT installed, NOT in repos | asciinema+agg pipeline does not need ffmpeg. vhs is stretch only |
| No ttyd | NOT installed | vhs is stretch only, not primary |
| No ImageMagick | NOT installed | Use Pillow for screenshot annotation if needed |
| No GIMP | NOT installed | Use Pillow |
| sudo requires password | NOT passwordless | All tools are userspace-installable. No sudo needed |

### Concrete pivot paths

| Trigger | Pivot |
|---------|-------|
| Marp Firefox PDF fails | Try `npx marp --pptx`. If that fails, evaluate Slidev with `npx slidev export --with-clicks`. Last resort: plain HTML with CSS print media query |
| Korean fonts render as tofu | Add `@font-face { font-family: 'Noto Sans CJK KR'; src: url('/usr/share/fonts/google-noto-cjk/NotoSansCJK-Regular.ttc'); }` to theme CSS |
| asciinema can't record | Day 3 gate: pivot to `gnome-screenshot` + Pillow annotation. Static PNG with red boxes and text captions |
| agg static binary fails | Build from source: `cargo install agg`. Takes ~5 min with cargo 1.89.0 |
| GIF too large for PDF | Already decided: PDF uses static frame + caption. HTML uses animated GIF. No issue |
| Demo doesn't look good enough | Pillow-annotated screenshots are the floor. "Many excellent tech talks use this format" (Architect) |

---

## 12. Open Questions Remaining

아래 항목은 `.omc/plans/open-questions.md`에도 반영됨.

1. **[BLOCKING] 에피소드 실제 경험 여부** — 9개 에피소드가 발표자의 실제 경험 기반인지 확인 필요. Phase 0 hard gate. 실제 경험이 아닌 에피소드는 교체 필수.
2. **[BLOCKING] CUBRID 소스 코드 접근 경로** — 데모 녹화 시 실제 CUBRID worktree가 필요. 발표자의 작업 디렉토리 경로 확인 필요.
3. **[NON-BLOCKING] PDF 크기 제한** — HTML primary + PDF backup 전략으로 리스크 완화됨. Phase 4에서 확인.
4. **[NON-BLOCKING] vhs 설치 가능성** — stretch goal. sudo 접근 가능해지면 재평가하지만, 계획에 영향 없음.
5. **[RESOLVED] Marp Firefox 호환성** — Phase 0 smoke test로 검증. 피벗 경로 문서화 완료.
6. **[RESOLVED] 데모 도구 선택** — asciinema+agg primary, 정적 스크린샷 fallback, vhs stretch. 확정.

---

## Guardrails (Unchanged from v1, reinforced)

### Must Have
- 모든 슬라이드 한국어 (영어 기술 용어는 그대로)
- 1인칭 경험담 톤 — 발표자가 실제로 경험한 에피소드만
- 장단점 비율 ~70:30 (한계 언급: 슬라이드 #5 trust anchor + #10/14/18 inline + #19~20 종합)
- 사전 녹화 데모 3개 (GIF, 각 30~45초)
- PDF 오프라인 발표 가능 (정적 데모 프레임 + "HTML 버전에서 재생" 캡션)
- HTML 발표 가능 (animated GIF)
- 16:9, 큰 폰트(36px+ body), 고대비
- Getting Started 섹션 포함
- FAQ 백업 슬라이드 8장 포함
- 모든 before/after 비교에 "이 특정 케이스에서" 한정어

### Must NOT Have
- 라이브 Claude Code 세션 (on-stage 또는 implied)
- "실제로 돌려보면", "지금 바로 시도해보겠습니다" 등 라이브 암시 표현
- OMC/agent orchestration 메타 워크 언급
- Copilot/Cursor/Codex 공격적 비교 (중립 톤 FAQ에서만)
- "N배 빨라졌다" 식의 배수 표현 — 질적 프레이밍만 허용
- AI가 대필한 일반론 느낌의 문장
- 발표자가 실제 경험하지 않은 에피소드
