ARG DISTRO_VERSION=24.04
FROM ubuntu:${DISTRO_VERSION}

ARG HOST_UID=1000

RUN DEBIAN_FRONTEND=noninteractive && \
    apt update && \
    apt install -y sudo

RUN userdel $(getent passwd $HOST_UID | cut -d: -f 1) \
    && useradd -m -u $HOST_UID -s /bin/bash user \
    && echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers \
    && passwd -d user

RUN mkdir /workspace

COPY . /tmp/dotfiles

USER user

WORKDIR /tmp/dotfiles
RUN ./run.sh

WORKDIR /workspace
CMD ["/bin/zsh"]
