## 修改启动JVM内存参数（非必要）
elasticsearch启动默认1G内存，若虚拟机内存不够可以修改jvm启动参数

进入config目录.修改jvm.options  最大堆内存和最小堆内存为512m

 ![img](MarkDownImages/%E6%9C%AA%E5%91%BD%E5%90%8D.assets/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAUnVudGltZUV4Y2VwdGkwbg==,size_12,color_FFFFFF,t_70,g_se,x_16.png)



## 修改启动参数
进入config目录，修改elasticsearch.yml

```yaml
#设置集群名称
cluster.name: es-test-cluster
#设置节点名称
node.name: node-1
#设置数据文件路径
path.data: /opt/software/elasticSearch/elasticsearch-7.1.0/data/node1-data
#设置日志文件路径
path.logs: /opt/software/elasticSearch/elasticsearch-7.1.0/logs/node1-log
#开启远程连接权限
network.host: 0.0.0.0
#设置端口 默认9200
#http.port: 9200
#本机地址
discovery.seed_hosts: ["192.168.0.103"]
#初始化集群master节点，单机为本节点
cluster.initial_master_nodes: ["node-1"]
http.cors.enabled: true
http.cors.allow-origin: "*"

```



vim /etc/security/limits.conf         在最后面追加下面内容

```conf
*               soft    nofile          65536

*               hard    nofile          65536

*               soft    nproc           4096

*               hard    nproc           4096
```



重新登陆，检测配置是否生效

```shell
ulimit -Hn

ulimit -Sn

ulimit -Hu

ulimit -Su
```



##### vim /etc/security/limits.d/20-nproc.conf 

启动ES用户名（es不能用root启动） soft nproc 4096

![img](MarkDownImages/%E6%9C%AA%E5%91%BD%E5%90%8D.assets/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAUnVudGltZUV4Y2VwdGkwbg==,size_12,color_FFFFFF,t_70,g_se,x_16-16562166770472.png)



使用root用户修改系统配置   vim /etc/sysctl.conf ，增加一行 vm.max_map_count=655360

![img](MarkDownImages/%E6%9C%AA%E5%91%BD%E5%90%8D.assets/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAUnVudGltZUV4Y2VwdGkwbg==,size_14,color_FFFFFF,t_70,g_se,x_16.png)

执行如下命令检测是否生效  sysctl -p

![img](MarkDownImages/%E6%9C%AA%E5%91%BD%E5%90%8D.assets/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAUnVudGltZUV4Y2VwdGkwbg==,size_15,color_FFFFFF,t_70,g_se,x_16.png)



### 重新启动

回到elasitcsearch目录，执行

```python
./bin/elasticsearch
```

如果要将 ES 作为守护程序运行 

```python
./bin/elasticsearch -d -p pid
```