ARG BASE=signoz/signoz:0.107.0

FROM alpine:latest AS tzdata
RUN apk add --no-cache tzdata

FROM $BASE

ENV TZ=Asia/Shanghai
COPY --from=tzdata /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
