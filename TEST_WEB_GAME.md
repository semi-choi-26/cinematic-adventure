# 🌐 HTML5 웹 게임 모바일 테스트 가이드

APK 설치 문제를 우회하고 즉시 게임을 테스트하세요!

## 📋 준비물
- PC (Windows)
- 모바일 디바이스
- 같은 Wi-Fi 네트워크

## 🚀 5분 안에 테스트하기

### 1단계: GitHub에서 웹 빌드 다운로드

1. GitHub 저장소 → **Actions** 탭
2. 최근 성공한 워크플로우 클릭 (녹색 ✓)
3. 하단 **Artifacts** → `web-build` 다운로드
4. ZIP 압축 해제

### 2단계: 로컬 서버 실행

**방법 A: run_web.bat 사용**
```
1. web-build 폴더를 parallax 폴더에 배치
2. run_web.bat 더블클릭
3. "http://localhost:8000" 창이 열림
```

**방법 B: 수동 실행**
```bash
cd web-build
python -m http.server 8000
```

### 3단계: PC IP 주소 확인

**PowerShell에서:**
```powershell
ipconfig
```

**IPv4 주소 찾기:**
```
예: 192.168.0.10
```

### 4단계: 모바일에서 접속

모바일 브라우저(Chrome/Safari)에서:
```
http://192.168.0.10:8000
```

**완료!** 게임이 브라우저에서 실행됩니다! 🎮

---

## 🐛 문제 해결

### "사이트에 연결할 수 없음"
- PC와 모바일이 **같은 Wi-Fi**에 연결되었는지 확인
- PC 방화벽에서 포트 8000 허용

### Windows 방화벽 허용
```powershell
# 관리자 권한 PowerShell에서:
netsh advfirewall firewall add rule name="Python HTTP Server" dir=in action=allow protocol=TCP localport=8000
```

### "Failed to fetch"
- 브라우저에서 직접 `file://` 열지 말고 반드시 서버 사용
- `http://192.168.0.10:8000` 형식으로 접속

---

## 📱 모바일 테스트 시 확인할 것

- ✅ 좌우 이동 버튼 작동
- ✅ 터치 조작 반응
- ✅ 화면 크기 맞춤
- ✅ 프레임률 확인

---

## 💡 장점

| 항목 | APK | HTML5 웹 |
|------|-----|----------|
| 설치 | 차단됨 ❌ | 불필요 ✅ |
| 테스트 | 복잡 | 즉시 ✅ |
| 업데이트 | 재설치 | 새로고침 ✅ |
| 공유 | APK 전송 | URL 공유 ✅ |

---

**HTML5로 먼저 게임이 작동하는지 확인하세요!**

작동하면 APK 문제는 나중에 해결하고, 
일단 **게임 개발을 계속 진행**할 수 있습니다! 🎉
