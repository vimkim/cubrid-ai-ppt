# CUBRID AI PPT — Build / Record / Rehearsal recipes
# Requires: mise with node@22, Firefox (for Marp PDF), asciinema, agg

set shell := ["bash", "-uc"]

# Ensure Node 22 LTS is on PATH (Node 25 breaks Marp's yargs)
export NODE_BIN := "/home/vimkim/.local/share/mise/installs/node/22.22.2/bin"
# Playwright chromium — Firefox headless does not expose CDP endpoint that Marp puppeteer-core needs.
# `just install-chromium` downloads this binary.
export CHROME_PATH := "/home/vimkim/.cache/ms-playwright/chromium-1217/chrome-linux64/chrome"

# ------------------------------------------------------------------
# Default: list recipes
# ------------------------------------------------------------------
default:
    @just --list

# ------------------------------------------------------------------
# Render: PDF (main + FAQ combined into one deck)
# ------------------------------------------------------------------
render-pdf: _ensure-dirs
    PATH="{{NODE_BIN}}:$PATH" npx --yes @marp-team/marp-cli@latest slides/main.md --pdf --allow-local-files --theme-set slides/theme.css -o build/main.pdf
    PATH="{{NODE_BIN}}:$PATH" npx --yes @marp-team/marp-cli@latest slides/faq.md --pdf --allow-local-files --theme-set slides/theme.css -o build/faq.pdf
    @echo "Built build/main.pdf and build/faq.pdf"

# Single combined PDF (main + FAQ concatenated for distribution)
render-combined: _ensure-dirs
    cat slides/main.md <(echo; echo "---"; echo) slides/faq.md > build/_combined.md
    PATH="{{NODE_BIN}}:$PATH" npx --yes @marp-team/marp-cli@latest build/_combined.md --pdf --allow-local-files --theme-set slides/theme.css -o build/presentation.pdf
    @rm build/_combined.md
    @echo "Built build/presentation.pdf"

# ------------------------------------------------------------------
# Render: HTML for preview
# ------------------------------------------------------------------
render-html: _ensure-dirs
    PATH="{{NODE_BIN}}:$PATH" npx --yes @marp-team/marp-cli@latest slides/main.md --html --allow-local-files --theme-set slides/theme.css -o build/main.html
    PATH="{{NODE_BIN}}:$PATH" npx --yes @marp-team/marp-cli@latest slides/faq.md --html --allow-local-files --theme-set slides/theme.css -o build/faq.html
    @echo "Built build/main.html and build/faq.html"

# ------------------------------------------------------------------
# Serve build/ over HTTP on 0.0.0.0 for remote browser viewing
# ------------------------------------------------------------------
serve port="8000":
    @echo "Serving build/ on http://0.0.0.0:{{port}} (Ctrl-C to stop)"
    @echo "Remote access: http://$(hostname -I | awk '{print $1}'):{{port}}/"
    cd build && python3 -m http.server {{port}} --bind 0.0.0.0

# ------------------------------------------------------------------
# Demo recording: asciinema → agg → GIF
# ------------------------------------------------------------------
record-hero-1-1:
    @echo "녹화 시작: heap_file.c 탐색 (Ctrl-D 로 종료)"
    asciinema rec assets/demos/hero-1-1.cast --overwrite --idle-time-limit 2

record-hero-2-2:
    @echo "녹화 시작: CI 실패 분석 (Ctrl-D 로 종료)"
    asciinema rec assets/demos/hero-2-2.cast --overwrite --idle-time-limit 2

record-hero-3-1:
    @echo "녹화 시작: JIRA 이슈 작성 (Ctrl-D 로 종료)"
    asciinema rec assets/demos/hero-3-1.cast --overwrite --idle-time-limit 2

# .cast → .gif
render-demos:
    @for f in assets/demos/hero-1-1 assets/demos/hero-2-2 assets/demos/hero-3-1; do \
        if [ -f "$f.cast" ]; then \
            echo "Rendering $f.gif"; \
            agg --cols 100 --rows 28 --font-size 16 "$f.cast" "$f.gif"; \
        else \
            echo "Missing $f.cast (skip)"; \
        fi; \
    done

# ------------------------------------------------------------------
# Rehearsal
# ------------------------------------------------------------------
rehearse:
    @echo "리허설 모드: 브라우저에서 HTML 을 연 후 스톱워치를 시작하세요."
    just render-html
    @echo "Open: file://{{justfile_directory()}}/build/main.html"
    @echo "Timing sheet: rehearsal/timing-sheet.md"

# Count estimated speaking time from <!-- timing: NNN --> comments
timing-check:
    @echo "Main 슬라이드 예상 발표 시간:"
    @awk 'match($0, /<!-- timing: ([0-9]+) -->/, arr) { sum += arr[1]; n += 1 } END { printf "  슬라이드 %d개, 합계 %d초 (%d:%02d)\n", n, sum, sum/60, sum%60 }' slides/main.md
    @echo "(목표: 40:00~50:00 / 2400~3000초, Q&A 제외)"

# ------------------------------------------------------------------
# One-time install of Playwright chromium (only if CHROME_PATH is missing)
# ------------------------------------------------------------------
install-chromium:
    PATH="{{NODE_BIN}}:$PATH" npx --yes playwright install chromium

# ------------------------------------------------------------------
# Phase 0 verification (re-runnable)
# ------------------------------------------------------------------
verify-tools:
    @echo "=== Tool verification ==="
    @echo -n "firefox: " && which firefox
    @echo -n "node 22: " && {{NODE_BIN}}/node --version
    @echo -n "asciinema: " && asciinema --version
    @echo -n "agg: " && agg --version
    @echo -n "Noto CJK KR: " && fc-list :lang=ko | grep -c "Noto Sans CJK KR" | xargs -I{} echo "{} variants"

# ------------------------------------------------------------------
# Internal
# ------------------------------------------------------------------
_ensure-dirs:
    @mkdir -p build assets/demos assets/images rehearsal

clean:
    rm -rf build

# ------------------------------------------------------------------
# Full smoke build (Phase 0/4)
# ------------------------------------------------------------------
smoke:
    just verify-tools
    just render-pdf
    just timing-check
