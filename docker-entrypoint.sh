#!/bin/bash
echo ManagerAddr: $ManagerAddr
echo ManagerPort: $ManagerPort
echo MysqlAddr: $MysqlAddr
echo MysqlUser: $MysqlUser
echo MysqlPwd: $MysqlPwd
echo ZKPort: $ZKPort
if [ -z "$ZKPort" ];then
	ZKPort=2181
fi
sed -ri 's/(clientPort).*/\1=$ZKPort/' /opt/zookeeper/conf/zoo.cfg
sed -ri "s/(otter.domainName).*/\1 = $ManagerAddr/" /manager/conf/otter.properties
sed -ri "s/(otter.port).*/\1 = $ManagerPort/" /manager/conf/otter.properties
sed -ri "s/(otter.database.driver.url).*/\1 = jdbc:mysql:\/\/$MysqlAddr\/otter/" /manager/conf/otter.properties
sed -ri "s/(otter.database.driver.username).*/\1 = $MysqlUser/" /manager/conf/otter.properties
sed -ri "s/(otter.database.driver.password).*/\1 = $MysqlPwd/" /manager/conf/otter.properties
/opt/zookeeper/bin/zkServer.sh start
sleep 2
cd /manager/bin
./startup.sh
trap 'echo stop manager; cd /manager/bin; ./stop.sh' TERM
tail -f /dev/null & wait