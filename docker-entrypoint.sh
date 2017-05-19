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
echo MaxMem: $MaxMem
if [ -z "$MaxMem" ];then
	MaxMem=3072m
else
    sed -i s/"-server -Xms32m -Xmx3072m"/"-server -Xms32m -Xmx$MaxMem"/g /manager/bin/startup.sh
fi
sed -ri "s/(clientPort).*/\1=$ZKPort/" /opt/zookeeper/conf/zoo.cfg
sed -ri "s/(otter.domainName).*/\1 = $ManagerAddr/" /manager/conf/otter.properties
sed -ri "s/(otter.port).*/\1 = $ManagerPort/" /manager/conf/otter.properties
sed -ri "s/(otter.database.driver.url).*/\1 = jdbc:mysql:\/\/$MysqlAddr\/otter/" /manager/conf/otter.properties
sed -ri "s/(otter.database.driver.username).*/\1 = $MysqlUser/" /manager/conf/otter.properties
sed -ri "s/(otter.database.driver.password).*/\1 = $MysqlPwd/" /manager/conf/otter.properties
/opt/zookeeper/bin/zkServer.sh start
sleep 2
/manager/bin/stop.sh
/manager/bin/startup.sh
trap 'echo stop manager; cd /manager/bin; ./stop.sh' TERM
tail -f /manager/logs/manager.log & wait