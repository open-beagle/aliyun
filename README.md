# aliyun registry

阿里云 - 容器镜像服务

## alpine

<https://hub.docker.com/_/alpine>

## nginx

<https://hub.docker.com/_/nginx>

### nginx-1.27

```bash
docker pull nginx:1.27.4-alpine && \
docker tag nginx:1.27.4-alpine registry.cn-qingdao.aliyuncs.com/wod/nginx:1.27 && \
docker push registry.cn-qingdao.aliyuncs.com/wod/nginx:1.27
```

## node.js

<https://hub.docker.com/_/node>

## golang

<https://hub.docker.com/_/golang>

### golang-1.24

```bash
docker pull golang:1.24.6-alpine && \
docker tag golang:1.24.6-alpine registry.cn-qingdao.aliyuncs.com/wod/golang:1.24.6-alpine && \
docker push registry.cn-qingdao.aliyuncs.com/wod/golang:1.24.6-alpine
```

## ubuntu

<https://hub.docker.com/_/ubuntu>

### ubuntu-24.04

```bash
docker pull ubuntu:24.04 && \
docker tag ubuntu:24.04 registry.cn-qingdao.aliyuncs.com/wod/ubuntu:24.04 && \
docker push registry.cn-qingdao.aliyuncs.com/wod/ubuntu:24.04
```

## debian

<https://hub.docker.com/_/debian>

### debian-13

```bash
docker pull debian:trixie && \
docker tag debian:trixie registry.cn-qingdao.aliyuncs.com/wod/debian:trixie && \
docker push registry.cn-qingdao.aliyuncs.com/wod/debian:trixie
```

### debian-12

```bash
docker pull debian:bookworm && \
docker tag debian:bookworm registry.cn-qingdao.aliyuncs.com/wod/debian:bookworm && \
docker push registry.cn-qingdao.aliyuncs.com/wod/debian:bookworm
```
