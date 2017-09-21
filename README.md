## Docker Image

```
docker pull plain/otter_manager
```
[https://hub.docker.com/r/plain/otter_manager/](https://hub.docker.com/r/plain/otter_manager/)

## Usage

example

```
docker run -d --restart=always --name otter_manager -e ManagerAddr=abcd.com -e ManagerPort=8082  -e MysqlAddr=[ip:port]  -v /var/lib/otter/zkdata:/zkdata -e MysqlUser=root -e MysqlPwd=pwd -e MaxMem=5000m -p 1099:1099 -p 8082:8082  -p 2181:2181  plain/otter_manager
```