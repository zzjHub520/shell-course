#!/bin/bash


hadoopConf=$1

hadoopPath=`sed -n '/hadoopPath/p' ${hadoopConf} | tr -d [:space:] | awk -F "=" '{print $2}'`
nameNode=`sed -n '/nameNode/p' ${hadoopConf} | tr -d [:space:] | awk -F "=" '{print $2}'`
secondaryNameNode=`sed -n '/secondaryNameNode/p' ${hadoopConf} | tr -d [:space:] | awk -F "=" '{print $2}'`
workNodes=(`sed -n '/workNodes/p' ${hadoopConf} | tr -d [:space:] | awk -F "=" '{print $2}' | tr "," " "`)
yarnNode=`sed -n '/yarnNode/p' ${hadoopConf} | tr -d [:space:] | awk -F "=" '{print $2}'`

function hadoop_env(){
	sed -i '$a\export HDFS_NAMENODE_USER=root' ${hadoopPath}/etc/hadoop/hadoop-env.sh
	sed -i '$a\export HDFS_DATANODE_USER=root' ${hadoopPath}/etc/hadoop/hadoop-env.sh
	sed -i '$a\export HDFS_SECONDARYNAMENODE_USER=root' ${hadoopPath}/etc/hadoop/hadoop-env.sh
	sed -i '$a\export YARN_RESOURCEMANAGER_USER=root' ${hadoopPath}/etc/hadoop/hadoop-env.sh
	sed -i '$a\export YARN_NODEMANAGER_USER=root' ${hadoopPath}/etc/hadoop/hadoop-env.sh
}

function core_site(){
	local fileName=${hadoopPath}/etc/hadoop/core-site.xml

	sed -i '/<\/configuration>/i\    <!-- 指定hdfs的NameNode -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>fs.defaultFS</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>hdfs://'"${nameNode}"':8020</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName

	sed -i '/<\/configuration>/i\    <!-- 指定hadoop临时目录 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>hadoop.tmp.dir</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>'"${hadoopPath}"'/data</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
}

function hdfs_site(){
	local fileName=${hadoopPath}/etc/hadoop/hdfs-site.xml

	sed -i '/<\/configuration>/i\    <!-- nameNode web端访问地址 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>dfs.namenode.http-address</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>'"${nameNode}"':9870</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName

	sed -i '/<\/configuration>/i\    <!-- 2nn web端访问地址 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>dfs.namenode.secondary.http-address</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>'"${secondaryNameNode}"':9868</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
}

function mapred_site(){
	local fileName=${hadoopPath}/etc/hadoop/mapred-site.xml

	sed -i '/<\/configuration>/i\    <!-- 指定MapReduce程序运行在Yarn上  -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>mapreduce.framework.name</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>yarn</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName
}

function yarn_site(){
	local fileName=${hadoopPath}/etc/hadoop/yarn-site.xml

	sed -i '/<\/configuration>/i\    <!-- 指定MR走shuffle -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>yarn.nodemanager.aux-services</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>mapreduce_shuffle</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName

	sed -i '/<\/configuration>/i\    <!-- 指定ResourceManager的地址 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>yarn.resourcemanager.hostname</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>'"${yarnNode}"'</value>' $fileName
	sed -i '/<\/configuration>/i\    </property>' $fileName
	sed -i '/<\/configuration>/{x;p;x;G;}' $fileName

	sed -i '/<\/configuration>/i\    <!-- 环境变量的继承 -->' $fileName
	sed -i '/<\/configuration>/i\    <property>' $fileName
	sed -i '/<\/configuration>/i\        <name>yarn.nodemanager.env-whitelist</name>' $fileName
	sed -i '/<\/configuration>/i\        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>' $fileName
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

	for((i=0; i<${#workNodes[@]}; i++))
	do
		editOnlyOneKeyWordLine $fileName localhost ${workNodes[$i]}
	done
}

# 分发文件
function xsync(){
	declare -A hostMap
	local xsyncHostArray=()

  hostMap[${nameNode}]=1
  hostMap[${secondaryNameNode}]=1
  hostMap[${yarnNode}]=1

	for((i=0; i<${#workNodes[@]}; i++))
	do
		hostMap[${workNodes[$i]}]=1
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

hadoop_env
core_site
hdfs_site
mapred_site
workers
yarn_site
xsync ${hadoopPath}
