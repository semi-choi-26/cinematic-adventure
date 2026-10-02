@echo off
echo ========================================
echo   빌드 에러 수정 및 배포
echo ========================================
echo.

echo [1/3] 수정된 파일 추가...
git add scripts/camera_controller.gd
git add icon.svg
git add .github/workflows/

echo.
echo [2/3] 커밋...
git commit -m "Fix: GDScript 타입 에러 수정 및 아이콘 추가"

echo.
echo [3/3] GitHub에 푸시...
git push

echo.
echo ========================================
echo   완료! 1-2분 후 GitHub Actions 확인
echo ========================================
echo.
echo GitHub Actions:
echo https://github.com/<사용자명>/cinematic-adventure/actions
echo.
pause
