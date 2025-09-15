FROM node:lts-slim

# 设置工作目录
WORKDIR /app

# 修正：更可靠的换源方式
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    ffmpeg ca-certificates fonts-liberation \
    libasound2 libatk-bridge2.0-0 libatk1.0-0 libc6 libcairo2 \
    libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc1 \
    libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 \
    libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 \
    libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 \
    libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    lsb-release wget xdg-utils libxkbcommon0 redis-server && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 设置 pnpm 环境变量
ENV PNPM_HOME="/root/.local/share/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# 安装 pnpm 和相关工具
RUN npm install -g pnpm@^9 --registry=https://registry.npmmirror.com && \
    npm install -g pm2@latest --registry=https://registry.npmmirror.com && \
    mkdir -p $PNPM_HOME && \
    pnpm config set global-bin-dir $PNPM_HOME && \
    pnpm config set store-dir $PNPM_HOME && \
    pnpm add -g @karinjs/cli@latest

# 初始化项目与依赖

RUN mkdir -p /app/karin && \
    cd /app/karin && \
    pnpm init && \
    pnpm install node-karin && \
    ki init && \
    pnpm add \
    @karinjs/plugin-puppeteer \
    @karinjs/plugin-basic \
    -w

# 设置数据卷
VOLUME ["/app/karin"]
RUN chmod -R 755 /app

# 默认启动命令
CMD ["sh", "-c", "cd /app/karin && ki start"]


