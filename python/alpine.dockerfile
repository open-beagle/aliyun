ARG BASE=python:3.12.12-alpine

FROM ${BASE}

ARG AUTHOR=mengkzhaoyun@gmail.com
ARG VERSION=3.12.12-alpine
LABEL maintainer=${AUTHOR} version=${VERSION}
