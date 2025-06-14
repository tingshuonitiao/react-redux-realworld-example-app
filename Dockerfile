# 阶段 1: 构建应用 (使用兼容的 Node 14 版本)
FROM node:14-alpine AS build
WORKDIR /app
COPY package*.json ./
# 使用 npm ci 而不是 npm install 确保精确版本安装
RUN npm install
COPY . .
# 构建生产版本
RUN npm run build

# 阶段 2: 生产服务
FROM nginx:1.23-alpine
# 复制构建产物
COPY --from=build /app/build /usr/share/nginx/html
# 自定义 Nginx 配置 (需要您创建 nginx.conf 文件)
COPY nginx.conf /etc/nginx/conf.d/default.conf
# 暴露端口
EXPOSE 80
# 不需要 CMD - 基础镜像已包含 nginx -g 'daemon off;'
