ARG BASE=clickhouse/clickhouse-server:25.5.6
FROM $BASE

ENV TZ=Asia/Shanghai
RUN apt update && apt install -y tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apt clean
