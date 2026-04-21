# Open Questions

## claude-code-intro-presentation - 2026-04-20 (Updated for v2)

### BLOCKING (must resolve before content generation)

- [ ] **에피소드 실제 경험 여부** — 9개 에피소드가 발표자(김대현)의 실제 경험 기반인지 확인 필요. 각 에피소드에 대해 관련 PR/JIRA/날짜를 매핑해야 함. Phase 0 hard gate. 실제 경험이 아닌 에피소드는 발표자의 실제 경험으로 교체 필수. Q&A에서 "어느 PR이었어요?" 질문에 답할 수 있어야 함.
- [ ] **CUBRID 소스 코드 접근 경로** — 데모 녹화 시 실제 CUBRID worktree가 필요. 발표자의 작업 디렉토리 경로 확인 필요.

### NON-BLOCKING (Phase 4+ 에서 확인)

- [ ] **PDF 크기 제한** — HTML primary + PDF backup(정적 프레임) 전략으로 리스크 완화됨. Phase 4에서 최종 PDF 크기 확인 (< 25MB 목표).
- [ ] **vhs 설치 가능성** — stretch goal only. sudo 접근 가능해지면 재평가하지만, 현재 계획에 영향 없음.

### RESOLVED (v2에서 해결됨)

- [x] **Marp Firefox 호환성** — Firefox 128.13.0esr headless 사용 확정. `CHROME_PATH=$(which firefox)` 접두사. Phase 0 smoke test로 최종 검증.
- [x] **데모 도구 선택** — asciinema+agg primary, 정적 스크린샷+Pillow fallback, vhs stretch. 확정.
- [x] **ffmpeg 설치 권한** — 불필요. asciinema+agg 파이프라인은 ffmpeg 없이 동작. vhs는 stretch goal로 강등.
- [x] **vhs 터미널 호환성** — vhs가 primary에서 제외되어 더 이상 blocking 아님.

### FROM ANALYST (v1에서 이관)

- [ ] **Max 플랜 가격 정보 정확성** — FAQ B4에서 "$100 또는 $200"으로 기재. 발표 시점의 최신 가격 확인 필요.
- [ ] **Anthropic 데이터 정책 정확성** — FAQ B5에서 "입력 데이터를 학습에 사용하지 않음"으로 기재. 발표 시점의 최신 정책 확인 필요.
