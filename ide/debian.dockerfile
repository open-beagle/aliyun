ARG BASE
FROM $BASE

ARG AUTHOR
ARG VERSION
LABEL maintainer=$AUTHOR version=$VERSION

ENV PATH=/opt/bin:$PATH
ENV LD_LIBRARY_PATH /usr/glibc-compat/lib:/usr/lib
ENV _CONTAINERS_USERNS_CONFIGURED=""

COPY ./ide/ssh/ssh* /etc/ssh/

RUN apt update && \
  apt install -y \
        curl \
        wget \
        git \
        vim \
        nano \
        htop \
        tree \
        jq \
        unzip \
        ca-certificates \
        gnupg \
        lsb-release \
        build-essential \
        pkg-config \
        lsof \
        iputils-ping \
        sudo \
        file \
        iptables \
        iproute2 && \
  apt install -y \
        python3 \
        connect-proxy \
        openssh-server \
        openssh-client \
        podman \
        crun \
        fuse-overlayfs && \
  apt clean && \
  sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/g' /etc/ssh/sshd_config  && \
  chmod 600 /etc/ssh/ssh_host*  && \
  echo "export PATH=$HOME/.local/bin:$PATH" >> $HOME/.bashrc

COPY ./debian/debian-13.sources /etc/apt/sources.list.d/debian.sources

RUN adduser --gecos '' --disabled-password code && \
  echo "code ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd 

# USER code