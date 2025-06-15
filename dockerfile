FROM node:lts-slim

# 设置工作目录
WORKDIR /app

# 使用清华源 + 安装运行时依赖
RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.d/debian.sources && \
    sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && \
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
ENV PNPM_HOME=/root/.local/share/pnpm
ENV PATH=$PNPM_HOME:$PATH

# 安装 pnpm 和 Karin CLI（使用淘宝镜像）
RUN npm install -g pnpm@^9 --registry=https://registry.npmmirror.com && \
    mkdir -p $PNPM_HOME && \
    pnpm config set global-bin-dir $PNPM_HOME && \
    pnpm add -g @karinjs/cli

# 初始化项目与依赖（注意插件需要放在 workspace 根目录）
RUN echo '{ "name": "karin-app", "private": true }' > package.json && \
    pnpm install node-karin && \
    npx karin init && \
    pnpm add \
    @karinjs/plugin-puppeteer \
    @karinjs/plugin-basic \
    karin-plugin-kkk@latest \
    -w

# 设置数据卷
VOLUME ["/app/@karinjs"]
RUN mkdir -p /app/@karinjs && chmod -R 755 /app

# 默认启动命令
CMD ["pnpm", "app"]
