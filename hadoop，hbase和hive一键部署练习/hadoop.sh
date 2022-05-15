#!/bin/bash

#hadoop deploy

#sed -i '/<\/configuration>/i\hello world1' ./hadoop-3.1.3/etc/hadoop/core-site.xml
#sed -i '/<\/configuration>/i\hello world2' ./hadoop-3.1.3/etc/hadoop/core-site.xml

hadoop_core_site=./hadoop-3.1.3/etc/hadoop/core-site.xml
declare -A core_map=(['key1']="value1" ['key2']='value2')
arrkey=(`echo ${!core_map[*]}`)
for	((i=0;i<${#arrkey[@]};i++)) 
do
	#echo "${arrkey[i]} ${core_map[${arrkey[i]}]}"
	sed -i '/<\/configuration>/i\    <property>' ${hadoop_core_site}
	sed -i "/<\/configuration>/i\        <name>${arrkey[i]}<\/name>" ${hadoop_core_site}
	sed -i "/<\/configuration>/i\        <value>${core_map[${arrkey[i]}]}<\/value>" ${hadoop_core_site}
	sed -i '/<\/configuration>/i\    <\/property>' ${hadoop_core_site}
	sed -i '/<\/configuration>/i\ ' ${hadoop_core_site}
done
