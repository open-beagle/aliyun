ARG BASE=victoriametrics/vmalert:v1.143.0
FROM $BASE

ARG AUTHOR=mengkzhaoyun@gmail.com
LABEL maintainer=${AUTHOR}

ENV TZ=Asia/Shanghai
