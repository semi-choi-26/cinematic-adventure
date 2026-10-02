@echo off
echo ========================================
echo   HTML5 게임 서버 실행
echo ========================================
echo.

REM Artifacts에서 다운로드한 web-build 폴더 확인
if not exist "web-build\index.html" (
    echo [오류] web-build 폴더를 찾을 수 없습니다.
    echo.
    echo 1. GitHub Actions에서 web-build Artifact 다운로드
    echo 2. 압축 해제
    echo 3. 이 배치 파일이 있는 폴더에 web-build 폴더 배치
    echo.
    pause
    exit /b 1
)

echo 로컬 서버 시작 중...
echo.
echo 브라우저에서 열기: http://localhost:8000
echo.
echo 종료하려면 Ctrl+C를 누르세요.
echo.

cd web-build
python -m http.server 8000

pause
