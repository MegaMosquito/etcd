FROM ubuntu:18.04

RUN apt update
RUN apt install -y curl jq
RUN apt install -y vim

ENV ETCD_VER=v3.4.14
ENV DOWNLOAD_URL=https://github.com/etcd-io/etcd/releases/download
RUN rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
RUN rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test
RUN curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
RUN mkdir /tmp/etcd
RUN tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd --strip-components=1
RUN rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

RUN cp /tmp/etcd/etcd /usr/local/bin/
RUN cp /tmp/etcd/etcdctl /usr/local/bin/

COPY etcd.conf /etc/etcd.conf
COPY etcd3.service /etc/systemd/system/etcd3.service

RUN etcd --version
RUN etcdctl version

RUN systemctl daemon-reload
RUN systemctl enable etcd3
RUN systemctl start etcd3

RUN echo -e 'etcdctl cluster-health\n\
etcdctl --endpoints=localhost:2379 put foo bar\n\
etcdctl --endpoints=localhost:2379 get foo\n'

