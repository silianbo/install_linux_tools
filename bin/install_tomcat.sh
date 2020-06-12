#!/bin/bash

###############################################################
#@author bo
#@email silianbo@qq.com
###############################################################

installpath="/usr/local/tomcat"

echo "===================================================================================="
echo "准备安装tomcat，安装路径为$installpath"
echo -e "开始安装tomcat\n 请耐心等待..."

tomcatEnvironment=""

if [ ! -d $installpath/tomcat* ]	
then
	mkdir -p $installpath
	tar -zxf ../tools/apache-tomcat*.tar.gz -C $installpath
fi

cd $installpath/apache-tomcat*
tomcatEnvironment=$(pwd)
cd ./bin

abc=$(grep '#Tomcat Environment configuration by silianbo@qq.com' /etc/profile)
if [ -n  "${abc}" ]||[ "${CATALINA_HOME}" != "" ]
then
	echo "环境已存在tomcat，无需重复配置"
else
	sed -i "\$a \\\n\n#Tomcat Environment configuration by silianbo@qq.com\
	\nexport CATALINA_BASE=${tomcatEnvironment}\
	\nexport CATALINA_HOME=\$CATALINA_BASE\
	\nexport PATH=\$PATH:\$CATALINA_HOME/bin" /etc/profile
	
	source /etc/profile
fi

echo -e "Tomcat版本信息为\n:"
sh catalina.sh version
if [ ! $? -eq 0 ]
then
	echo "安装失败,请联系管理人员."
else
	echo "安装tomcat成功!"
fi