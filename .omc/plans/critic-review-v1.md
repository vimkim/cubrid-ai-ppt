# Critic Review: Claude Code 1개월 현황 보고 발표 자료 제작 Plan v1

**Reviewer:** Critic Agent
**Date:** 2026-04-20
**Plan under review:** `ralplan-draft-v1.md`
**Spec:** `deep-interview-claude-code-intro-presentation.md`
**Architect review:** `architect-review-v1.md`

---

## VERDICT: ITERATE

**Overall Assessment:** The plan is structurally sound — the spec is well-understood, the slide outline is thoughtful, the episode selection covers the right domains, and the guardrails are correctly calibrated. However, the plan was written before the Architect review and contains two factual errors about the environment (Chromium availability, vhs feasibility) that make it unexecutable as-is. The Architect's 7 required revisions are substantive and none are yet integrated. The plan is absolutely rescuable within the 7-day deadline — the structure is right, the corrections are surgical.

---

## 1. Principle-Option Consistency

### Principle 1: 정직한 70:30 톤 — PASS with caveat

The plan allocates 3 limitation slides (#11, #17, #23) inline with episode areas plus a consolidated section (#24-25). This gives roughly 3 limitation mentions across 9 episodes — that's 33%, which hits the 30% target. The Architect correctly notes that the first limitation doesn't appear until slide #11 (~7 min in), risking "AI팀 홍보" perception. The plan should integrate the Architect's proposal for a trust-anchor limitation slide between #4 and #5.

**Episode time claims** (e.g., "반나절 → 10분", "2~3시간 → 15분") are specific and bounded, not "10x" blanket claims. They borderline comply with the "no exaggerated productivity numbers" guardrail but need per-case qualification like "이 특정 케이스에서." This is MINOR.

### Principle 2: 개발자 친화 git-관리 가능 포맷 — PASS

Marp + single `main.md` + git repo. Consistent throughout the plan. No violation.

### Principle 3: 라이브 리스크 제로 — PASS with one gap

All demos are pre-recorded GIFs. No live Claude Code session. However, the plan does not address the Architect's observation: if the presenter uses HTML output (for animated GIFs), they need a browser on the presentation machine. The plan should explicitly declare PDF as primary delivery format for the projector, with HTML as optional. This is a latent Principle 3 risk.

### Principle 4: CUBRID 현실 기반 에피소드 — AT RISK

Open Question #4 asks whether the 9 episodes are real or constructed. The plan treats this as an "open question" rather than a **hard prerequisite**. This directly threatens Principle 4. If even one episode is fabricated and exposed during Q&A, credibility of the entire presentation collapses. The Architect's Required Revision #4 (presenter confirmation before Phase 2) must be integrated as a blocking gate.

### Principle 5: 최소 도구 체인 — VIOLATED

The plan's primary demo tool (vhs) requires vhs + ttyd + ffmpeg — three tools, none installed, two requiring sudo. This is the opposite of "최소 도구 체인." The fallback (asciinema + agg) is 2 tools, both userspace-installable, zero system dependencies. The plan's own principle demands that asciinema+agg be the primary choice, not the fallback. The Architect's Required Revision #1 is correct and must be adopted.

---

## 2. Fair Alternatives

### Marp vs. Slidev — FAIR

The plan's rejection of Slidev is substantive: Playwright PDF export is less reliable than Marp's Puppeteer path, Vue learning cost is nonzero, and the 1-week timeline makes simplicity decisive. The Architect's steelman (section 1.1) tested this and concluded "Slidev would be worse here." The rejection is fair, not strawmanned. However, the plan's *rationale* for Marp is wrong (claims "Puppeteer deps confirmed" when no Chrome/Chromium exists). The correct rationale is: Marp works via Firefox headless, which IS installed. The plan must correct this factual error.

### Marp vs. Reveal.js — FAIR

"Requires more manual HTML scaffolding" is accurate. Reveal.js has no CLI PDF export without additional tooling. Fair rejection.

### Marp vs. Keynote — FAIR

macOS only. Presenter is on Rocky Linux. Trivially correct.

### Marp vs. Google Slides — FAIR

Not git-manageable, no CLI build. Correctly flagged as Principle 2 violation. Fair.

### vhs vs. asciinema+agg — UNFAIR (reversed)

The plan chose vhs as primary and asciinema+agg as fallback, but the environmental evidence shows vhs cannot work without sudo (ffmpeg-free not in repos, ttyd not installed, sudo requires password). The plan's comparison table lists vhs advantages (deterministic, .tape scripts) without verifying the prerequisites. The Architect proved this decisively. The plan must reverse this decision.

### Missing alternative: svg-term-cli

The Architect raised `svg-term-cli` as an alternative the plan didn't consider (asciinema → SVG, embeddable in HTML slides). The plan should acknowledge this option even if it's not selected — it's relevant for the GIF-in-PDF file size problem.

---

## 3. Risk Mitigation

### Risk: Demo tooling failure

| Aspect | Plan status |
|---|---|
| Probability named? | No — plan says "Note: vhs requires ffmpeg" but doesn't rate probability |
| Impact named? | No |
| Concrete mitigation? | Partial — fallback exists but is mislabeled (should be primary) |
| Phase 0 validation? | Partial — "vhs --version 실행됨" but doesn't test the full pipeline (record + render) |

**Gap:** The plan must include a Phase 0 acceptance criterion that runs the FULL demo pipeline end-to-end: record a 5-second test → render to GIF → verify GIF renders in Marp slide. Not just "tool --version works."

### Risk: Marp Firefox-headless dependency

| Aspect | Plan status |
|---|---|
| Probability named? | No — plan claims "Puppeteer deps confirmed" (factually wrong) |
| Impact named? | No |
| Concrete mitigation? | No |
| Phase 0 validation? | No — plan tests `npx marp slides/main.md --pdf` but doesn't specify `CHROME_PATH=$(which firefox)` |

**Gap:** CRITICAL. The plan's build command `npx marp slides/main.md --pdf` will FAIL because Marp uses `puppeteer-core` which does NOT download its own Chromium, and no Chrome/Chromium is installed. The plan must add `CHROME_PATH=$(which firefox)` to all Marp commands and test Korean text rendering in Phase 0.

### Risk: Episode authenticity

| Aspect | Plan status |
|---|---|
| Probability named? | No |
| Impact named? | Partially — Open Question #4 mentions it |
| Concrete mitigation? | No — "발표자 확인 필요" is not a mitigation, it's a TODO |
| Phase 0 validation? | No — not even in Phase 0 |

**Gap:** This must be a hard gate BEFORE Phase 2 (content creation). Each episode must have a real PR/JIRA/date reference, or be replaced. The plan should add a "Phase 0.5: Presenter Episode Validation" step.

### Risk: Time budget overrun

| Aspect | Plan status |
|---|---|
| Probability named? | No |
| Impact named? | Implicitly — 24 min target stated |
| Concrete mitigation? | Phase 6 rehearsal exists, but no "cut list" of expendable slides |
| Phase 0 validation? | N/A (runtime risk) |

**Gap:** The Architect's math shows hidden overhead (~134 sec for transitions, reactions, pauses) reducing effective content time to ~21.8 min. The plan should identify 3-5 slides that can be cut or merged if rehearsal exceeds 22 min. Currently no such safety valve exists for content slides.

---

## 4. Testable Acceptance Criteria

### Render command — INCOMPLETE

Phase 0 says `npx marp slides/main.md --pdf` but this command will fail without `CHROME_PATH=$(which firefox)`. The corrected command must be:
```
CHROME_PATH=$(which firefox) npx marp slides/main.md --pdf --allow-local-files
```

### Demo play command — MISSING

No acceptance criterion verifies that a recorded demo GIF actually renders correctly when embedded in a Marp slide. The plan should add: "Build PDF/HTML with embedded test GIF → verify GIF displays."

### Timing measurement — PRESENT but weak

Phase 6 includes "전체 24분 내 맞는지 확인" but doesn't specify HOW timing is measured (stopwatch? built-in timer? slide notes with timestamps?). It also doesn't specify what happens if timing exceeds 25 min — which slides get cut?

### Q&A FAQ sheet — PRESENT but thin

Slide #30 is marked "예상 질문 5~7개 + 짧은 답변 (보안? 비용? 기존 도구와 차이?)". This is a placeholder, not concrete content. The plan should list the actual anticipated drill-down questions. Based on the spec and audience:
- "어느 PR이었어요?" / "JIRA 티켓 번호가 뭐예요?"
- "프롬프트를 좀 보여주세요"
- "한글이 깨지는 경우는 없었나요?"
- "비용이 얼마나 드나요? (Max 플랜 가격)"
- "보안/IP 이슈는 어떻게 관리했나요? 코드가 외부로 나가나요?"
- "기존 cscope/ctags 대비 구체적으로 뭐가 나은 건가요?"
- "환각률이 체감 얼마나 되나요?"

The plan should enumerate these in the FAQ slide content specification, not leave them as "(보안? 비용? 기존 도구와 차이?)" placeholders.

---

## 5. Verification Steps

The plan needs explicit verification steps that autopilot will run before declaring done. Current status:

| Verification step | Present in plan? | Status |
|---|---|---|
| `CHROME_PATH=$(which firefox) npx marp slides/*.md --pdf` exits 0 | NO (wrong command in plan) | MUST ADD |
| Demo tool works (asciinema+agg pipeline end-to-end) | NO (only `vhs --version`) | MUST ADD |
| Total demo playback time measured and fits budget | NO | MUST ADD |
| Dry-run rehearsal timer recorded | YES (Phase 6) | Needs specificity |
| Presenter sign-off on episode list before content generation | NO (open question, not gate) | MUST ADD |
| PDF file size check (< 25MB for email) | NO (deferred to Phase 5) | SHOULD ADD to Phase 5 acceptance |
| Korean text renders correctly in PDF | NO | MUST ADD to Phase 0 |
| GIF displays correctly in built slide | NO | MUST ADD to Phase 0 |

---

## 6. Architect Integration Gap

The Architect issued 7 required revisions. None are integrated into the plan (expected — plan predates the review). Here is the gap analysis:

| # | Architect Revision | Integrated? | Action needed |
|---|---|---|---|
| 1 | CRITICAL: Promote asciinema+agg to primary, remove vhs | NO | Rewrite Section 1 demo tool decision, ADR, Phase 0, all .tape references |
| 2 | CRITICAL: Correct Marp PDF export rationale, add `CHROME_PATH`, Firefox test gate | NO | Rewrite Section 1 slide tool rationale, update all `npx marp` commands, add Phase 0 gate |
| 3 | HIGH: Add static-screenshot fallback as Plan C with Day 3 decision gate | NO | Add to Section 1 fallback chain + Phase 2 decision gate |
| 4 | HIGH: Require presenter episode confirmation before Phase 2 | NO | Add Phase 0.5 or Phase 1 gate |
| 5 | MEDIUM: Restructure to hero+mention episode format | NO | Revise Section 2 episodes, Section 3 slide outline, timing math |
| 6 | MEDIUM: Address GIF-in-PDF file size upfront | NO | Add decision to Section 1 or Section 4, not defer to Phase 5 |
| 7 | LOW: Front-load one honesty slide | NO | Add slide between #4 and #5 in Section 3 outline |

All 7 revisions are substantive and well-evidenced. The Planner must integrate all of them in v2.

---

## 7. Tone Audit

| Check | Result |
|---|---|
| AI TFT meta-work (OMC, multi-agent) highlighted? | NO — correctly excluded. Episode 1-2 mentions `/jira` which is a Claude Code command, not OMC meta-work. PASS. |
| "10x / N배 빨라짐" claim without measurement? | NO — time comparisons are specific ("반나절 → 10분", "2~3시간 → 15분") with per-case context. Borderline PASS — add "이 특정 케이스에서" qualifiers. |
| Implied live-on-stage Claude Code? | NO — all demos pre-recorded. PASS. |
| Aggressive Copilot/Cursor/Codex comparison? | NO — not mentioned anywhere. PASS. |
| "AI가 대필한 일반론" feel? | LOW RISK — episodes are CUBRID-specific (heap_file.c, .ctl tests, OOS, vacuum). Not generic AI tool pitches. PASS. |

**Tone is well-calibrated.** No violations detected. The only improvement is adding per-case qualifiers to time comparisons.

---

## 8. Additional Findings

### MAJOR: `.cast` file editing guidance missing

The Architect proposed editing asciinema `.cast` files (JSON-based) to compress wait times for authenticity-preserving demos. The plan currently has no guidance on this. If asciinema becomes primary, the plan must include:
- How to edit `.cast` files to compress Claude Code thinking pauses
- Target demo length per recording (30-45 sec after editing)
- Whether to use `agg --speed` flag or manual JSON editing

### MAJOR: No rollback/pivot path documented per phase

If Phase 2 demo recording fails (asciinema can't capture properly in this terminal), the plan has no documented pivot. The Architect's "annotated screenshots" Plan C should be added with a concrete trigger: "If demo recording is not working by end of Day 3, switch to annotated screenshots."

### MINOR: `scripts/build.sh` content not specified

The plan lists `scripts/build.sh` in the repo layout but doesn't specify its content. It should contain the corrected `CHROME_PATH=$(which firefox) npx marp ...` command.

### MINOR: `scripts/record-demos.sh` references vhs

The repo layout shows `scripts/record-demos.sh` described as "전체 데모 일괄 녹화" — this needs to be rewritten for asciinema+agg pipeline after the tool pivot.

### MINOR: Parallelization map is overly optimistic

The plan shows Phase 2+3 as potentially parallel "if 2 agents" but then correctly notes autopilot is single-agent. The 7-day timeline is feasible for sequential execution but has zero buffer days. If any phase slips by 1 day, the plan hits the deadline with no rehearsal.

---

## 9. Required Changes for Planner v2

### CRITICAL (blocks execution)

1. **Promote asciinema+agg to primary demo tool.** Remove vhs as primary throughout: Section 1, ADR, Phase 0 acceptance, repo layout (`assets/tapes/` → `assets/casts/`), `scripts/record-demos.sh`. Add `.cast` file editing guidance for compressing wait times.
   - **Why:** vhs requires ffmpeg + ttyd, neither installable without sudo. Principle 5 violation.
   - **Acceptance check:** Plan contains no reference to vhs as primary. asciinema+agg install commands are in Phase 0. Full pipeline test (record → render → embed) is in Phase 0 acceptance.

2. **Correct Marp PDF export path.** Replace all `npx marp` commands with `CHROME_PATH=$(which firefox) npx marp`. Correct the rationale from "Puppeteer deps confirmed" to "Firefox headless is available and Marp supports it as a rendering backend." Add Phase 0 gate: test PDF export with Korean text + 16:9 layout via Firefox.
   - **Why:** No Chrome/Chromium installed. Current commands will fail.
   - **Acceptance check:** Every `npx marp` command in the plan includes `CHROME_PATH=$(which firefox)`. Phase 0 acceptance includes "PDF renders correctly with Korean text via Firefox."

3. **Add presenter episode validation as a blocking gate before Phase 2.** Each of the 9 episodes must be confirmed as based on a real event with drill-down details (PR number, JIRA ticket, approximate date). If any episode is fabricated, it must be replaced with a real one.
   - **Why:** Fabricated episodes will unravel under Q&A. Principle 4 violation risk.
   - **Acceptance check:** Plan includes a "Phase 0.5" or "Phase 1 gate" step where presenter confirms each episode with at least one verifiable reference.

### MAJOR (causes significant rework if not addressed)

4. **Add static-screenshot fallback (Plan C) with Day 3 decision gate.** If asciinema+agg demo recording is not producing usable GIFs by end of Day 3, pivot to annotated screenshots with captions.
   - **Why:** No fallback if demo recording fails entirely means the plan has a single point of failure for 3 demo slides.
   - **Acceptance check:** Plan names "annotated screenshots" as Plan C with a concrete Day 3 trigger.

5. **Address GIF-in-PDF file size strategy NOW, not in Phase 5.** Decide upfront: (a) HTML for presentation (animated GIFs), PDF for distribution (static screenshots), or (b) optimized GIFs in both formats. Add the decision to Section 1.
   - **Why:** Deferring to Phase 5 means discovering a 75MB PDF too late to change the demo format.
   - **Acceptance check:** Plan Section 1 includes a "Delivery Format Decision" with explicit strategy for both presentation and distribution use cases.

6. **Add slide cut list for time budget overrun.** Identify 3-5 slides that can be cut or merged if rehearsal shows timing > 22 min. The Architect's candidates (merge #10 into #11, merge #22 into #21) are good starting points.
   - **Why:** Tight time budget (21.8 min effective after hidden overhead) with zero buffer.
   - **Acceptance check:** Plan Section 3 includes a "Cut candidates" list with 3+ slides marked as mergeable/removable.

7. **Front-load one honesty slide.** Add a "limitations preview" slide between #4 and #5 (before the success stories start). Something like "먼저 솔직하게: 이건 안 됩니다" with 2-3 bullet points.
   - **Why:** First limitation currently doesn't appear until slide #11 (~7 min in). Audience may mentally tag the talk as "AI팀 홍보" before then.
   - **Acceptance check:** Slide outline includes a limitations preview slide in positions #4-#6 (before first episode).

### MINOR (suboptimal but functional)

8. Restructure episodes to hero+mention format (1 hero with demo + 1-2 mentions without demo per area). This creates depth for impact while maintaining breadth for spec compliance.

9. Enumerate concrete FAQ questions in slide #30 spec (not just "보안? 비용?" placeholders).

10. Add per-case qualifiers ("이 특정 케이스에서") to time comparison claims in episodes.

11. Specify `scripts/build.sh` content with the corrected Marp command.

12. Add a buffer day to the parallelization map or explicitly note "zero buffer — any 1-day slip means rehearsal is compressed."

---

## 10. Verdict Justification

**ITERATE** — not REJECT, because:
- The plan's structure, episode selection, tone calibration, and guardrails are genuinely good work
- The spec is thoroughly understood and correctly translated into a slide outline
- The 7 Architect revisions are surgical corrections, not fundamental redesigns
- All issues are fixable in a single revision pass (< 2 hours of planner work)
- The 7-day deadline is still achievable after corrections

**Not ACCEPT or ACCEPT-WITH-RESERVATIONS** because:
- Two CRITICAL factual errors make the plan unexecutable as-is (Marp command will fail, vhs cannot be installed)
- Architect's 7 revisions are substantive and none are integrated
- Episode authenticity is treated as an open question rather than a hard gate
- Missing verification steps mean autopilot would declare success without proving the output works

**Review mode: THOROUGH** (not escalated to ADVERSARIAL). The issues found are factual environment mismatches and missing integration of Architect feedback — they're systematic in origin (plan written before environment audit) but not indicative of careless or flawed thinking. The plan's reasoning quality is high; the inputs were incomplete.

**Realist Check applied:**
- CRITICAL findings (Marp command failure, vhs infeasibility) are genuine execution blockers — running `npx marp slides/main.md --pdf` without CHROME_PATH will produce an error, not a PDF. No mitigation exists without the fix. Severity confirmed.
- MAJOR findings are not execution blockers but would cause significant rework if discovered late (e.g., 75MB PDF discovered in Phase 5, fabricated episode exposed in Q&A). Severity confirmed.

---

## Open Questions (unscored)

- Does `CHROME_PATH=$(which firefox) npx marp test.md --pdf` actually produce correct output on this system? The Architect confirmed Firefox headless works, but Marp's Firefox rendering path is less battle-tested. Phase 0 will answer this definitively.
- Can asciinema record properly in this tty+X11 forwarding environment? Likely yes (asciinema records pty output, not screen pixels), but Phase 0 should verify.
- The Architect suggested `svg-term-cli` as an alternative to agg for animated SVG output. Worth evaluating if GIF file sizes are problematic, but not a required change for v2.
- The hero+mention episode restructuring (Architect Revision #5) is marked MINOR because the current 9-episode structure technically satisfies the spec. However, it would significantly improve presentation impact. Planner should consider it seriously.
