ARG BASE=python:3.12.12-bookworm

FROM ${BASE}

ARG AUTHOR=mengkzhaoyun@gmail.com
ARG VERSION=3.12.12-bookworm
LABEL maintainer=${AUTHOR} version=${VERSION}

