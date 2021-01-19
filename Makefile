all: build run

build:
	docker build -t ibmosquito/etcd:1.0.0 .

dev: build stop
	-docker rm -f etcd 2> /dev/null || :
	docker run -it --name etcd -p 2379:2379 -p 2380:2380 --volume `pwd`:/outside ibmosquito/etcd:1.0.0 /bin/bash

run: stop
	-docker rm -f etcd 2>/dev/null || :
	docker run -d --name etcd -p 2379:2379 -p 2380:2380 ibmosquito/etcd:1.0.0 /bin/sh

test:
	docker exec -it etcd etcdctl cluster-health

exec:
	docker exec -it etcd /bin/sh

push:
	docker push ibmosquito/etcd:1.0.0

stop:
	-docker rm -f etcd 2>/dev/null || :

clean: stop
	-docker rmi ibmosquito/etcd:1.0.0 2>/dev/null || :

.PHONY: all build dev run test exec stop clean
