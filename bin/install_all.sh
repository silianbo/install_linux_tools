#!/bin/bash

###############################################################
#@author bo
#@email silianbo@qq.com
###############################################################

lalala="/tools/bin"
if [[ $(pwd) == *$lalala* ]]
then	
	echo"---------------- install jdk ----------------------------"
	read -p "whether to continue install the configurate file [====jdk====][y/n]" REPLACE
	if [ "$REPLACE" == "y" ]||[ "$REPLACE" == "Y" ]
	then
		sh install_jdk.sh
	else
		echo "cancel install the configurate file [====jdk====]"
	fi

	echo"---------------- install tomcat --------------------------"
	read -p "whether to continue install the configurate file [====tomcat====][y/n]" REPLACE
	if [ "$REPLACE" == "y" ]||[ "$REPLACE" == "Y" ]
	then
		sh install_tomcat.sh
	else
		echo "cancel install the configurate file [====tomcat====]"
	fi

	echo"---------------- install mysql --------------------------"
	read -p "whether to continue install the configurate file [====mysql====][y/n]" REPLACE
	if [ "$REPLACE" == "y" ]||[ "$REPLACE" == "Y" ]
	then
		sh install_mysql.sh
	else
		echo "cancel install the configurate file [====mysql====]"
	fi

	echo"------------------ finished ------------------------------"

else
	echo "Please contact the administrator[install_all.sh] "
fi