ARG BASE=clickhouse/clickhouse-server:24.1.8-alpine
FROM $BASE

ENV TZ=Asia/Shanghai
RUN apk add --no-cache tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
