# 🌐 Netlify 배포 가이드

HTML5 게임을 Netlify로 배포하여 누구나 URL로 플레이할 수 있게 합니다!

## 🚀 방법 1: Netlify CLI (권장)

### 설치
```bash
npm install -g netlify-cli
```

### 로그인
```bash
netlify login
```

### 배포
```bash
# GitHub Actions에서 web-build 다운로드 후
cd builds/web
netlify deploy

# 프로덕션 배포
netlify deploy --prod
```

---

## 🌐 방법 2: Netlify 웹사이트

### 1. 사이트 생성
1. https://app.netlify.com
2. **Add new site** → **Deploy manually**
3. `builds/web` 폴더를 드래그 & 드롭

### 2. GitHub 연동 (자동 배포)
1. **Add new site** → **Import from Git**
2. GitHub 저장소 선택
3. Build settings:
   - **Build command**: (비워둠)
   - **Publish directory**: `builds/web`
4. Deploy

---

## 🔧 방법 3: GitHub Actions → Netlify (완전 자동)

### .github/workflows/deploy-netlify.yml 추가

```yaml
name: "🌐 Deploy to Netlify"

on:
  push:
    branches: [ main, master ]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    needs: export-web  # HTML5 빌드 후
    
    steps:
      - name: 📥 Download Web Build
        uses: actions/download-artifact@v5
        with:
          name: web-build
          path: builds/web
      
      - name: 🚀 Deploy to Netlify
        uses: nwtgck/actions-netlify@v2
        with:
          publish-dir: './builds/web'
          production-deploy: true
          github-token: ${{ secrets.GITHUB_TOKEN }}
          deploy-message: "Deploy from GitHub Actions"
        env:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
```

### Secrets 설정
1. Netlify에서 **Site ID** 복사
2. Netlify에서 **Personal Access Token** 생성
3. GitHub → Settings → Secrets → Actions
4. 추가:
   - `NETLIFY_AUTH_TOKEN`
   - `NETLIFY_SITE_ID`

---

## 📊 배포 후

### URL 확인
```
https://<site-name>.netlify.app
```

### 커스텀 도메인
1. Netlify → Domain settings
2. Add custom domain
3. DNS 설정

---

## 🎮 공유

이제 **URL만 공유**하면 됩니다!
- 친구들에게 링크 전송
- 포트폴리오에 추가
- 소셜 미디어 공유

---

## 💡 장점

- ✅ **즉시 플레이**: 설치 불필요
- ✅ **자동 배포**: Push 시 자동 업데이트
- ✅ **무료**: 월 100GB 대역폭
- ✅ **빠름**: 글로벌 CDN
- ✅ **HTTPS**: 기본 제공

---

**추천**: 방법 1 (Netlify CLI)이 가장 간단합니다!
