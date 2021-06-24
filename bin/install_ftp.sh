#!/bin/bash
port="21"
user="ftpuser"
pass="ftpuser"
dir="/home/ftpuser/data"
ip="192.168.80.128"
yum -y install vsftpd*
yum -y install pam*
yum -y install db4*

echo "install ok"
rm -rf /etc/vsftpd
mkdir /etc/vsftpd
rm -f /etc/vsftpd/vsftpd.conf
cat >/etc/vsftpd/vsftpd.conf<<EOF
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
ascii_upload_enable=YES
ascii_download_enable=YES
listen=YES
listen_port=$port
pam_service_name=vsftpd
chroot_list_enable=YES
pasv_promiscuous=YES
pasv_enable=YES
pasv_min_port=60000
pasv_max_port=61000
pasv_address=$ip
use_localtime=YES
dual_log_enable=YES

pam_service_name=vsftpd
guest_enable=YES
guest_username=ftp
user_config_dir=/etc/vsftpd/vuser_conf
EOF

rm -f /etc/vsftpd/chroot_list
touch /etc/vsftpd/chroot_list
rm -f /etc/vsftpd/vuser_passwd.txt
cat >/etc/vsftpd/vuser_passwd.txt<<EOF
$user
$pass
EOF

rm -f /etc/vsftpd/vuser_passwd.db
db_load -T -t hash -f /etc/vsftpd/vuser_passwd.txt /etc/vsftpd/vuser_passwd.db

rm -f /etc/pam.d/vsftpd
cat >/etc/pam.d/vsftpd<<EOF
auth sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser_passwd
account sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser_passwd
EOF

rm -rf /etc/vsftpd/vuser_conf/
mkdir /etc/vsftpd/vuser_conf/

rm -f /etc/vsftpd/vuser_conf/code
cat >/etc/vsftpd/vuser_conf/code<<EOF
local_root=$dir
allow_writeable_chroot=YES
chroot_local_user=YES
write_enable=YES
anon_umask=022
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
EOF

mkdir -p $dir
chmod -R 777 $dir
chown -R $user:$user $dir
setenforce 0
service vsftpd stop
service vsftpd start
systemctl stop vsftpd
systemctl start vsftpd
/sbin/iptables -D INPUT -p tcp --dport $port -j ACCEPT
/sbin/iptables -I INPUT -p tcp --dport $port -j ACCEPT
/sbin/iptables -D INPUT -p tcp --dport 60000:61000 -j ACCEPT
/sbin/iptables -I INPUT -p tcp --dport 60000:61000 -j ACCEPT
netstat -tunlp|grep $port
