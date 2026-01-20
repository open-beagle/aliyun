FROM alpine:latest AS tz
RUN apk add --no-cache tzdata

ARG BASE=groundnuty/k8s-wait-for:v2.0
FROM $BASE

ENV TZ=Asia/Shanghai
COPY --from=tz /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
