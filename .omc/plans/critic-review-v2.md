# Critic Review v2: Claude Code 1개월 현황 보고 발표 자료 제작 Plan v2

**Reviewer:** Critic Agent
**Date:** 2026-04-20
**Plan under review:** `ralplan-v2.md`
**Spec:** `deep-interview-claude-code-intro-presentation.md`
**Architect review:** `architect-review-v2.md`
**Previous critic review:** `critic-review-v1.md`

---

## VERDICT: APPROVE

---

## 1. 12-Item Check Table (v1 Required Changes)

| # | Severity | v1 Requirement | v2 Status | Evidence |
|---|----------|----------------|-----------|----------|
| 1 | CRITICAL | Promote asciinema+agg to PRIMARY demo tool; remove vhs as primary | **ADDRESSED** | Section 2 (L78): asciinema+agg table header says "(PRIMARY)", vhs says "(STRETCH)". L89: "Demoted to stretch goal." L107-109: "DO NOT plan around this. DO NOT block on this." All `.tape` references removed from primary workflow. |
| 2 | CRITICAL | Correct Marp PDF export — add `CHROME_PATH=$(which firefox)` to ALL commands; fix rationale | **ADDRESSED** | 12 occurrences of `CHROME_PATH=$(which firefox)` across the plan (L17, L129, L134, L157, L160, L252, L275, L286, L308, L368, L369, L654). Rationale corrected at L129: "Firefox 128.13.0esr이 headless로 작동 확인됨." Phase 0 smoke test at L286. |
| 3 | CRITICAL | Add presenter episode validation as BLOCKING GATE before content creation | **ADDRESSED** | L280: bold text "이 게이트를 통과하지 못하면 Phase 1 진입 불가." Gate is in Phase 0 (even stricter than my v1 ask of "before Phase 2"). All 9 episodes marked `[NEEDS PRESENTER CONFIRMATION]` (L425-478). `episodes/episodes-approved.md` in repo layout (L250). Verification matrix row at L293. |
| 4 | MAJOR | Add static-screenshot fallback (Plan C) with Day 3 decision gate | **ADDRESSED** | Dedicated "Demo Fallback" section (L99-105) with gnome-screenshot + Pillow commands (L194-213). Day 3 decision gate at L325. Pivot path in Section 11 (L677). |
| 5 | MAJOR | Address GIF-in-PDF file size strategy NOW, not in Phase 5 | **ADDRESSED** | Change log C14 (L29): "HTML for presentation (animated), PDF for distribution (static frame + caption)." Phase 4 verification at L360: "정적 프레임 + '▶ 사전 녹화 데모 (HTML 버전에서 재생 가능)' 캡션 확인." Decision is upfront, not deferred. |
| 6 | MAJOR | Add slide cut list for time budget overrun | **ADDRESSED** | L529-535: 4-tier cut priority list. Includes "절대 cut 금지" items (#5, #19-20, #21). Phase 6 rehearsal gate at L398: "23:00 +/- 2:00." Section 10 (L626) has concrete math for cuts: "Cut 2 mention slides (saves ~1:40) + compress hero setups (saves ~0:45) = total savings ~2:25." |
| 7 | MAJOR | Front-load one honesty slide before success stories | **ADDRESSED** | Slide #5 (L492): "먼저 솔직하게: 이것은 마법이 아닙니다" — positioned at slot #5, before any episode content. Contains 3 핵심 한계 + trust anchor framing. |
| 8 | MINOR | Restructure to hero+mention episode format | **ADDRESSED** | Section 7 (L419-478): 3 heroes with demos + 6 mentions without demos. Slide outline (L486-512) reflects the pattern consistently: hero setup → demo → mentions per area. Change log C4 (L19). |
| 9 | MINOR | Enumerate concrete FAQ questions (not placeholders) | **ADDRESSED** | Section 9 (L539-593): All 8 FAQ questions have concrete 1-sentence answers with 2-3 backup bullets. Questions cover: episode drill-down, prompt examples, Korean/UTF-8, cost/license, security/IP, tool comparison, hallucination frequency, learning curve. |
| 10 | MINOR | Add per-case qualifiers to time comparison claims | **ADDRESSED** | All hero episodes include "이 특정 케이스에서" or "이 특정 경험에서" qualifiers (L428, L447, L466). Guardrails section (L709): "모든 before/after 비교에 '이 특정 케이스에서' 한정어". |
| 11 | MINOR | Specify `scripts/build.sh` content with corrected Marp command | **ADDRESSED** | L252: `build.sh` described as "CHROME_PATH=$(which firefox) npx marp ...". Full command in Section 4 (L157-160). |
| 12 | MINOR | Add buffer day or explicitly note zero-buffer timeline risk | **PARTIALLY** | No explicit buffer day added. However, effective mitigation exists: time budget shows 4:11 buffer to 25:00 max (L621), cut priority list (L529-535), and Phase 6 rehearsal with explicit pass/fail criterion (L398). The Architect rated this PARTIALLY and accepted it. |

**Score: 3/3 CRITICAL addressed. 4/4 MAJOR addressed. 4/5 MINOR addressed, 1 PARTIALLY. No blockers.**

---

## 2. Tone/Non-Goal Violation Check

| Check | Result | Evidence |
|---|---|---|
| No "N배" language | **PASS** | Grep for `[0-9]+배` found only the guardrail itself (L716: "N배 빨라졌다 식의 배수 표현 — 질적 프레이밍만 허용") and change log (L27). No episode or slide content uses multiplier claims. |
| No live-on-stage implication | **PASS** | All demo references use "사전 녹화" phrasing. Guardrails (L712-713) explicitly ban "실제로 돌려보면", "지금 바로 시도해보겠습니다". Verification checks at L310, L376 include grep commands to enforce this. |
| No AI TFT meta-work emphasis | **PASS** | Only mention of OMC is `.omc/` directory in repo layout (L259, infrastructure). Guardrails (L714): "OMC/agent orchestration 메타 워크 언급" in Must NOT Have. |
| No aggressive comparison | **PASS** | Copilot/Cursor/Codex appear only in FAQ B6 (L574-579) with explicitly neutral framing: "공정한 비교는 어렵습니다." Guardrails (L715): "Copilot/Cursor/Codex 공격적 비교 (중립 톤 FAQ에서만)". |

**All tone checks pass. No violations.**

---

## 3. Structural Verification

### `episodes-approved.md` gate blocks Phase 1+
**CONFIRMED.** L280: "이 게이트를 통과하지 못하면 Phase 1 진입 불가." The gate is in Phase 0, which is stricter than the original requirement.

### Q&A FAQ has actual short answers for all 8 mandatory questions
**CONFIRMED.** Section 9 (L539-593) contains 8 subsections (B1-B8), each with a bold `**답변**:` line containing a 1-sentence answer, followed by 2-3 explanatory bullets.

### Time budget math sums to ≤25:00 speaking
**CONFIRMED with minor discrepancy.** Independent verification:
- Slide table per-slide seconds sum: 940s (15:40)
- Plan claims "Raw slide content: 15:50" (950s) -- 10-second discrepancy, likely rounding
- Plan total with demos + overhead: 20:49
- Buffer to 25:00 max: 4:11 -- comfortable
- The 10-second rounding error is inconsequential. Even adding it, total stays well under 25:00.
- The Architect noted this as a documentation clarity issue (Section 8 table showing "24:30" vs Section 10 showing "20:49"). Both are internally defensible under different counting methods (per-slide inclusive vs component breakdown). Not a blocker.

---

## 4. New Issues Scan

### No new CRITICAL or MAJOR issues found.

I checked for:
- **vhs leaking into primary workflow**: All vhs references are correctly scoped to "STRETCH" or "NOT assumed" sections. No Phase task depends on vhs.
- **Missing environment prerequisites**: Section 11 environment risk audit is thorough with verified/assumed/pivot categories. All verified items have evidence commands.
- **Circular dependencies between phases**: Phase flow is linear (0→1→2→3→4→5→6) with clear blocking gates. No circular deps.
- **Spec compliance**: All acceptance criteria from the spec are traceable to plan content (3 areas with 2-3 episodes each, before/after comparisons, limitations section, Getting Started guide, FAQ backup, 25-35 slides, pre-recorded demos, Korean with English terms, 16:9, code highlights).

### MINOR: Time budget table note (Architect's suggestion)
The Architect correctly identified that "Total: 24:30" in the slide table (L514) and "Total speaking time: 20:49" in Section 10 (L620) may confuse an executor. A 1-line clarifying note would help. This is a documentation cosmetic fix, not a structural issue. Acceptable to fix during execution.

---

## 5. Verdict Justification

**APPROVE.** Rationale:

1. All 3 CRITICAL items from v1 are fully ADDRESSED with concrete evidence.
2. All 4 MAJOR items from v1 are fully ADDRESSED.
3. 4 of 5 MINOR items are ADDRESSED; 1 (buffer day) is PARTIALLY addressed but adequately mitigated by the 4:11 time buffer and cut priority list.
4. No new blocking or major issues emerged in v2.
5. Tone/non-goal checks all pass cleanly.
6. The plan is executable: every command is correct for the verified environment, every phase has verification steps, every critical dependency has a fallback chain with a named pivot trigger.
7. The Architect's ENDORSE_WITH_MINOR_REVISIONS verdict aligns -- the single remaining item (time table clarifying note) is cosmetic.

**Review mode: THOROUGH** (not escalated to ADVERSARIAL). v2 addressed all findings from v1 systematically. No pattern of systemic issues remains.

**Realist check:** The PARTIALLY addressed item #12 (buffer day) was pressure-tested. Realistic worst case: a 1-day slip compresses rehearsal from 2 hours to 1 hour. Mitigated by: the cut priority list means the presenter knows exactly what to trim, and the 4:11 time buffer means even an unrehearsed run is unlikely to exceed 25:00. Not worth blocking the plan for.

---

## 6. Nice-to-Have Items for Autopilot (0-5, non-blocking)

1. **Add clarifying note after slide table "Total: 24:30"** — explain that Section 10 has the authoritative breakdown (20:49 effective + 4:11 buffer). Prevents executor confusion. (Architect's suggestion.)
2. **Consider `svg-term-cli`** as an alternative to `agg` if GIF file sizes become problematic during Phase 2. Lower priority since PDF already uses static frames.
3. **Add explicit "zero-buffer" note to Phase timeline** — the plan has no spare days. If any phase slips, rehearsal compresses. This is a known risk, not a flaw, but worth documenting explicitly.
4. **FAQ B1 answer is presenter-dependent** — the "답변" currently says "네, 구체적으로 말씀드리면..." which defers to presenter notes. Once `episodes-approved.md` is populated, the FAQ slide content should reference specific PR/JIRA numbers, not just point to the file.

---

## Handoff Notes for Autopilot

- **Start with Phase 0.** Do not skip the episode authenticity gate. It blocks everything.
- **The `CHROME_PATH=$(which firefox)` pattern is critical.** Every Marp command must include it. The plan is consistent on this -- do not drop it.
- **Day 3 is the demo decision gate.** If asciinema+agg GIFs are not satisfactory by end of Day 3, pivot immediately to static screenshots + Pillow annotation. Do not wait.
- **Rehearsal pass criterion is 23:00 +/- 2:00.** If over 25:00, follow the cut priority list at Section 8. Never cut slides #5, #19-20, or #21.
- **The Architect's minor doc fix** (time table clarifying note) can be applied during Phase 4 integration.
