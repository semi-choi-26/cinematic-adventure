@echo off
echo ========================================
echo   HTML5 빌드 시작
echo ========================================

REM Godot 실행 파일 경로 (설치 후 수정 필요)
set GODOT_PATH="C:\Program Files\Godot\Godot_v4.3-stable_win64.exe"

REM 빌드 폴더 생성
if not exist "builds\web" mkdir builds\web

REM HTML5 Export
echo.
echo 빌드 중...
%GODOT_PATH% --headless --export-release "HTML5" builds/web/index.html

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo   빌드 성공!
    echo   위치: builds\web\index.html
    echo ========================================
    echo.
    echo 로컬 서버 시작 중...
    cd builds\web
    python -m http.server 8000
) else (
    echo.
    echo ========================================
    echo   빌드 실패!
    echo   Godot 경로를 확인하세요.
    echo ========================================
    pause
)
