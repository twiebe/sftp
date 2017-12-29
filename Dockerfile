FROM debian:stretch
MAINTAINER Thomas Wiebe

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y \
      -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
      install mysecureshell whois procps openssh-server
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/run/sshd
RUN rm -f /etc/ssh/ssh_host_*key*
RUN chmod 4755 /usr/bin/mysecureshell

COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint /

EXPOSE 22

ENTRYPOINT ["/entrypoint"]
