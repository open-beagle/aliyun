ARG BASE=otel/opentelemetry-collector-contrib:0.143.1

FROM alpine:latest AS tzdata
RUN apk add --no-cache tzdata

FROM $BASE
ENV TZ=Asia/Shanghai
COPY --from=tzdata /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
