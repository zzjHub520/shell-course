#!/bin/bash

hadoopHAConf=$1

hadoopPath=`sed -n '/hadoopPath/p' ${hadoopHAConf} | tr -d [:space:] | awk -F "=" '{print $2}'`
zookeeperQuorum=`sed -n '/zookeeperQuorum/p' ${hadoopHAConf} | tr -d [:space:] | awk -F "=" '{print $2}'`
dfsNameservices=`sed -n '/dfsNameservices/p' ${hadoopHAConf} | tr -d [:space:] | awk -F "=" '{print $2}'`
dfsHaNamenodes=(`sed -n '/dfsHaNamenodes/p' ${hadoopHAConf} | tr -d [:space:] | awk -F "=" '{print $2}' | tr "," " "`)
workerNodes=(`sed -n '/workerNodes/p' ${hadoopHAConf} | tr -d [:space:] | awk -F "=" '{print $2}' | tr "," " "`)
journalNodes=(`sed -n '/journalNodes/p' ${hadoopHAConf} | tr -d [:space:] | awk -F "=" '{print $2}' | tr "," " "`)
yarnHaResourcemanageresNodes=(`sed -n '/yarnHaResourcemanageresNodes/p' ${hadoopHAConf} | tr -d [:space:] | awk -F "=" '{print $2}' | tr "," " "`)
jobhistoryHost=`sed -n '/jobhistoryHost/p' ${hadoopHAConf} | tr -d [:space:] | awk -F "=" '{print $2}'`
jobhistoryWebappPort=`sed -n '/jobhistoryWebappPort/p' ${hadoopHAConf} | tr -d [:space:] | awk -F "=" '{print $2}'`

function hadoop_env(){
	sed -i '$a\export HDFS_NAMENODE_USER=root' ${hadoopPath}/etc/hadoop/hadoop-env.sh
	sed -i '$a\export HDFS_DATANODE_USER=root' ${hadoopPath}/etc/hadoop/hadoop-env.sh
	sed -i '$a\export HDFS_SECONDARYNAMENODE_USER=root' ${hadoopPath}/etc/hadoop/hadoop-env.sh
	sed -i '$a\export HDFS_JOURNALNODE_USER=root' ${hadoopPath}/etc/hadoop/hadoop-env.sh
	sed -i '$a\export HDFS_ZKFC_USER=root' ${hadoopPath}/etc/hadoop/hadoop-env.sh
	sed -i '$a\export YARN_RESOURCEMANAGER_USER=root' ${hadoopPath}/etc/hadoop/hadoop-env.sh
	sed -i '$a\export YARN_NODEMANAGER_USER=root' ${hadoopPath}/etc/hadoop/hadoop-env.sh
}

function core_site(){
	local fileName=${hadoopPath}/etc/hadoop/core-site.xml
	
	sed -i '/<\/configuration>/i\    <!-- 指定hdfs的nameservice -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>fs.defaultFS</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>hdfs://'"${dfsNameservices}"'</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	sed -i '/<\/configuration>/i\    <!-- 指定hadoop临时目录 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>hadoop.tmp.dir</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>'"${hadoopPath}"'/data</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	sed -i '/<\/configuration>/i\    <!-- 指定zookeeper地址 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>ha.zookeeper.quorum</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>'"${zookeeperQuorum}"'</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
}

function hdfs_site(){
	local fileName=${hadoopPath}/etc/hadoop/hdfs-site.xml
	
	local dfsReplication=`sed -n '/dfsReplication/p' ${hadoopHAConf} | tr -d [:space:] | awk -F "=" '{print $2}'`
	sed -i '/<\/configuration>/i\    <!-- 副本个数 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>dfs.replication</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>'"${dfsReplication}"'</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	sed -i '/<\/configuration>/i\    <!-- 指定hdfs的nameservice为mycluster，需要和core-site.xml中的保持一致 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>dfs.nameservices</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>'"${dfsNameservices}"'</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	sed -i '/<\/configuration>/i\    <!-- namenode数据存放位置 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>dfs.namenode.data.dir</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>'"${hadoopPath}"'/data/dfs/name</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	sed -i '/<\/configuration>/i\    <!-- datanode数据存放位置 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>dfs.datanode.data.dir</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>'"${hadoopPath}"'/data/dfs/data</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	sed -i '/<\/configuration>/i\    <!-- 指定JournalNode在本地磁盘存放数据的位置 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>dfs.journalnode.edits.dir</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>'"${hadoopPath}"'/data/journaldata</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	####################### namenodes #################################################
	local nnstr=""
	for((i=0; i<${#dfsHaNamenodes[@]}; i++))
	do
		nnstr=${nnstr}",nn"$((i+1))
	done
	nnstr=${nnstr:1}
	
	sed -i '/<\/configuration>/i\    <!-- '"${dfsNameservices}"'下面有两个NameNode，分别是 '"${nnstr}"' -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>dfs.ha.namenodes.'"${dfsNameservices}"'</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>'"${nnstr}"'</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	local nameNodeRPCPort=`sed -n '/nameNodeRPCPort/p' ${hadoopHAConf} | tr -d [:space:] | awk -F "=" '{print $2}'`
	sed -i '/<\/configuration>/i\    <!-- RPC通信地址 -->' $fileName
	for((i=0; i<${#dfsHaNamenodes[@]}; i++))
	do
		sed -i '/<\/configuration>/i\    <property>' $fileName
		sed -i '/<\/configuration>/i\        <name>dfs.namenode.rpc-address.'"${dfsNameservices}"'.nn'"$((i+1))"'</name>' $fileName
		sed -i '/<\/configuration>/i\        <value>'"${dfsHaNamenodes[$i]}"':'"${nameNodeRPCPort}"'</value>' $fileName
		sed -i '/<\/configuration>/i\    </property>' $fileName
	done	
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	local nameNodeHttpPort=`sed -n '/nameNodeHttpPort/p' ${hadoopHAConf} | tr -d [:space:] | awk -F "=" '{print $2}'`
	sed -i '/<\/configuration>/i\    <!-- http通信地址 -->' $fileName
	for((i=0; i<${#dfsHaNamenodes[@]}; i++))
	do
		sed -i '/<\/configuration>/i\    <property>' $fileName
		sed -i '/<\/configuration>/i\        <name>dfs.namenode.http-address.'"${dfsNameservices}"'.nn'"$((i+1))"'</name>' $fileName
		sed -i '/<\/configuration>/i\        <value>'"${dfsHaNamenodes[$i]}"':'"${nameNodeHttpPort}"'</value>' $fileName
		sed -i '/<\/configuration>/i\    </property>' $fileName
	done
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	############# 设置JournalNode #########################
	local journalNodePort=`sed -n '/journalNodePort/p' ${hadoopHAConf} | tr -d [:space:] | awk -F "=" '{print $2}'`
	local editsDirStr=""
	for((i=0; i<${#journalNodes[@]}; i++))
	do
		editsDirStr=${editsDirStr}";"${journalNodes[$i]}":"${journalNodePort}
	done
	editsDirStr=${editsDirStr:1}
	
	sed -i '/<\/configuration>/i\    <!-- 指定NameNode的edits元数据在JournalNode上的存放位置 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>dfs.namenode.shared.edits.dir</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>qjournal://'"${editsDirStr}"'/'"${dfsNameservices}"'</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName

	sed -i '/<\/configuration>/i\    <!-- 开启NameNode失败自动切换 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>dfs.ha.automatic-failover.enabled</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>true</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName

	sed -i '/<\/configuration>/i\    <!-- 配置失败自动切换实现方式 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>dfs.client.failover.proxy.provider.'"${dfsNameservices}"'</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName

	sed -i '/<\/configuration>/i\    <!-- 配置隔离机制方法，多个机制用换行分割，即每个机制暂用一行 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>dfs.ha.fencing.methods</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>sshfence</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName

	sed -i '/<\/configuration>/i\    <!-- 使用sshfence隔离机制时需要ssh免登陆 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>dfs.ha.fencing.ssh.private-key-files</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>/root/.ssh/id_rsa</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName

	sed -i '/<\/configuration>/i\    <!-- 配置sshfence隔离机制超时时间 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>dfs.ha.fencing.ssh.connect-timeout</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>30000</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
}

function mapred_site(){
	local fileName=${hadoopPath}/etc/hadoop/mapred-site.xml
		
	sed -i '/<\/configuration>/i\    <!-- 指定mr框架为yarn方式 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>mapreduce.framework.name</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>yarn</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	local jobhistoryPort=`sed -n '/jobhistoryPort/p' ${hadoopHAConf} | tr -d [:space:] | awk -F "=" '{print $2}'`
	sed -i '/<\/configuration>/i\    <!-- 历史服务器端地址 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>mapreduce.jobhistory.address</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>'"${jobhistoryHost}"':'"${jobhistoryPort}"'</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	
	sed -i '/<\/configuration>/i\    <!-- 历史服务器web端地址 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>mapreduce.jobhistory.webapp.address</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>'"${jobhistoryHost}"':'"${jobhistoryWebappPort}"'</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
}

# 编辑某一个关键字，有就编辑，没有就追加
function editOnlyOneKeyWordLine(){
	FILENAME=$1
	KEYLINE=$2
	REPLACELINE=$3

	if [ `sed -n '/'"$KEYLINE"'/p' $FILENAME | wc -l` -gt 0 ];then
		sed -i '/'"$KEYLINE"'/c\'"$REPLACELINE"'' $FILENAME
	else
		sed -i '1i\'"$REPLACELINE"'' $FILENAME
	fi
}

function workers(){
	local fileName=${hadoopPath}/etc/hadoop/workers
		
	for((i=0; i<${#workerNodes[@]}; i++))
	do
		editOnlyOneKeyWordLine $fileName localhost ${workerNodes[$i]}
	done
}

function yarn_site(){
	local fileName=${hadoopPath}/etc/hadoop/yarn-site.xml
	
	sed -i '/<\/configuration>/i\    <!-- 开启RM高可用 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>yarn.resourcemanager.ha.enabled</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>true</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName

	sed -i '/<\/configuration>/i\    <!-- 指定RM的cluster id -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>yarn.resourcemanager.cluster-id</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>yrc</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName

	#################### ResourcemanageresNodes ##################################
	local rmstr=""
	for((i=0; i<${#yarnHaResourcemanageresNodes[@]}; i++))
	do
		rmstr=${rmstr}",rm"$((i+1))
	done
	rmstr=${rmstr:1}
	
	sed -i '/<\/configuration>/i\    <!-- 指定RM的名字 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>yarn.resourcemanager.ha.rm-ids</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>'"${rmstr}"'</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName

	sed -i '/<\/configuration>/i\    <!-- 分别指定RM的地址 -->' $fileName
	for((i=0; i<${#yarnHaResourcemanageresNodes[@]}; i++))
	do
		sed -i '/<\/configuration>/i\    <property>' $fileName
		sed -i '/<\/configuration>/i\        <name>yarn.resourcemanager.hostname.rm'"$((i+1))"'</name>' $fileName
		sed -i '/<\/configuration>/i\        <value>'"${yarnHaResourcemanageresNodes[$i]}"'</value>' $fileName
		sed -i '/<\/configuration>/i\    </property>' $fileName
	done	
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName

	local yarnNodeWebappPort=`sed -n '/yarnNodeWebappPort/p' ${hadoopHAConf} | tr -d [:space:] | awk -F "=" '{print $2}'`
	sed -i '/<\/configuration>/i\    <!-- Hadoop YARN资源管理系统 -->' $fileName
	for((i=0; i<${#yarnHaResourcemanageresNodes[@]}; i++))
	do
		sed -i '/<\/configuration>/i\    <property>' $fileName
		sed -i '/<\/configuration>/i\        <name>yarn.resourcemanager.webapp.address.rm'"$((i+1))"'</name>' $fileName
		sed -i '/<\/configuration>/i\        <value>'"${yarnHaResourcemanageresNodes[$i]}"':'"${yarnNodeWebappPort}"'</value>' $fileName
		sed -i '/<\/configuration>/i\    </property>' $fileName
	done	
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	
	sed -i '/<\/configuration>/i\    <!-- 指定zk集群地址 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>yarn.resourcemanager.zk-address</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>'"${zookeeperQuorum}"'</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	sed -i '/<\/configuration>/i\    <!-- nodemanager获取数据的方式 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>yarn.nodemanager.aux-services</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>mapreduce_shuffle</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	# 日志功能
	sed -i '/<\/configuration>/i\    <!-- 开启日志聚集功能 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>yarn.log-aggregation-enable</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>true</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	sed -i '/<\/configuration>/i\    <!-- 设置日志聚集服务器地址 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>yarn.log.server.url</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>http://'"${jobhistoryHost}"':'"${jobhistoryWebappPort}"'/jobhistory/logs</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
	
	sed -i '/<\/configuration>/i\    <!-- 设置日志保留时间为7天 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>yarn.log-aggregation.retain-seconds</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>604800</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
}

# 分发文件
function xsync(){
	declare -A hostMap
	local xsyncHostArray=()
	
	for((i=0; i<${#dfsHaNamenodes[@]}; i++))
	do
		hostMap[${dfsHaNamenodes[$i]}]=1
	done	
	
	for((i=0; i<${#workerNodes[@]}; i++))
	do
		hostMap[${workerNodes[$i]}]=1
	done
	
	for((i=0; i<${#journalNodes[@]}; i++))
	do
		hostMap[${journalNodes[$i]}]=1
	done

	for((i=0; i<${#yarnHaResourcemanageresNodes[@]}; i++))
	do
		hostMap[${yarnHaResourcemanageresNodes[$i]}]=1
	done

	for key in ${!hostMap[@]};do
		xsyncHostArray[${#xsyncHostArray[@]}]=$key
	done
	
	#1. 判断参数个数
	if [ $# -lt 1 ]
	then
		echo Not Enough Arguement!
		exit;
	fi

	#2. 遍历集群所有机器
	for host in ${xsyncHostArray[@]}
	do
		echo ====================  $host  ====================
		#3. 遍历所有目录，挨个发送

		for file in $@
		do
			#4. 判断文件是否存在
			if [ -e $file ]
				then
					#5. 获取父目录
					pdir=$(cd -P $(dirname $file); pwd)

					#6. 获取当前文件的名称
					fname=$(basename $file)
					ssh $host "mkdir -p $pdir"
					rsync -av $pdir/$fname $host:$pdir
				else
					echo $file does not exists!
			fi
		done
	done
}

function initialDfs(){
	# 启动journalnode
	for host in ${journalNodes[@]}
	do
		echo ====================  $host  ====================
		#3. 遍历所有目录，挨个发送
		ssh $host "hdfs --daemon start journalnode"
		ssh $host jps
	done
	
	sleep 2s
	# 格式化 HDFS
	hdfs namenode -format
	# # 主节点
	hdfs --daemon start namenode
	# # 备用节点
	for((i=1; i<${#dfsHaNamenodes[@]}; i++))
	do
		echo ====================  ${dfsHaNamenodes[$i]}  ====================
		#3. 遍历所有目录，挨个发送
		ssh ${dfsHaNamenodes[$i]} "hdfs namenode -bootstrapStandby"
	done
	
	# 格式化ZKFC
	echo Y | hdfs zkfc -formatZK
}

hadoop_env
core_site
hdfs_site
mapred_site
workers
yarn_site
xsync ${hadoopPath}

initialDfs
start-all.sh
mapred --daemon start historyserver
