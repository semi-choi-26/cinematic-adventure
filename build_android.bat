@echo off
echo ========================================
echo   Android APK 빌드 시작
echo ========================================

REM Godot 실행 파일 경로 (설치 후 수정 필요)
set GODOT_PATH="C:\Program Files\Godot\Godot_v4.3-stable_win64.exe"

REM 빌드 폴더 생성
if not exist "builds\android" mkdir builds\android

REM Android Export
echo.
echo 빌드 중... (시간이 걸릴 수 있습니다)
%GODOT_PATH% --headless --export-release "Android" builds/android/game.apk

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo   빌드 성공!
    echo   위치: builds\android\game.apk
    echo ========================================
    echo.
    echo APK 파일을 모바일로 전송하여 설치하세요.
    echo.
    pause
) else (
    echo.
    echo ========================================
    echo   빌드 실패!
    echo   - Godot 경로 확인
    echo   - Export 템플릿 설치 확인
    echo   - Android SDK 설정 확인
    echo ========================================
    pause
)
