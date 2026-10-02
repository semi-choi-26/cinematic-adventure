# 📱 모바일 빌드 가이드

## Android 빌드 (.apk)

### 1단계: 준비물 설치

#### A. Android Studio 설치
1. https://developer.android.com/studio 다운로드
2. 설치 시 다음 항목 선택:
   - ✅ Android SDK
   - ✅ Android SDK Platform
   - ✅ Android SDK Build-Tools

#### B. JDK 설치
1. https://adoptium.net/ 에서 JDK 17 다운로드
2. 설치 후 환경변수 확인:
   ```
   JAVA_HOME = C:\Program Files\Eclipse Adoptium\jdk-17.x.x
   ```

### 2단계: Godot 편집기 설정

#### A. Android 빌드 템플릿 설치
1. Godot 열기
2. **Editor > Manage Export Templates** 클릭
3. **Download and Install** 클릭
4. 설치 완료 대기

#### B. Android SDK 경로 설정
1. **Editor > Editor Settings** 열기
2. **Export > Android** 섹션으로 이동
3. 경로 설정:
   ```
   Android SDK Path: C:\Users\<사용자명>\AppData\Local\Android\Sdk
   ```
   (Android Studio 설치 시 기본 경로)

4. **Debug Keystore** 자동 생성 확인

### 3단계: Export 프리셋 생성

1. **Project > Export** 클릭
2. **Add...** → **Android** 선택
3. 설정:

   **Options 탭:**
   - ✅ `Use Custom Build` (체크 해제 - 간단한 빌드용)
   - Package Name: `com.yourstudio.cinematicadventure`
   - Version Name: `1.0`
   - Min SDK: `21` (Android 5.0)
   - Target SDK: `33`

   **Screen 탭:**
   - Orientation: `Landscape` (가로 모드)
   - Support: `Landscape` 체크

   **Permissions 탭:**
   - ✅ ACCESS_NETWORK_STATE (기본)
   - ✅ INTERNET (저장/분석용)

4. **Export Project** 클릭
5. 저장 위치 선택 (예: `builds/android/game.apk`)
6. **Save** 클릭

### 4단계: APK 설치

#### A. 개발자 모드 활성화 (Android 폰)
1. 설정 → 휴대전화 정보 → 빌드 번호 7번 연타
2. "개발자 모드가 활성화되었습니다" 메시지 확인

#### B. USB 디버깅 활성화
1. 설정 → 개발자 옵션 → USB 디버깅 ON

#### C. APK 설치
**방법 1: USB 연결**
```bash
# ADB 설치 확인 (Android Studio에 포함)
adb devices

# APK 설치
adb install builds/android/game.apk
```

**방법 2: 파일 전송**
1. APK 파일을 폰으로 전송 (USB, 이메일, 클라우드)
2. 폰에서 APK 파일 클릭
3. "알 수 없는 출처" 허용
4. 설치 진행

---

## iOS 빌드 (.app / .ipa)

### ⚠️ 요구사항
- **macOS** 필수
- **Xcode** 필수 (App Store에서 무료 다운로드)
- **Apple Developer Account** (배포 시 필요, 연 $99)

### 1단계: Xcode 설치
1. App Store에서 Xcode 다운로드
2. 설치 후 실행하여 추가 구성요소 설치

### 2단계: Godot 설정
1. **Editor > Manage Export Templates** → 템플릿 설치
2. **Project > Export** → **Add...** → **iOS**
3. 설정:
   - App Store Team ID: (Apple Developer 계정 필요)
   - Bundle Identifier: `com.yourstudio.cinematicadventure`
   - Version: `1.0`
   - Orientation: `Landscape`

### 3단계: Xcode 프로젝트 Export
1. **Export Project** 클릭 (Export PCK/ZIP 아님!)
2. 폴더 선택 (예: `builds/ios/`)
3. Xcode 프로젝트 생성됨

### 4단계: Xcode에서 빌드
1. 생성된 `.xcodeproj` 파일 열기
2. Signing & Capabilities에서 Team 선택
3. 연결된 iOS 디바이스 선택
4. ▶ 버튼 클릭하여 빌드 & 실행

---

## 🌐 간편 테스트: HTML5 빌드

모바일 테스트를 위한 가장 빠른 방법!

### 1단계: HTML5 Export 프리셋
1. **Project > Export** → **Add...** → **Web**
2. 설정:
   - Export Type: `Regular`
   - Head Include: (비워둠)

### 2단계: Export
1. **Export Project** 클릭
2. 폴더 선택 (예: `builds/web/`)
3. `index.html` 파일 생성됨

### 3단계: 로컬 서버 실행

**방법 1: Python 서버 (권장)**
```bash
cd builds/web
python -m http.server 8000
```

**방법 2: Node.js 서버**
```bash
cd builds/web
npx http-server -p 8000
```

### 4단계: 모바일에서 접속
1. PC와 모바일을 같은 Wi-Fi에 연결
2. PC의 IP 주소 확인:
   ```bash
   ipconfig  # Windows
   ifconfig  # Mac/Linux
   ```
3. 모바일 브라우저에서 접속:
   ```
   http://<PC_IP>:8000
   ```

---

## 🎯 빌드 크기 최적화 (배포 전)

### Project Settings > Application
- ✅ Run > Max FPS: `60`
- ✅ Run > Low Processor Mode: `OFF`

### Project Settings > Rendering
- Quality > Intended Usage: `Mobile`
- Textures > VRAM Compression > Import Etc2: `ON`

### Project Settings > Physics
- 2D > Physics Engine: `GodotPhysics2D`

---

## 📦 빌드 파일 크기 예상

| 플랫폼 | 기본 크기 | 에셋 포함 예상 |
|--------|----------|---------------|
| Android APK | ~25MB | 50-100MB |
| iOS IPA | ~30MB | 60-120MB |
| HTML5 | ~20MB | 40-80MB |

---

## 🐛 문제 해결

### Android: "adb not found"
```bash
# Android SDK platform-tools를 PATH에 추가
setx PATH "%PATH%;C:\Users\<사용자명>\AppData\Local\Android\Sdk\platform-tools"
```

### Android: "Build failed"
- Android Studio에서 SDK Manager 열기
- API Level 33 설치 확인
- Build Tools 최신 버전 설치

### iOS: "Signing failed"
- Xcode > Preferences > Accounts에서 Apple ID 추가
- Signing & Capabilities에서 Team 선택

### HTML5: 게임이 로드되지 않음
- 브라우저 콘솔(F12) 확인
- CORS 오류 시 → 반드시 로컬 서버 사용 (파일:// 직접 열기 불가)

---

## 🚀 다음 단계

1. **개발 중**: HTML5 빌드로 빠르게 테스트
2. **베타 테스트**: Android APK 빌드 → 지인에게 배포
3. **정식 출시**: 
   - Android: Google Play Console
   - iOS: App Store Connect

---

**생성일**: 2026-10-02  
**Godot 버전**: 4.3
