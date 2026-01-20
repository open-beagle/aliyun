ARG BASE=altinity/clickhouse-operator:0.21.2
FROM $BASE

FROM alpine:latest AS tzdata
RUN apk add --no-cache tzdata

ENV TZ=Asia/Shanghai
COPY --from=tzdata /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
