#!/bin/bash

# 下载并安装MySQL官方的 Yum Repository
wget -i -c http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm

# 安装mysql57-community-release-el7-10.noarch.rpm
yum -y install mysql57-community-release-el7-10.noarch.rpm

# 原因是Mysql的GPG升级了，需要重新获取
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

# 安装MySQL
yum -y install mysql-community-server

# 查看mysql版本
mysql -V

systemctl start mysqld

grep 'temporary password' /var/log/mysqld.log

