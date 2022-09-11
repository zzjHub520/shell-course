#!/bin/bash

# 节点的host
clusterHostArray[${#clusterHostArray[@]}]=server101
clusterHostArray[${#clusterHostArray[@]}]=server102
clusterHostArray[${#clusterHostArray[@]}]=server103
clusterHostArray[${#clusterHostArray[@]}]=server104

# 编辑某一个关键字，有就编辑，没有就追加
function editOnlyOneKeyWordLine(){
	FILENAME=$1
	KEYLINE=$2
	REPLACELINE=$3

	if [ `sed -n '/'"$KEYLINE"'/p' $FILENAME | wc -l` -gt 0 ];then
		sed -i '/'"$KEYLINE"'/c\'"$REPLACELINE"'' $FILENAME
	else
		sed -i '$a\'"$REPLACELINE"'' $FILENAME
	fi
}

# 分发文件
xsyncHostArray=${clusterHostArray[@]}
function xsync(){
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

#1. 判断参数个数
if [ $# -lt 1 ]
then
    echo Not Enough Arguement!
    exit;
fi

tarfile=$1
pdir=$(cd -P $(dirname $tarfile); pwd)
tarfname=$(basename $tarfile)
cd $pdir
tar zxvf $tarfname

versionNum=`ls $tarfname | awk -F "-" '{print $3}'`
cd apache-zookeeper-${versionNum}-bin/
mkdir zkData
touch ./zkData/myid
cp ./conf/zoo_sample.cfg ./conf/zoo.cfg

editOnlyOneKeyWordLine $pdir/apache-zookeeper-${versionNum}-bin/conf/zoo.cfg "dataDir=" "dataDir=$pdir/apache-zookeeper-${versionNum}-bin/zkData"

sed -i '$a\#######################cluster##########################' $pdir/apache-zookeeper-${versionNum}-bin/conf/zoo.cfg
for((i=0; i<${#clusterHostArray[@]}; i++))
do
	sed -i '$a\server.'"$((i+1))"'='"${clusterHostArray[$i]}"':2888:3888' $pdir/apache-zookeeper-${versionNum}-bin/conf/zoo.cfg
done 

xsync $pdir/apache-zookeeper-${versionNum}-bin

for((i=0; i<${#clusterHostArray[@]}; i++))
do
	echo "$((i+1))" > $pdir/apache-zookeeper-${versionNum}-bin/zkData/myid
	unset xsyncHostArray
	xsyncHostArray=${clusterHostArray[$i]}
	xsync $pdir/apache-zookeeper-${versionNum}-bin
done 

echo "1" > $pdir/apache-zookeeper-${versionNum}-bin/zkData/myid


