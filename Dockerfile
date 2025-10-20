FROM node:20-alpine AS builder

WORKDIR /app

ENV TZ=Asia/Shanghai

# 复制依赖文件
COPY package.json pnpm-lock.yaml ./

# 安装 pnpm 并安装依赖
RUN corepack enable && pnpm install --frozen-lockfile

# 复制项目文件
COPY . .

# 构建生产版本
RUN pnpm run build

# 生产环境镜像
FROM caddy:latest AS runner

ENV TZ=Asia/Shanghai

WORKDIR /usr/share/caddy

# 从构建阶段复制打包好的文件
COPY --from=builder /app/dist ./admin

# 复制 Caddy 配置文件
COPY Caddyfile /etc/caddy/Caddyfile

EXPOSE 80

