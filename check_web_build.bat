@echo off
echo ========================================
echo   Web Build 파일 확인
echo ========================================
echo.

if not exist "web-build" (
    echo [오류] web-build 폴더가 없습니다!
    echo.
    echo GitHub Actions에서 web-build Artifact를 다운로드하세요:
    echo 1. GitHub 저장소 - Actions 탭
    echo 2. 녹색 체크 워크플로우 클릭
    echo 3. Artifacts - web-build 다운로드
    echo 4. 압축 해제 후 이 폴더에 배치
    echo.
    pause
    exit /b 1
)

echo web-build 폴더 내용:
dir web-build
echo.

if exist "web-build\index.html" (
    echo [확인] index.html 있음 ✓
) else (
    echo [오류] index.html 없음 ✗
)

if exist "web-build\index.wasm" (
    echo [확인] index.wasm 있음 ✓
) else (
    echo [오류] index.wasm 없음 ✗
)

if exist "web-build\index.js" (
    echo [확인] index.js 있음 ✓
) else (
    echo [오류] index.js 없음 ✗
)

echo.
echo ========================================
pause
