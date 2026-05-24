ARG BASE=quay.io/prometheus/node-exporter:v1.8.1
FROM $BASE

ARG AUTHOR=mengkzhaoyun@gmail.com
LABEL maintainer=${AUTHOR}

ENV TZ=Asia/Shanghai
