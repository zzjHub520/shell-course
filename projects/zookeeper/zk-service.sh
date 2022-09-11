#!/bin/bash 

clusterHostArray[${#clusterHostArray[@]}]=server101
clusterHostArray[${#clusterHostArray[@]}]=server102
clusterHostArray[${#clusterHostArray[@]}]=server103
clusterHostArray[${#clusterHostArray[@]}]=server104

zookeeperPath=/opt/module/zookeeper/apache-zookeeper-3.7.1-bin

case $1 in 
"start"){ 
  for i in ${clusterHostArray[@]}
  do 
        echo ---------- zookeeper $i 启动 ------------ 
    ssh  $i  "${zookeeperPath}/bin/zkServer.sh start" 
  done 
};; 
"stop"){ 
  for i in ${clusterHostArray[@]}
  do 
        echo ---------- zookeeper $i 停止 ------------     
    ssh  $i  "${zookeeperPath}/bin/zkServer.sh stop" 
  done 
};; 
"status"){ 
  for i in ${clusterHostArray[@]}
  do 
        echo ---------- zookeeper $i 状态 ------------     
    ssh  $i  "${zookeeperPath}/bin/zkServer.sh status" 
  done 
};; 
esac 