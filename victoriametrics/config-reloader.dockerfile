ARG BASE=victoriametrics/operator:config-reloader-v0.70.1
FROM $BASE

ARG AUTHOR=mengkzhaoyun@gmail.com
LABEL maintainer=${AUTHOR}

ENV TZ=Asia/Shanghai
