ARG BASE=groundnuty/k8s-wait-for:v2.0
FROM $BASE

FROM alpine:latest AS tzdata
RUN apk add --no-cache tzdata

ENV TZ=Asia/Shanghai
COPY --from=tzdata /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
