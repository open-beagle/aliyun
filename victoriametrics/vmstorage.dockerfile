ARG BASE=victoriametrics/vmstorage:v1.142.0-cluster
FROM $BASE

ARG AUTHOR=mengkzhaoyun@gmail.com
LABEL maintainer=${AUTHOR}

ENV TZ=Asia/Shanghai
