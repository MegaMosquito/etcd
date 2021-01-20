# etcd
My etcd deployment.


## Create and use root user creds:

```
docker exec -it etcd etcdctl --endpoints=localhost:2379 user add root:passw0rd
docker exec -it etcd etcdctl --endpoints=localhost:2379 role add root
docker exec -it etcd etcdctl --endpoints=localhost:2379 user grant-role root root
docker exec -it etcd etcdctl --endpoints=localhost:2379 auth enable
docker exec -it etcd etcdctl --endpoints=localhost:2379 --user=root:passw0rd endpoint health
```


## Create and use auth token:

```
root@913468d5611c:/# curl -L http://localhost:2379/v3/auth/authenticate   -X POST -d '{"name": "root", "password": "passw0rd"}'
{"header":{"cluster_id":"8456392909007433582","member_id":"18244812706509296096","revision":"10","raft_term":"2"},"token":"pZslchHUckJkUpna.49"}root@913468d5611c:/# 
root@913468d5611c:/# curl -L http://localhost:2379/v3/kv/put   -H 'Authorization: pZslchHUckJkUpna.49'   -X POST -d '{"key": "Zm9v", "value": "YmFy"}'
{"header":{"cluster_id":"8456392909007433582","member_id":"18244812706509296096","revision":"11","raft_term":"2"}}root@913468d5611c:/# 
root@913468d5611c:/# 
```


