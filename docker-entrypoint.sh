#!/bin/sh
echo ManagerAddr: $ManagerAddr
echo ManagerPort: $ManagerPort
echo MysqlAddr: $MysqlAddr
echo MysqlUser: $MysqlUser
echo MysqlPwd: $MysqlPwd
sed -ri "s/(otter.domainName = ).*/\1 $ManagerAddr/" /manager/conf/otter.properties
sed -ri "s/(otter.Port = ).*/\1 $ManagerPort/" /manager/conf/otter.properties
sed -ri "s/(otter.database.driver.url = ).*/\1 jdbc:mysql:\/\/$MysqlAddr\/otter/" /manager/conf/otter.properties
sed -ri "s/(otter.database.driver.username = ).*/\1 $MysqlUser/" /manager/conf/otter.properties
sed -ri "s/(otter.database.driver.password = ).*/\1 $MysqlPwd/" /manager/conf/otter.properties
/opt/zookeeper/bin/zkServer.sh start
sleep 2
/manager/bin/startup.sh
trap 'echo stop manager; /manager/bin/stop.sh' TERM
tail -f /dev/null & wait