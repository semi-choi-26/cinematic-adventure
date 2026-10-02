@echo off
echo ========================================
echo   GitHub Actions 빌드 수정
echo ========================================
echo.

echo [1/3] .gitignore 수정사항 확인...
git status

echo.
echo [2/3] export_presets.cfg 강제 추가...
git add -f export_presets.cfg
git add .gitignore
git add .github/workflows/

echo.
echo [3/3] 커밋 및 푸시...
git commit -m "Fix: export_presets.cfg를 Git에 포함 (GitHub Actions 빌드 수정)"
git push

echo.
echo ========================================
echo   완료! GitHub Actions 확인하세요.
echo   https://github.com/<사용자명>/cinematic-adventure/actions
echo ========================================
pause
