FROM alpine:latest AS tz
RUN apk add --no-cache tzdata

ARG BASE=altinity/metrics-exporter:0.21.2
FROM $BASE

ENV TZ=Asia/Shanghai
COPY --from=tz /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
