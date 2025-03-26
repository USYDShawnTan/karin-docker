#!/bin/sh
echo "正在启动 karin-project-puppeteer 服务..."
( cd karin-project-puppeteer && npx k pm2 > puppeteer.log 2>&1 ) &
echo "karin-project-puppeteer 服务已启动！"

echo "正在启动 karin 控制台..."
cd karin-project && npx karin .
