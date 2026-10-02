# 🤖 GitHub Actions 자동 빌드 가이드

## 개요

GitHub에 코드를 푸시하면 **자동으로 APK를 빌드**해주는 시스템입니다.

### 장점
✅ **로컬에 Android Studio 설치 불필요**  
✅ **자동 빌드** - push할 때마다 자동 실행  
✅ **무료** - GitHub Actions 월 2000분 무료  
✅ **팀 협업** - 누구나 최신 APK 다운로드 가능  
✅ **여러 플랫폼 동시 빌드** - Android + HTML5

---

## 📋 사전 준비

### 1. GitHub 계정 생성
- https://github.com 에서 무료 가입

### 2. Git 설치
- Windows: https://git-scm.com/download/win
- 설치 후 Git Bash 또는 PowerShell에서 확인:
  ```bash
  git --version
  ```

---

## 🚀 초기 설정 (1회만)

### 1단계: Git 초기화

```bash
# 프로젝트 폴더에서 실행
git init
git add .
git commit -m "Initial commit: Phase 1 완료"
```

### 2단계: GitHub 저장소 생성

1. https://github.com/new 접속
2. Repository name: `cinematic-adventure`
3. Public 선택 (또는 Private)
4. **Create repository** 클릭

### 3단계: 로컬 → GitHub 연결

```bash
# GitHub에서 알려준 명령어 실행
git remote add origin https://github.com/<사용자명>/cinematic-adventure.git
git branch -M main
git push -u origin main
```

---

## 🔨 자동 빌드 사용법

### 방법 1: 코드 푸시 시 자동 빌드

```bash
# 코드 수정 후
git add .
git commit -m "Phase 2 구현: 패럴랙스 배경"
git push
```

→ GitHub Actions가 **자동으로 APK 빌드** 시작!

### 방법 2: 수동 빌드

1. GitHub 저장소 페이지 접속
2. **Actions** 탭 클릭
3. **🤖 Android APK Build** 선택
4. **Run workflow** 버튼 클릭
5. **Run workflow** 확인

---

## 📥 빌드된 APK 다운로드

### 개발 중 (일반 빌드)

1. GitHub 저장소 → **Actions** 탭
2. 최근 워크플로우 실행 클릭 (녹색 체크 ✓)
3. 하단 **Artifacts** 섹션에서 `android-apk` 다운로드
4. ZIP 압축 해제 → APK 파일 획득

### 릴리즈 버전

**버전 태그 푸시 시 자동으로 GitHub Releases에 업로드됩니다.**

```bash
# 버전 1.0 릴리즈
git tag v1.0
git push origin v1.0
```

→ 자동으로 **Releases** 페이지에 APK 업로드  
→ `https://github.com/<사용자명>/cinematic-adventure/releases`

---

## 📦 제공되는 워크플로우

### 1. `build-android.yml` - Android APK 빌드
**실행 조건:**
- `main`, `master`, `develop` 브랜치에 push
- Pull Request 생성
- 수동 실행

**결과물:**
- `android-apk` artifact
- 크기: ~25-50MB

### 2. `build-web.yml` - HTML5 웹 빌드
**실행 조건:**
- `main`, `master`, `develop` 브랜치에 push
- 수동 실행

**결과물:**
- `web-build` artifact
- GitHub Pages 자동 배포 (선택사항)

### 3. `build-all.yml` - 모든 플랫폼 빌드
**실행 조건:**
- `v*` 태그 푸시 (예: v1.0, v2.1)
- 수동 실행

**결과물:**
- Android + HTML5 동시 빌드
- 30일간 보관

---

## 🌐 GitHub Pages 웹 게임 배포

HTML5 빌드를 무료 호스팅할 수 있습니다!

### 1. GitHub Pages 활성화

1. 저장소 → **Settings** → **Pages**
2. Source: **GitHub Actions** 선택
3. Save

### 2. 배포 확인

- main 브랜치에 push하면 자동 배포
- 접속 주소: `https://<사용자명>.github.io/cinematic-adventure/`

### 3. 모바일 테스트

```
스마트폰 브라우저에서 위 주소 접속 → 바로 플레이!
```

---

## 🔍 빌드 상태 확인

### 빌드 로그 보기

1. Actions 탭 → 워크플로우 클릭
2. 각 단계별 로그 확인 가능
3. ❌ 실패 시 어떤 단계에서 실패했는지 확인

### 빌드 시간

| 플랫폼 | 예상 시간 | 무료 할당 |
|--------|----------|-----------|
| Android | 5-8분 | 월 2000분 |
| HTML5 | 3-5분 | 월 2000분 |

→ 한 달에 약 **250회 빌드 가능** (무료)

---

## 🎯 실전 워크플로우

### 일상적인 개발

```bash
# 1. 코드 수정
# 2. 테스트 (로컬에서 F5)
# 3. 커밋 & 푸시
git add .
git commit -m "NPC 대화 시스템 구현"
git push

# 4. GitHub Actions가 자동으로 APK 빌드
# 5. Actions 탭에서 APK 다운로드
# 6. 모바일에 설치하여 테스트
```

### 버전 릴리즈

```bash
# Phase 3 완료 → v0.3 릴리즈
git tag v0.3 -m "Phase 3: NPC 시스템 완료"
git push origin v0.3

# → GitHub Releases에 자동 업로드
# → 베타 테스터들에게 링크 공유
```

---

## 🐛 문제 해결

### "export_presets.cfg not found"
→ `export_presets.cfg` 파일이 `.gitignore`에 포함되어 있을 수 있음

**해결:**
```bash
# .gitignore에서 export_presets.cfg 제거
git add export_presets.cfg
git commit -m "Add export presets"
git push
```

### "Godot could not export"
→ Export 프리셋 이름 확인

**해결:**
- `export_presets.cfg`에서 preset 이름이 "Android", "HTML5"인지 확인
- 대소문자 정확히 일치해야 함

### APK가 설치되지 않음
→ 서명되지 않은 APK일 수 있음

**해결:**
1. 휴대폰 설정 → 보안 → "알 수 없는 출처" 허용
2. 또는 서명된 APK 빌드 (GITHUB_SIGNING.md 참고)

---

## 📊 비용 (무료!)

| 항목 | 무료 제공 | 초과 시 |
|------|----------|---------|
| GitHub Actions | 월 2000분 | $0.008/분 |
| Artifact 저장 | 500MB | $0.25/GB |
| GitHub Pages | 무제한 | - |
| 저장소 크기 | 권장 1GB 이하 | - |

→ **개인 프로젝트는 완전 무료!**

---

## 🎓 고급 기능

### 자동 버전 번호 증가

`.github/workflows/build-android.yml` 수정:

```yaml
- name: 🔨 Build Android APK
  run: |
    VERSION=$(git describe --tags --always)
    godot --headless --export-release "Android" builds/android/${{ env.EXPORT_NAME }}-$VERSION.apk
```

### Slack/Discord 알림

빌드 완료 시 자동 알림:

```yaml
- name: 📢 Notify Discord
  if: success()
  uses: sarisia/actions-status-discord@v1
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
    title: "APK Build Success!"
```

### 여러 Android 아키텍처 빌드

ARMv7, ARM64, x86 동시 빌드 가능

---

## 🔗 유용한 링크

- **GitHub Actions 문서**: https://docs.github.com/actions
- **Godot CI 템플릿**: https://github.com/abarichello/godot-ci
- **Artifact 다운로드**: https://github.com/actions/download-artifact

---

## 📝 체크리스트

프로젝트를 GitHub에 올리기 전:

- [ ] `.gitignore` 파일 확인
- [ ] `export_presets.cfg` 커밋 여부 확인
- [ ] 민감한 정보 (API 키 등) 제거
- [ ] README.md 작성
- [ ] 라이선스 파일 추가 (선택사항)

첫 push 후:

- [ ] Actions 탭에서 빌드 성공 확인
- [ ] APK artifact 다운로드 테스트
- [ ] 모바일에서 설치 & 실행 확인

---

**다음 단계**: Phase 2 구현 후 GitHub에 push하여 자동 빌드 테스트!
