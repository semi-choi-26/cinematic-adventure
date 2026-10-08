# 한글 폰트 해결 방법

## 문제
Godot 기본 폰트가 한글을 지원하지 않아 외계어로 보입니다.

## 해결 방법

### 1. 무료 한글 폰트 다운로드 (권장)

**추천 폰트:**
- Noto Sans KR: https://fonts.google.com/noto/specimen/Noto+Sans+KR
- Nanum Gothic: https://hangeul.naver.com/font

**설치 방법:**
1. TTF 파일 다운로드
2. `assets/fonts/` 폴더 생성
3. 폰트 파일 복사
4. Godot에서 임포트

### 2. 폰트 적용

**방법 A: Label마다 개별 적용**
```
1. DialogueBox.tscn 열기
2. NameLabel 선택
3. Theme Overrides → Fonts → Font 클릭
4. 한글 폰트 선택
```

**방법 B: Theme 생성 (전체 적용)**
```
1. New Theme 생성
2. Theme → Default Font 설정
3. project.godot에 Theme 등록
```

### 3. 임시 해결책

**영어로 변경:**
- test_npc.tscn → npc_name = "Warrior"
- dialogue_text를 영어로

## 테스트

영어 NPC (초록색)로 시스템 작동 확인:
1. E 키로 대화
2. 가위바위보 게임
3. 모든 기능 정상 작동

한글 폰트는 나중에 추가 가능!
