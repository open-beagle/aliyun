ARG BASE=redis:7
FROM $BASE

ARG AUTHOR
ARG VERSION
LABEL maintainer=$AUTHOR version=$VERSION

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
