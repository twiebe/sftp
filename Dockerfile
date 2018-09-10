FROM debian:stretch-slim
MAINTAINER Thomas Wiebe

ARG GIT_REPO_URL

RUN set -ex \
    && apt update \
    && apt install -y whois procps openssh-server \
    && apt install -y git gcc make \
    && git clone "${GIT_REPO_URL:-https://github.com/mysecureshell/mysecureshell}" mysecureshell \
    && cd mysecureshell \
    && ./configure --prefix=/usr \
    && make all \
    && make install \
    && chmod 4755 /usr/bin/mysecureshell \
    && cd .. \
    && apt purge -y git gcc make \
    && apt autoremove -y \
    && rm -fv /etc/ssh/ssh_host_*key* \
    && mkdir /run/sshd

COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint /

EXPOSE 22

ENTRYPOINT ["/entrypoint"]
