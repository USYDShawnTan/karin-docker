# Karin Docker 部署指南

## 简介

[Karin](https://karin.fun/) 欢迎使用 Karin! 这是一个充满魔力的现代化机器人开发框架，让我们开始这段奇妙的开发之旅吧~

## Docker 部署

### 快速启动

```bash
docker run -d \
  --name karin \
  --restart=always \
  -p 7777:7777 \
  -v /root/karin:/app/@karinjs \
  xiaotanyyds/karin:latest
```

### 国内镜像（上面那个下载慢就用这个吧）

```bash
docker run -d \
  --name karin \
  --restart=always \
  -p 7777:7777 \
  -v /root/karin:/app/@karinjs \
  registry.cn-shenzhen.aliyuncs.com/xiaotan-images/karin:latest
```

### 查看日志

```bash
docker logs -f karin
```

### 进入容器

```bash
docker exec -it karin /bin/bash
```

## 配置说明

### 端口说明

- 7777: Karin 服务端口

### 目录挂载

- `/app/@karinjs`: Karin 核心文件目录，包含配置文件和数据

## 常见问题

## 更新容器

```bash
# 拉取最新镜像
docker pull xiaotanyyds/karin:latest

# 停止并删除旧容器
docker stop karin
docker rm karin

# 使用新镜像重新创建容器
docker run -d \
  --name karin \
  --restart=always \
  -p 7777:7777 \
  -v /root/karin:/app/@karinjs \
  xiaotanyyds/karin:latest
```

## 相关链接

- [Karin 官网](https://karin.fun/)
- [Docker Hub](https://hub.docker.com/r/xiaotanyyds/karin)

## License

本项目遵循 MIT 许可证。详情请参见 [LICENSE](LICENSE) 文件。
