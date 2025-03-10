# aliyun registry

阿里云 - 容器镜像服务

## nginx

<https://hub.docker.com/_/nginx>

### nginx-1.27

```bash
docker pull nginx:1.27.4-alpine && \
docker tag nginx:1.27.4-alpine registry.cn-qingdao.aliyuncs.com/wod/nginx:1.27 && \
docker push registry.cn-qingdao.aliyuncs.com/wod/nginx:1.27
```
