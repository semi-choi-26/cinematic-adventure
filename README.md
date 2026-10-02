# Cinematic Adventure - Godot 프로젝트

2D 사이드뷰 시네마틱 어드벤처 게임 (Godot 4.3)

## 📁 프로젝트 구조

```
parallax/
├── project.godot          # Godot 프로젝트 설정
├── scenes/
│   ├── main.tscn         # 메인 씬 (Phase 1)
│   └── player.tscn       # 플레이어 씬
├── scripts/
│   ├── player.gd         # 플레이어 컨트롤러
│   └── camera_controller.gd  # 카메라 컨트롤러
├── assets/
│   ├── sprites/          # 캐릭터/오브젝트 스프라이트
│   ├── backgrounds/      # 배경 이미지
│   └── sounds/           # 사운드 파일
└── README.md
```

## 🎮 Phase 1 구현 완료 (현재)

### ✅ 구현된 기능
- [x] Godot 프로젝트 생성
- [x] 기본 Scene 생성 (Main)
- [x] 플레이어 캐릭터 (임시 스프라이트)
- [x] 좌우 이동 구현
  - 걷기/달리기 속도 구분
  - 부드러운 가속/감속
  - 캐릭터 방향 전환
- [x] 카메라 추적 시스템
  - 플레이어 자동 추적
  - Look-ahead (진행 방향 미리보기)
  - 카메라 범위 제한

### 🎯 조작법
- **A / 왼쪽 화살표**: 왼쪽 이동
- **D / 오른쪽 화살표**: 오른쪽 이동
- **Shift**: 달리기 (현재 구현 대기)
- **E / Space**: 상호작용 (Phase 3에서 구현)

## 🚀 실행 방법

1. **Godot Engine 4.3 다운로드**
   - https://godotengine.org/download
   - "Godot Engine - .NET" 버전 권장

2. **프로젝트 열기**
   - Godot 실행
   - "Import" 클릭
   - `project.godot` 파일 선택

3. **게임 실행**
   - F5 또는 상단 "Play" 버튼 클릭

## 📋 개발 로드맵

### Phase 1: 기본 이동 ✅ 완료
- 플레이어 좌우 이동
- 카메라 추적

### Phase 2: 배경 & 패럴랙스 (다음 단계)
- 다층 배경 레이어
- 패럴랙스 스크롤 효과
- 배경 에셋 적용

### Phase 3: NPC 시스템
- NPC 배치
- 상호작용 UI
- 대화 시스템 기초

### Phase 4: 아이템 시스템
- 아이템 획득
- 인벤토리
- 아이템 사용

### Phase 5: 퀘스트 시스템
- 이벤트 관리
- 조건부 대화
- 퀘스트 진행

### Phase 6: Scene 관리
- 지역 전환
- 저장/불러오기

### Phase 7: 모바일 최적화
- 터치 UI
- 애니메이션
- 사운드
- 폴리싱

## 🎨 무료 에셋 사이트

- **itch.io**: https://itch.io/game-assets/free
- **OpenGameArt**: https://opengameart.org
- **Kenney.nl**: https://kenney.nl/assets

## 📝 시스템 설계

### 핵심 클래스 구조
```
Player (CharacterBody2D)
├── PlayerController
├── CameraController
└── AnimationController (예정)

GameManager (AutoLoad)
├── DialogueManager
├── InventoryManager
├── QuestManager
├── EventManager
└── SaveManager
```

## 🔧 다음 작업

1. 배경 에셋 다운로드 및 적용
2. ParallaxBackground 시스템 구현
3. 플레이어 스프라이트 교체
4. 걷기/달리기 애니메이션 추가

---

**Created with**: Godot Engine 4.3  
**Based on**: AI 게임 제작 요구사항.md
