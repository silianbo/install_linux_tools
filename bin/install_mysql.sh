#!/bin/bash

###############################################################
#@author bo
#@email silianbo@qq.com
###############################################################

installpath="/usr/local/mysql"

echo "===================================================================================="
echo "准备安装mysql，安装路径为$installpath"
echo -e "开始安装mysql\n 请耐心等待..."

rpm -ivh ../mysql*.rpm
yum install mysql-community-server
service mysqld start
grep 'temporary password' /var/log/mysqld.log
echo "please save automatic generating password of mysql where above！！！"
echo -e "mysql -uroot -p\
\nset global validate_password_policy=0;\
\nALTER USER 'root'@'localhost' IDENTIFIED BY '73979901995';\
\ngrant all on *.* to root@"%" identified by "73979901995";\
\nflush privileges;"