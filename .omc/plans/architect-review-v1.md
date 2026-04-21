# Architect Review: Claude Code 1개월 현황 보고 발표 자료 제작 Plan v1

**Reviewer:** Architect Agent
**Date:** 2026-04-20
**Plan under review:** `ralplan-draft-v1.md`
**Spec:** `deep-interview-claude-code-intro-presentation.md`

---

## 1. Steelman Antithesis

### 1.1 Against Marp: "Puppeteer deps confirmed" is WRONG

**The plan's claim that "Puppeteer PDF export works on this system (Puppeteer deps confirmed)" is factually incorrect.** Marp uses `puppeteer-core` (not `puppeteer`), which does NOT download its own Chromium. The system has NO Chrome or Chromium installed:

```
chromium: NOT FOUND
chromium-browser: NOT FOUND
google-chrome: NOT FOUND
```

However, Firefox 128.13.0esr IS installed and works in headless mode. Marp supports Firefox as a rendering backend. So PDF export IS feasible -- but through Firefox, not Puppeteer/Chromium. This distinction matters because:

1. The plan's confidence was based on a false premise (Chromium deps present ≠ Chromium present).
2. Firefox rendering can produce slightly different PDF output than Chrome (font metrics, CSS rendering). The presenter should test early (Phase 0) and not assume pixel-perfect results from blog tutorials that all assume Chrome.
3. Marp's Firefox support path is less battle-tested than its Chrome path.

**Verdict on Marp itself:** Still the correct choice. Slidev would be worse here -- Playwright's Firefox support for PDF export is even less reliable than Marp's. Google Slides is excluded by the environment. Keynote is macOS-only. The Marp decision stands, but the plan must correct its reasoning and add a Phase 0 acceptance criterion: "Marp PDF export via Firefox produces correct 16:9 output with Korean text."

### 1.2 Against vhs: The plan's PRIMARY demo tool CANNOT work on this system

This is the most critical finding. **vhs requires TWO external dependencies that are both missing and likely uninstallable:**

1. **ffmpeg** -- NOT installed. `ffmpeg-free` is NOT available in configured dnf repos. `sudo` requires a password (not passwordless). The plan says `sudo dnf install ffmpeg-free` -- this will fail on both counts.
2. **ttyd** -- NOT installed. vhs README states: "VHS requires ttyd and ffmpeg to be installed and available on your PATH." The plan does not mention ttyd at all.

**There is no realistic path to making vhs work in this environment without sudo access.** Building ffmpeg from source is a multi-hour endeavor with many dependencies. A static ffmpeg binary might work, but ttyd also needs to be sourced.

**The plan's fallback (asciinema + agg) is actually the only viable primary path:**
- `asciinema` installs via pip (confirmed: `pip install asciinema` dry-run succeeds).
- `agg` has a pre-built static x86_64 Linux binary -- no ffmpeg needed, no Rust compilation needed.
- The `asciinema` → `agg` pipeline produces GIF from `.cast` files entirely in userspace with zero system dependencies.

**However, asciinema has its own problem:** it records LIVE terminal sessions. You cannot script deterministic demos the way vhs `.tape` files do. For reproducible demos, the presenter would need to either:
- (a) Practice and re-record until the take is clean, or
- (b) Use `expect`/`pv` to feed scripted input (fragile), or
- (c) Use `asciinema-scenario` or similar wrapper (extra dependency).

**Alternative the plan didn't consider: svg-term-cli.** `asciinema` → `svg-term-cli` (npm package, no ffmpeg) produces animated SVG. Marp with `html: true` can embed `<img src="demo.svg">` in HTML output. This avoids GIF entirely. For PDF output, animated SVG won't animate, but a static frame is fine with a "▶ 데모 영상은 HTML 버전에서 확인" caption. This gives:
- HTML slides: animated demos (best for live presentation via browser)
- PDF slides: static frame + caption (best for email distribution)

### 1.3 Against 30 slides in 24 minutes (~48 sec/slide average)

The math is tighter than it appears:
- 3 demo slides at 60 sec each = 180 sec of demo playback
- 3 section dividers at 5 sec each = 15 sec
- That leaves 1245 sec for 24 content slides = **~52 sec/slide**
- But slides #24-25 (한계 종합 + 원칙) require deeper narration -- realistically 90-120 sec combined
- Slides #26-28 (Getting Started) need careful pacing for "practical takeaway" impact -- 60 sec each minimum

**Revised math:** ~900 sec for 18 episode/context slides = **50 sec/slide**. This is feasible for a well-rehearsed presenter but leaves ZERO buffer for:
- Audience reactions/laughter/murmurs (common in Korean corporate presentations)
- Slide transition fumbles
- The presenter pausing to emphasize a point

**Recommendation:** The plan should identify 3-5 slides that can be CUT or MERGED if rehearsal shows time overrun. The FAQ slide (#30) is already marked "(백업)" but no content slides have this safety valve. Candidates:
- Merge #10 (MVCC 이해) into #11 (환각 사례) -- the MVCC episode's main value IS the hallucination story
- Merge #22 (조사 노트 → 문서 변환) into #21 (Greptile 응답) as a "문서 영역 추가 사례" bullet
- This gets you to ~27 slides and a more comfortable 53 sec/slide with buffer

### 1.4 Against 9 episodes across 3 areas

**3 deep stories > 9 thin ones for "사용 전환" success.**

The spec's success criterion is: "개발부 동료 중 N명 이상이 Claude Code를 시도 (실제 사용 전환)." What triggers a developer to try a new tool? Not breadth of use cases -- **one vivid, relatable "holy shit" moment** that maps to their own daily pain.

9 episodes at ~50 sec each means each story gets:
- 15 sec setup ("이런 상황이었다")
- 20 sec "before" pain point
- 15 sec "after" result

That's a Twitter-thread pace, not a compelling narrative. Compare this to giving 3 episodes 2.5 minutes each:
- 30 sec setup with CUBRID-specific context the audience recognizes
- 45 sec "before" pain that the audience has personally felt
- 60 sec demo showing the actual interaction
- 15 sec "after" result + honest caveat

**Counter-argument (steelman for 9 episodes):** The spec explicitly requires "3개 핵심 사용 영역이 각각 구체 에피소드 2~3개." Cutting to 1 per area technically violates the acceptance criteria. The breadth also shows Claude Code is not a one-trick tool.

**Synthesis:** Keep 3 areas, but make each area have 1 "hero" episode (2-3 min with demo) + 1-2 "mention" episodes (single slide, 30 sec, no demo, just a before/after bullet). This satisfies the spec's "2~3개" requirement while giving depth where it matters.

### 1.5 Against "은근한 advocacy" framing

The plan's Principle 1 says "장점 advocacy를 하되, 한계/주의점을 솔직히 다루어 신뢰 확보." This is the right calibration for this audience, but with a nuance the plan doesn't address:

**Risk: The audience already knows the presenter is from AI TFT.** Any "objective report" from the AI team will be received with a built-in credibility discount. The 70:30 ratio is correct, but the **30% honesty must come EARLY** (not saved for slides #24-25 near the end). If the audience sits through 17 slides of success stories before hearing limitations, they'll mentally tag it as "AI팀 홍보" by slide #10, and the late-arriving honesty won't recover that impression.

**The current structure front-loads success and back-loads caveats.** Each area does have an inline limitation slide (#11, #17, #23), which partially addresses this. But the first limitation doesn't appear until slide #11 -- that's ~7 minutes into the talk. Consider moving one visceral failure/limitation into slides #4-5, immediately after "Claude Code란?" -- something like "먼저 솔직하게: 이건 안 됩니다" as a trust-building opener.

---

## 2. Real Tradeoff Tensions

### 2.1 Polish vs. Authenticity (CRITICAL)

The plan calls for vhs `.tape` scripts that produce "deterministic" demos. Even with the fallback to asciinema, there's a fundamental tension:

**A polished, scripted demo of Claude Code** -- with perfect typing speed, no hesitation, instant responses -- **misrepresents the real experience.** Claude Code has 5-30 second thinking pauses, sometimes generates wrong code that needs correction, and the real workflow involves reading and editing AI output. A 30-second GIF showing a smooth input→output flow is essentially a commercial, not a 1인칭 경험담.

**But a raw, unedited recording** would be 3-5 minutes per episode (too long for GIF, too long for the time budget) and would include boring waiting time.

**Tension:** The plan cannot have both "honest 1인칭 experience" AND "30-second polished GIF demos." It must choose, or find a hybrid.

**Proposed synthesis:** Use "edited real recordings" -- record actual Claude Code sessions with asciinema, then edit the `.cast` file (it's JSON-based) to compress wait times (e.g., "Claude is thinking..." gets cut from 20 sec to 3 sec with a visual indicator). This preserves real interaction patterns while fitting the time budget.

### 2.2 Constructed Episodes vs. Presenter-Owned Episodes (HIGH RISK)

The plan lists 9 specific episodes. Open question #4 asks: "9개 에피소드가 발표자의 실제 경험에 기반하는지, 아니면 '있을 법한' 시나리오인지."

**This is not just an open question -- it's a Q&A trap.** If the presenter describes Episode 2-2 (CI shell-test 실패 분석) and a 팀장 asks "그 CI 실패가 어느 PR이었어요?" or "답 파일의 OID 형식이 어떻게 바뀌었는데?", the presenter must have a real answer. Constructed episodes will unravel under drill-down questions, and **the credibility of the entire presentation collapses if one story is exposed as fabricated.**

**This is not resolvable by the plan -- it requires presenter input.** But the plan should:
1. REQUIRE that each episode map to a real, specific, identifiable event (PR number, JIRA ticket, date)
2. Prepare a "drill-down card" per episode with the real details (not in the slides, in the presenter's notes)
3. If any of the 9 episodes is NOT based on real experience, replace it with one that is, or cut it

### 2.3 Time Budget vs. 3 Areas (MATH DOESN'T LIE)

The plan says 1440 sec = 24 min. But this budget has hidden costs:

| Hidden cost | Estimated time |
|---|---|
| Slide-to-slide transitions (30 transitions x 2 sec) | 60 sec |
| GIF loading/buffering (3 demos x 3 sec) | 9 sec |
| Audience murmur/reaction after demos | 30 sec |
| Presenter drink-of-water / pause | 15 sec |
| "다음 영역으로 넘어가겠습니다" bridge narration (2x) | 20 sec |
| **Total hidden overhead** | **~134 sec** |

Actual available content time: 1440 - 134 = **~1306 sec = 21.8 min**. That's at the low end of the 20-25 min target but leaves almost no buffer. If any single episode runs 30 sec over (very likely for the first-time presenter), the talk bleeds past 25 min.

### 2.4 GIF in PDF: File Size vs. Quality

The plan notes this in open questions but doesn't quantify the severity. A 30-45 second terminal GIF at reasonable resolution (1920x1080, 15fps) will be 10-25 MB per GIF. Three GIFs = 30-75 MB. **PDF with embedded GIFs at this size will exceed most email attachment limits (25 MB) and may choke some PDF viewers.**

Options:
- (a) Aggressive GIF optimization (gifsicle, lower resolution/fps) -- quality drops noticeably
- (b) HTML delivery primary, PDF as fallback without animated demos (static screenshots instead)
- (c) Deliver PDF + separate demo files (breaks single-file delivery promise)

The plan should make this decision upfront, not defer to Phase 5 when it's too late to change the demo format.

---

## 3. Principle Violations

### 3.1 Principle 3 ("라이브 리스크 제로") -- Potential violation in demo format

If the presenter uses HTML slides (Marp HTML output) and plays GIFs inline, this requires a browser on the presentation machine. If the presentation machine is different from the dev machine (e.g., a conference room laptop), the browser + HTML file must work there. **This is a mild form of "live risk"** -- not API-dependent, but environment-dependent.

**Fix:** The plan should explicitly state that PDF is the primary delivery format for the projector, and HTML is optional. PDF GIFs won't animate, so the plan needs a strategy: either (a) accept static screenshots in PDF, or (b) use PPTX export (Marp supports it) which embeds GIFs as animations.

### 3.2 Principle 5 ("최소 도구 체인") -- Violated by vhs + ttyd + ffmpeg chain

The plan chose vhs for "minimum toolchain" but vhs actually requires 3 tools (vhs + ttyd + ffmpeg), none of which are installed, and two of which likely require sudo to install. The actual minimum toolchain for demo recording is:

- `pip install asciinema` (1 command, userspace)
- Download `agg` static binary (1 curl command)
- Total: 2 tools, 0 system dependencies, 0 sudo

The plan's primary choice violates its own "최소 도구 체인" principle. The fallback IS the correct primary.

### 3.3 Principle 4 ("CUBRID 현실 기반 에피소드") -- At risk per Open Question #4

If any of the 9 episodes are constructed rather than lived, Principle 4 is violated. The plan acknowledges this risk but doesn't enforce it as a hard gate.

### 3.4 Non-Goal violation check: "AI TFT 메타 워크" leakage

Reviewing the 30-slide outline: **No violation detected.** The episodes correctly focus on developer workflow, not OMC/agent orchestration. Episode 1-2 mentions `/jira` which is a Claude Code command, not an OMC meta-workflow -- this is fine.

### 3.5 Non-Goal violation check: "근거 없는 생산성 수치"

Reviewing episodes: Episode 1-1 says "반나절 → 10분", Episode 2-2 says "2~3시간 → 15분". These are specific and bounded, not "10x" claims. However, they should include caveats like "이 특정 케이스에서" to avoid being generalized. The plan's Guardrails section says "과장된 생산성 수치 X" -- the episodes borderline comply but need explicit qualification.

---

## 4. Synthesis Proposals

### 4.1 Demo Pipeline: asciinema + agg as PRIMARY (not fallback)

**Action:** Promote asciinema + agg to primary. Remove vhs from the plan entirely (or demote to "if ffmpeg becomes available later").

**Pipeline:**
```
asciinema rec --cols 120 --rows 30 demo.cast  # record
# Edit demo.cast JSON to compress wait times
agg demo.cast demo.gif --font-size 16 --theme monokai  # render to GIF
```

**Benefits:**
- Zero system deps (pip + static binary)
- Real interaction captured (authenticity)
- `.cast` file editable for pacing (compress waits, cut mistakes)
- agg also supports `--speed` flag for global speedup

**Tradeoff:** Less deterministic than vhs `.tape` scripts. Mitigate by doing 2-3 takes per demo and selecting the best.

### 4.2 Dual output strategy: HTML primary, PDF backup

**Action:** Present from Marp HTML in browser (GIFs animate). Distribute PDF (GIFs are static screenshots). This cleanly separates the "presentation" use case from the "distribution" use case.

**Benefits:**
- Animated demos in the actual presentation (stronger impact)
- Smaller PDF for email (static screenshots, ~5 MB total)
- No risk of GIF-in-PDF viewer compatibility issues

**Requirement:** Test that the presentation venue has a machine with a browser. Since the presenter's own laptop likely has a browser, this is low risk. Add a "PDF fallback" acceptance criterion: "PDF renders correctly with static demo screenshots."

### 4.3 Episode structure: 1 hero + 1-2 mentions per area

**Action:** For each of the 3 areas, designate:
- 1 "hero" episode: full before/after + demo GIF + honest caveat (2.5 min)
- 1-2 "mention" episodes: single slide, bullet-point before/after, no demo (30-45 sec each)

**Recommended heroes:**
- Area 1: Episode 1-1 (heap_file.c navigation) -- most visceral, universally relatable
- Area 2: Episode 2-2 (CI failure analysis) -- strongest before/after delta
- Area 3: Episode 3-1 (JIRA/PR writing) -- most actionable for audience to try immediately

**Benefits:**
- Depth on 3 stories creates emotional impact → behavior change
- Breadth on 6 mentions satisfies spec requirement
- Saves ~4 min → comfortable time buffer

### 4.4 Front-load one honest limitation (trust anchor)

**Action:** Add a slide between #4 (Claude Code란?) and #5 (세 가지 이야기) titled something like: "먼저 솔직하게: 이것은 마법이 아닙니다" with 2-3 bullet points of key limitations. Then the success stories that follow are received with higher trust.

### 4.5 Marp Firefox testing as Phase 0 hard gate

**Action:** Add to Phase 0 acceptance criteria:
- "Marp PDF export via Firefox produces correct 16:9 slides with Korean text (Noto Sans CJK)"
- "If Firefox PDF export fails, evaluate `marp --pptx` as alternative, or switch to Slidev"
- Test command: `CHROME_PATH=$(which firefox) npx marp slides/test.md --pdf`

---

## 5. Environment Risk Audit

### 5.1 Marp PDF Export

| Factor | Status | Evidence |
|---|---|---|
| Node.js | OK | v25.8.0 via mise |
| npm | OK | v11.11.0 |
| Chrome/Chromium | NOT INSTALLED | `which chromium` → not found |
| Firefox | INSTALLED | v128.13.0esr, headless mode works |
| Puppeteer system libs | PRESENT | gtk3, pango, nss, atk, cups-libs, libX11 all installed |
| Korean fonts | CLAIMED OK | Plan says "Noto Sans CJK already installed" -- not verified by architect |
| Marp uses puppeteer-core | CONFIRMED | Does NOT download own Chromium |
| Firefox headless | WORKS | Tested: `firefox --headless --screenshot` exits 0 |

**Risk level: MEDIUM.** Firefox is available and works headless. But Marp's Firefox rendering path is less commonly tested. The plan's stated rationale ("Puppeteer deps confirmed") is wrong -- it works for a different reason than the plan thinks.

**Mitigation:** Phase 0 must include `CHROME_PATH=$(which firefox) npx marp test.md --pdf` as a hard gate test. If it fails, the plan needs a pivot path.

### 5.2 vhs Demo Recording

| Factor | Status | Evidence |
|---|---|---|
| Go | OK | v1.24.4 via mise |
| vhs binary | NOT INSTALLED | `which vhs` → not found, `go install` possible |
| ffmpeg | NOT INSTALLED | `which ffmpeg` → not found |
| ffmpeg-free in dnf repos | NOT AVAILABLE | `dnf list available ffmpeg-free` → empty |
| sudo | REQUIRES PASSWORD | `sudo -n true` → "a password is required" |
| ttyd | NOT INSTALLED | `which ttyd` → not found |
| Static ffmpeg binary | POSSIBLE but unverified | Would need manual download |
| Static ttyd binary | POSSIBLE but unverified | Would need manual download |

**Risk level: HIGH.** vhs has 3 missing dependencies (vhs itself + ffmpeg + ttyd), 2 of which (ffmpeg, ttyd) cannot be installed via package manager without sudo password. Static binaries are possible but add complexity and fragility.

**Verdict: vhs should NOT be the primary tool.** The plan should use asciinema + agg as primary.

### 5.3 asciinema + agg (Fallback → Should be Primary)

| Factor | Status | Evidence |
|---|---|---|
| pip | OK | pip dry-run for asciinema succeeds |
| asciinema | INSTALLABLE | `pip install asciinema` → would install 2.4.0 |
| agg static binary | AVAILABLE | `agg-x86_64-unknown-linux-gnu` on GitHub releases |
| Rust (for building agg) | AVAILABLE | cargo installed, but static binary preferred |
| ffmpeg needed | NO | agg renders GIF natively |
| System deps | NONE | Pure userspace |

**Risk level: LOW.** This is the only demo recording path that works without system-level changes.

### 5.4 Ultimate Fallback: Static Screenshots + Annotations

**The plan does NOT explicitly include this fallback.** If BOTH vhs AND asciinema+agg fail (e.g., asciinema can't record in this terminal environment for some reason), the presenter needs a plan C.

**Plan C: Screenshots + arrows + 2-line captions.** This is "unfashionable" but:
- Zero technical risk
- Faster to produce than any recording
- Still shows the before/after effectively
- Many excellent technical talks use this format

The plan should include this as an explicit fallback with a decision gate: "If demo GIF recording is not working by Day 3, switch to annotated screenshots."

---

## 6. Verdict

### **ENDORSE_WITH_REVISIONS**

The plan's overall structure, content strategy, tone calibration, and episode selection are sound. The spec is well-understood and the slide outline is thoughtful. However, there are factual errors in the environment assessment and one tool choice that cannot work as specified.

### Required Revisions (7)

1. **[CRITICAL] Promote asciinema+agg to primary demo tool.** Remove vhs as primary. vhs requires ffmpeg + ttyd, neither is installed, ffmpeg-free is not in dnf repos, and sudo requires a password. asciinema+agg works entirely in userspace. Add `.cast` file editing guidance for compressing wait times.

2. **[CRITICAL] Correct the Marp PDF export rationale.** The plan says "Puppeteer deps confirmed" -- this is wrong. No Chrome/Chromium exists. PDF export works via Firefox (installed, headless confirmed). Add `CHROME_PATH=$(which firefox)` to all Marp PDF build commands. Add Firefox PDF rendering test as Phase 0 hard gate.

3. **[HIGH] Add static-screenshot fallback as explicit Plan C.** If asciinema+agg also fails by Day 3, the presenter switches to annotated screenshots with captions. This must be a named decision gate, not hand-waved.

4. **[HIGH] Require presenter confirmation of episode authenticity BEFORE Phase 2.** Each episode must map to a real event with drill-down details (PR number, JIRA ticket, approximate date). This is not just an "open question" -- it's a prerequisite for content phases. If any episode is fabricated, replace it.

5. **[MEDIUM] Restructure episodes to hero+mention format.** 1 hero episode per area (with demo, 2-3 min) + 1-2 mention episodes (no demo, 30-45 sec). This gives depth for impact while maintaining breadth for spec compliance. Saves ~4 min buffer.

6. **[MEDIUM] Address GIF-in-PDF file size strategy upfront.** Decide now: (a) HTML for presentation (animated GIFs), PDF for distribution (static screenshots), or (b) optimized GIFs in both. Don't defer to Phase 5.

7. **[LOW] Front-load one honesty slide before the success stories.** Add a "limitations preview" slide between #4 and #5 to establish trust before 7 minutes of success stories.

---

## References

- Marp CLI uses `puppeteer-core` (not `puppeteer`): `npm info @marp-team/marp-cli dependencies` → `'puppeteer-core': '^24.39.1'`
- Marp requires installed browser: "You have to install any one of Google Chrome, Microsoft Edge, or Mozilla Firefox" (Marp README)
- Firefox installed: `/usr/bin/firefox` → Mozilla Firefox 128.13.0esr
- Firefox headless works: `firefox --headless --screenshot` → exit 0
- No Chrome/Chromium: `which chromium`, `which google-chrome` → NOT FOUND
- No ffmpeg: `which ffmpeg` → NOT FOUND
- ffmpeg-free not in repos: `dnf list available ffmpeg-free` → empty
- sudo requires password: `sudo -n true` → "a password is required"
- No ttyd: `which ttyd` → NOT FOUND
- vhs requires ttyd + ffmpeg: "VHS requires ttyd and ffmpeg to be installed and available on your PATH" (vhs README)
- asciinema installable: `pip install asciinema --dry-run` → would install 2.4.0
- agg has static x86_64 binary: GitHub releases → `agg-x86_64-unknown-linux-gnu`
- agg does NOT need ffmpeg: README lists only Rust as build dependency, no runtime deps for static binary
- Go available: v1.24.4 via mise
- Node.js available: v25.8.0 via mise
- OS: Rocky Linux 9.6
- Puppeteer system libs present: gtk3, pango, nss, atk, cups-libs, libX11 (all via rpm -qa)
- Cargo/Rust available: `/home/vimkim/.cargo/bin/cargo`
- svg-term-cli available: npm registry, v2.1.1
