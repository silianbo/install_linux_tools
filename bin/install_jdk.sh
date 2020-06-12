#!/bin/bash

###############################################################
#@author bo
#@email silianbo@qq.com
###############################################################

installpath="/usr/local/java"
echo "========================================================="
echo "准备安装jdk，安装路径为$installpath"
echo -e "开始安装jdk\n 请耐心等待..."

if [ ! -d $installpath/jdk* ]
then
	mkdir -p $installpath
	tar -zxf ../tools/jdk*.tar.gz -C $installpath
fi

cd $installpath/jdk*

JDKHOME=$(pwd)

cd ../../bin

flag=$(grep '#java Environment configuration by silianbo@qq.com' /etc/profile)
if [ -n  "$flag" ]||[ "$JAVA_HOME" != "" ]
then
	echo "当前环境已安装jdk无需重复安装啦!"
else
	echo "#java Environment configuration by silianbo@qq.com'" >> /etc/profile
	echo "export JAVA_HOME=$JDKHOME" >> /etc/profile
	echo 'export JRE_HOME=$JAVA_HOME/jre' >> /etc/profile
	echo 'export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib' >> /etc/profile
	echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /etc/profile
	source /etc/profile > /dev/null 2>&1
fi

echo $JAVA_HOME
echo $JRE_HOME
java -version

if [ ! $? -eq 0 ]
then
	echo "安装失败,请联系管理人员."
else
	echo "安装jdk成功!"
fi