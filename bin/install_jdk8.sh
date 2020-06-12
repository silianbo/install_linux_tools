#!/bin/bash

###############################################################
#@author bo
#@email silianbo@qq.com
###############################################################

#安装包下载地址
jdklink='http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm'
installpath="/usr/local/java"

#初始化环境
installWget(){
	echo '初始化安装环境....'
	wget
	if [ $? -ne 1 ]; then
		echo '开始下载wget'
		yum -y install wget
	fi
}

#wget下载JDK进行安装
installJDK(){
	ls /usr/local | grep 'jdk.*[rpm]$'
	if [ $? -ne 0 ]; then
		echo '开始下载JDK.......'
		wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" $jdklink
		mv $(ls | grep 'jdk.*[rpm]$') /usr/local
	fi
	chmod 751 /usr/local/$(ls /usr/local | grep 'jdk.*[rpm]$')
	rpm -ivh /usr/local/$(ls /usr/local | grep 'jdk.*[rpm]$')
}

#JDK环境变量配置
pathJDK(){
	#PATH设置
	grep -q "export PATH=" /etc/profile
	if [ $? -ne 0 ]; then
		#末行插入
		echo 'export PATH=$PATH:$JAVA_HOME/bin'>>/etc/profile
	else
		#行尾添加
		sed -i '/^export PATH=.*/s/$/:\$JAVA_HOME\/bin/' /etc/profile
	fi
	
	grep -q "export JAVA_HOME=" /etc/profile
	if [ $? -ne 0 ]; then
		#导入配置
		filename="$(ls /usr/java | grep '^jdk.*[^rpm | gz]$' | sed -n '1p')"
		sed -i "/^export PATH=.*/i\export JAVA_HOME=\/usr\/java\/$filename" /etc/profile
		sed -i '/^export PATH=.*/i\export JRE_HOME=$JAVA_HOME/jre' /etc/profile
		sed -i '/^export PATH=.*/i\export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar' /etc/profile
	else
		#替换原有配置
		filename="$(ls /usr/java | grep '^jdk.*[^rpm | gz]$' | sed -n '1p')"
		sed -i "s/^export JAVA_HOME=.*/export JAVA_HOME=\/usr\/java\/$filename/" /etc/profile
	fi
	source /etc/profile
}

#安装步骤
mainInstall(){
    echo "===================================================================================="
    echo "准备安装jdk，安装路径为$installpath"
    echo -e "开始安装jdk\n 请耐心等待..."
	echo '开始检查本机环境'
	java -version
	if [ $? -ne 0 ]; then
		installWget			
		echo '开始配置JDK，请耐心等待......'
		installJDK
		pathJDK
		java -version
		if [ $? -eq 0 ]; then
			echo 'JDK配置完成'
		else
			echo '安装失败，请重新尝试或手动安装'
		fi
	else
		echo '已经配置该环境'
	fi
}

mainInstall