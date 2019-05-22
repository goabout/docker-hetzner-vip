FROM goabout/kube-keepalived-vip

MAINTAINER GoAbout <tech@goabout.com>

ENV HCLOUD_VERSION=1.12.0
ADD https://github.com/hetznercloud/cli/releases/download/v${HCLOUD_VERSION}/hcloud-linux-amd64-v${HCLOUD_VERSION}.tar.gz /tmp
RUN cd /tmp && \
    tar xfz hcloud-linux-amd64-v${HCLOUD_VERSION}.tar.gz && \
    mv hcloud-linux-amd64-v${HCLOUD_VERSION}/bin/hcloud /usr/local/bin && \
    rm -fr hcloud-linux-amd64-v${HCLOUD_VERSION} hcloud-linux-amd64-v${HCLOUD_VERSION}.tar.gz

ENV KEEPALIVED_NOTIFY=/usr/local/bin/notify
RUN addgroup -S keepalived_script && \
    adduser -D -S -G keepalived_script keepalived_script
ADD notify.sh /usr/local/bin/notify
