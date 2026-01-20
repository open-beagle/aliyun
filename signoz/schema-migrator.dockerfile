ARG BASE=signoz/signoz-schema-migrator:0.129.12

FROM alpine:latest AS tzdata
RUN apk add --no-cache tzdata

FROM $BASE

ENV TZ=Asia/Shanghai
COPY --from=tzdata /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
