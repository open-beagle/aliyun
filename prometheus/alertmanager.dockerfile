ARG BASE=quay.io/prometheus/alertmanager:v0.32.1
FROM $BASE

ARG AUTHOR=mengkzhaoyun@gmail.com
LABEL maintainer=${AUTHOR}

ENV TZ=Asia/Shanghai
