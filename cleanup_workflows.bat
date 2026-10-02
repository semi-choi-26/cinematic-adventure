@echo off
echo ========================================
echo   워크플로우 정리
echo ========================================
echo.
echo 현재 5개의 워크플로우가 있습니다.
echo 중복 빌드를 제거합니다.
echo.
echo [추천] 남기는 것:
echo   - build-android-stable.yml (안정적인 Android)
echo   - build-web.yml (HTML5 웹게임)
echo   - build-all.yml (릴리즈용)
echo.
echo [삭제] 중복/테스트용:
echo   - build-android.yml (stable과 중복)
echo   - test-web.yml (테스트용)
echo.
pause
echo.

git rm .github/workflows/build-android.yml
git rm .github/workflows/test-web.yml

git commit -m "Cleanup: 중복 워크플로우 제거 (stable 버전 사용)"
git push

echo.
echo ========================================
echo   완료! 이제 2개만 실행됩니다:
echo   1. Android APK (stable)
echo   2. HTML5 Web
echo ========================================
pause
