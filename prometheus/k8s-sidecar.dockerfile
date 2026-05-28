ARG BASE=quay.io/kiwigrid/k8s-sidecar:2.7.3
FROM $BASE

ARG AUTHOR=mengkzhaoyun@gmail.com
LABEL maintainer=${AUTHOR}

ENV TZ=Asia/Shanghai
