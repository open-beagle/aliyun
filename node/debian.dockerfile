ARG BASE

FROM ${BASE}

ARG AUTHOR
ARG VERSION
LABEL maintainer=${AUTHOR} version=${VERSION}

COPY ./ssl/beagle-ca.crt /usr/local/share/ca-certificates/beagle-ca.crt
