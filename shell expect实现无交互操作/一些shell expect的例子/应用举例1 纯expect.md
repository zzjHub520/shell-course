## 应用举例1

##### 纯expect 

```shell 
#!/usr/tcl/bin/expect：
#使用expect来解释该脚本；

set timeout 30：
#设置spawn执行后等候回应的超时时间，单位为秒，默认情况下是10秒；可以设置为-1，表示无限制。

set host "192.168.92.100"：
#设置变量；
set username "root"#设置用户名;
set password "123456"#设置密码;
spawn ssh \$username@\$host：spawn #是进入expect环境后才可以执行的expect内部命令，如果没有装expect或者直接在默认的SHELL下执行是找不到spawn命令的。它主要的功能是给ssh运行进程加个壳，用来传递交互指令； "yes/no" { send "yes\r"; exp_continue; } #选择是否信任该IP expect "*password*"： #这里的expect也是expect的一个内部命令，这个命令的意思是判断上次输出结果里是否包含“password”的字符串，如果有则立即返回；否则就等待一段时间后返回，这里等待时长就是前面设置的30秒； send "\$password\r"： #当匹配到对应的输出结果时，就发送密码到打开的ssh进程，执行交互动作； interact： #执行完成后保持交互状态，把控制权交给控制台，这个时候就可以手工操作了。如果没有这一句登录完成后会退出，而不是留在远程终端上，这个功能是我们在需要完成人工干预的情况下所做的选择。
```



## 应用举例2（在shell脚本中应用expect并执行命令）：

```shell
#!/bin/bash
/usr/bin/expect << EOF
#在shell中调用expect
spawn ssh root@192.168.92.129
expect {
"yes/no" { send "yes\r"; exp_continue; }
"password" { send "123\r" }
}
expect "]*"
#root用户为]#,普通用户为]$，我们选择*来模糊匹配
send "cd / && ls\r"
expect "]*"
send "exit\r"
EOF

```



##  示例一

```shell
1.安装expect  系统默认没有此命令
   yum install expect

2.创建配置文件
[root@ansible ssh]# vi hosts
192.168.31.134 root root
192.168.31.135 root root
192.168.31.136 root root

3.编写脚本
[root@ansible ssh]# ls
copykey.sh  hosts
[root@ansible ssh]# vi copykey.sh 
#!/bin/bash
if [ ! -f ~/.ssh/id_rsa ];then
 ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
else
 echo "id_rsa has created ..."
fi
#分发到各个节点
while read line
  do
    user=`echo $line | cut -d " " -f 2`
    ip=`echo $line | cut -d " " -f 1`
    passwd=`echo $line | cut -d " " -f 3`
    expect <<EOF
      set timeout 10
      spawn ssh-copy-id $user@$ip
      expect {
        "yes/no" { send "yes\n";exp_continue }
        "password" { send "$passwd\n" }
      }
     expect "password" { send "$passwd\n" }
EOF
  done <  hosts

4.给脚本执行权限
  chmod +x copykey.sh

5.执行脚本
   ./copykey.sh
```

读取配置文件自动执行ssh



##  实例二

```shell
#!/usr/bin/expect
spawn scp /etc/fstab root@192.168.33.129:/root
expect {
     "yes/no" { send "yes\n";exp_continue }
     "password" { send "root\n" }
}
expect eof



[root@centos7 ~]# bash one.expect 
one.expect: line 2: spawn: command not found
couldn't read file "{": no such file or directory
one.expect: line 4: yes/no: No such file or directory
one.expect: line 4: exp_continue: command not found
one.expect: line 5: password: command not found
one.expect: line 6: syntax error near unexpected token `}'
one.expect: line 6: `}'
[root@centos7 ~]# ./one.expect 
spawn scp /etc/fstab root@192.168.33.129:/root
The authenticity of host '192.168.33.129 (192.168.33.129)' can't be established.
RSA key fingerprint is SHA256:FzQU22CgZBnSbmZAuoypliidxPK9PsOFjJwcYUZWk5E.
RSA key fingerprint is MD5:a8:2b:51:c3:dc:09:65:89:78:d2:d5:e0:9f:e9:30:1a.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.33.129' (RSA) to the list of known hosts.
root@192.168.33.129's password: 
fstab
```



##  实例三

```shell
#!/usr/bin/expect 
  set ip [lindex $argv 0] 
  set user [lindex $argv 1] 
  set password [lindex $argv 2] 
  set timeout 10 
  spawn ssh $user@$ip 
   expect {   
       "yes/no" { send "yes\n";exp_continue }         
       "password" { send "$password\n" } 
    } 
   expect "]#" { send "useradd haha\n" }
   expect "]#" { send "echo aaa|passwd --stdin haha\n" }
   send "exit\n" expect eof 
  #./ssh4.exp 192.168.8.100 root aa
```

执行多条命令



## 实例四

```shell
#!/bin/bash 
ip=$1  
user=$2 
password=$3 
expect <<EOF  
    set timeout 10 
    spawn ssh $user@$ip 
    expect { 
        "yes/no" { send "yes\n";exp_continue } 
        "password" { send "$password\n" }
    } 
    expect "]#" { send "useradd hehe\n" } 
    expect "]#" { send "echo rrr|passwd --stdin hehe\n" } 
    expect "]#" { send "exit\n" } expect eof 
 EOF  
 #./ssh5.sh 192.168.8.100 root aaa 
```

shell调用expect