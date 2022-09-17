#!/bin/bash

mapred --daemon stop historyserver
stop-all.sh;
xcall "rm -rf /opt/module/hadoop/hadoop-3.2.2/data/ /opt/module/hadoop/hadoop-3.2.2/logs/";
rm -rf /opt/module/hadoop/hadoop-3.2.2/etc/;
cp -r /opt/module/hadoop/etc/ /opt/module/hadoop/hadoop-3.2.2;
sh /opt/module/hadoop/install-hadoop-HA-cluster.sh /opt/module/hadoop/hadoop-HA.conf
