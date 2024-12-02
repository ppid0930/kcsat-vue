# 1단계: Node 이미지로 Vue 프로젝트 빌드
FROM node:lts-alpine AS build
#
WORKDIR /app

# package.json과 package-lock.json 복사
COPY package*.json ./

# 의존성 설치
RUN npm install

# 프로젝트 소스 코드 복사
COPY . .

# Vue 애플리케이션 빌드
RUN npm run build

# 2단계: Nginx 이미지로 배포
FROM nginx:alpine

# Nginx 설정 복사 (optional)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 빌드된 파일을 Nginx 웹 루트로 복사
COPY --from=build /app/dist /usr/share/nginx/html

# Nginx 포트 노출
EXPOSE 80

# Nginx 실행
CMD ["nginx", "-g", "daemon off;"]