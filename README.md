# Claude Code Max 2개월 사용 경험 공유 — 발표 자료

**발표자:** 김대현 (CUBRID 개발 2팀 & AI TFT)
**발표 예정:** 2026-04-29 (수) · CUBRID 연구개발본부 전체 대상 · 40분 ~ 1시간
**포맷:** Marp 슬라이드 (PDF 출력) + 스크린샷/코드 스니펫

---

## 빌드 방법

```bash
# 전체 PDF 빌드 (main + FAQ 백업)
just render-pdf

# HTML 프리뷰 (브라우저에서 확인)
just render-html

# 메인 슬라이드만
just render-main-pdf
```

> **참고:** 이 환경에는 Chromium이 없어 Marp가 Firefox headless를 사용합니다. `justfile`이 `CHROME_PATH=$(which firefox)` 를 자동 주입합니다.

## 리허설

```bash
just rehearse
```

스톱워치와 함께 발표 전체를 읽으며 시간을 측정합니다. 목표:
- 전체 발표 50:00 ± 5:00 (Q&A 제외)
- 최대 1:00:00 (Q&A 포함)
- 55:00 초과 시 → 약한 mention 에피소드 narration 단축 (계획서 참조)

## 디렉토리 구조

```
.
├── slides/
│   ├── main.md               # 메인 슬라이드 (v2, 피드백 반영)
│   ├── faq.md                # 11장 FAQ 백업 (B1~B11)
│   └── theme.css             # Marp 테마 (Noto Sans CJK KR)
├── assets/
│   ├── demos/                # 스크린샷/코드 스니펫
│   └── images/               # 스크린샷, 다이어그램
├── episodes/
│   └── episodes-approved.md  # 발표자 승인 에피소드 목록
├── rehearsal/
│   ├── timing-sheet.md       # 리허설 타이밍 기록
│   └── drill-down.md         # Q&A 드릴다운 카드
├── build/
│   └── main.pdf              # 빌드 결과물
├── .omc/
│   ├── specs/                # 발표 스펙 (v2)
│   ├── plans/                # Ralplan v2 + reviews
│   └── logs/                 # Phase 검증 로그
├── justfile                  # 빌드/녹화 레시피
└── README.md
```

## 발표 전 체크리스트

- [ ] `episodes-approved.md`의 TBD drill-down 정보 기입 (PR/JIRA 번호)
- [ ] Hero 1-1 스크린샷/코드 스니펫 준비
- [ ] Hero 2-2 스크린샷/코드 스니펫 준비
- [ ] Hero 3-1 스크린샷/코드 스니펫 준비
- [ ] FAQ B1의 TBD 항목 채우기
- [ ] Pro vs Max 수치 (슬라이드 5) 발표 당일 공식 페이지에서 재확인
- [ ] Max 20x vs API 가성비 수치 (슬라이드 6) 발표 당일 재확인
- [ ] PR 대응 슬라이드 (섹션 4 추가분) TBD PR 번호 기입
- [ ] 리허설 1회 — 타이밍 기록
- [ ] 리허설 2회 — 필요시 cut 적용
- [ ] 발표장 프로젝터에서 PDF 가시성 확인 (큰 폰트, 고대비)
- [ ] 백업: PDF를 USB + 클라우드 양쪽에 둘 것
