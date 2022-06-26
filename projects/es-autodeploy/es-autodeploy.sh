#!/bin/bash

MYPATH=/opt/module/es
cd $MYPATH
ES_CLUTER_NAME=es-test-cluster
IP=hadoop102
USER=zzj
VERSION=7.10.0
TGZ=/opt/software/elasticsearch-${VERSION}-linux-x86_64.tar.gz

function editOnlyOneLine(){
	FILENAME=$1
	KEYLINE=$2
	REPLACELINE=$3

	if [ `sed -n '/'"$KEYLINE"'/p' $FILENAME | wc -l` -gt 0 ];then
		sed -i '/'"$KEYLINE"'/c\'"$REPLACELINE"' ' $FILENAME
	else
		sed -i '$a\'"$REPLACELINE"'' $FILENAME
	fi
}

if [ -d $MYPATH/elasticsearch-${VERSION} ]; then
	rm rf elasticsearch-${VERSION}
fi

tar zxvf $TGZ -C $MYPATH

sed -i '$a\cluster.name: '"$ES_CLUTER_NAME"' ' $MYPATH/elasticsearch-${VERSION}/config/elasticsearch.yml
sed -i '$a\node.name: node-1 ' $MYPATH/elasticsearch-${VERSION}/config/elasticsearch.yml
sed -i '$a\path.data: '"$MYPATH"'/elasticsearch-'"${VERSION}"'/data/node1-data ' $MYPATH/elasticsearch-${VERSION}/config/elasticsearch.yml
sed -i '$a\path.logs: '"$MYPATH"'/elasticsearch-'"${VERSION}"'/logs/node1-log ' $MYPATH/elasticsearch-${VERSION}/config/elasticsearch.yml
sed -i '$a\network.host: 0.0.0.0 ' $MYPATH/elasticsearch-${VERSION}/config/elasticsearch.yml
sed -i '$a\discovery.seed_hosts: ["'"$IP"'"] ' $MYPATH/elasticsearch-${VERSION}/config/elasticsearch.yml
sed -i '$a\cluster.initial_master_nodes: ["node-1"] ' $MYPATH/elasticsearch-${VERSION}/config/elasticsearch.yml
sed -i '$a\http.cors.enabled: true ' $MYPATH/elasticsearch-${VERSION}/config/elasticsearch.yml
sed -i '$a\http.cors.allow-origin: "*" ' $MYPATH/elasticsearch-${VERSION}/config/elasticsearch.yml

editOnlyOneLine "/etc/security/limits.conf" "*               soft    nofile" "*               soft    nofile          65536"
editOnlyOneLine "/etc/security/limits.conf" "*               hard    nofile" "*               hard    nofile          65536"
editOnlyOneLine "/etc/security/limits.conf" "*               soft    nproc" "*               soft    nproc           4096"
editOnlyOneLine "/etc/security/limits.conf" "*               hard    nproc" "*               hard    nproc           4096"

editOnlyOneLine "/etc/security/limits.d/20-nproc.conf" "*          soft    nproc     4096" "$USER          soft    nproc     4096"

editOnlyOneLine "/etc/sysctl.conf" "vm.max_map_count" "vm.max_map_count=655360"

sysctl -p

chown -R ${USER}:${USER} $MYPATH/elasticsearch-${VERSION}
