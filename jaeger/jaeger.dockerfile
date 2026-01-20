FROM alpine:latest AS tzdata
RUN apk add --no-cache tzdata

ARG BASE=jaegertracing/jaeger:2.14.1
FROM $BASE

ENV TZ=Asia/Shanghai
COPY --from=tzdata /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
