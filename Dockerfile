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

RUN etcd --version
RUN etcdctl version

ENV SELF_IP=localhost
ENV NODE_1_IP=localhost
CMD /bin/sh -c "/usr/local/bin/etcd --name etcd-${SELF_IP} --data-dir /var/lib/etcd --quota-backend-bytes 8589934592 --auto-compaction-retention 3 --listen-client-urls http://${SELF_IP}:2379,http://localhost:2379 --advertise-client-urls http://${SELF_IP}:2379,http://localhost:2379 --listen-peer-urls http://${SELF_IP}:2380 --initial-advertise-peer-urls http://${SELF_IP}:2380 --initial-cluster 'etcd-${NODE_1_IP}=http://${NODE_1_IP}:2380' --initial-cluster-token my-etcd-token --initial-cluster-state new"

