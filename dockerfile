# 使用 Node.js 20-slim 基础镜像（Debian 环境）
FROM node:20-slim

# 设置工作目录
WORKDIR /app

RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libexpat1 \
    libgdk-pixbuf2.0-0 \
    libgbm1 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libcairo2 \
    libpango-1.0-0 \
    libxkbcommon0 \
    libatspi2.0-0 \     
    libglib2.0-0 \       
    libgtk-3-0 \        
    libudev1 \          
    libvulkan1 \       
    libx11-6 \          
    libxcb1 \            
    libxext6 \          
    xdg-utils \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

# 启用 corepack（用于管理 pnpm）
RUN corepack enable

# 配置国内镜像源
RUN npm config set registry https://registry.npmmirror.com

# 全局安装 pm2（如果需要，用 --force 避免覆盖问题）
RUN npm install -g pm2 --force

# 全局安装 pnpm v9
RUN npm install -g pnpm@9 --force

# 自动执行框架安装，使用 yes 模拟回车，默认安装
RUN yes "" | pnpm create karin

# 复制 entrypoint 脚本并赋予执行权限
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# 暴露 Web 控制台默认端口
EXPOSE 7777

# 使用 entrypoint 脚本启动容器
CMD ["/app/entrypoint.sh"]
