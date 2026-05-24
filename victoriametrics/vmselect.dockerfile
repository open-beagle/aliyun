ARG BASE=victoriametrics/vmselect:v1.101.0-cluster
FROM $BASE

ARG AUTHOR=mengkzhaoyun@gmail.com
LABEL maintainer=${AUTHOR}

ENV TZ=Asia/Shanghai
