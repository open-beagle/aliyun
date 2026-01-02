ARG BASE=redis:7-alpine
FROM $BASE

ARG AUTHOR
ARG VERSION
LABEL maintainer=$AUTHOR version=$VERSION

ENV TZ=Asia/Shanghai
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
