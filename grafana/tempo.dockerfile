ARG BASE=grafana/tempo:3.0.2
FROM $BASE

ARG AUTHOR=mengkzhaoyun@gmail.com
LABEL maintainer=${AUTHOR}

ENV TZ=Asia/Shanghai
