ARG BASE=python:3.12-bookworm

FROM ${BASE}

ARG AUTHOR=mengkzhaoyun@gmail.com
ARG VERSION=3.12-bookworm
LABEL maintainer=${AUTHOR} version=${VERSION}

RUN pip config set global.index-url "https://mirrors.aliyun.com/pypi/simple/" && \
    pip config set global.trusted-host "mirrors.aliyun.com" && \
    pip install --no-cache-dir poetry
