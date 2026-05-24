ARG BASE=registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.14.0
FROM $BASE

ARG AUTHOR=mengkzhaoyun@gmail.com
LABEL maintainer=${AUTHOR}

ENV TZ=Asia/Shanghai
