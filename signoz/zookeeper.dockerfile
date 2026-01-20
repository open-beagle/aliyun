FROM alpine:latest AS tzdata
RUN apk add --no-cache tzdata

ARG BASE=signoz/zookeeper:3.7.1
FROM $BASE

ENV TZ=Asia/Shanghai
COPY --from=tzdata /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
