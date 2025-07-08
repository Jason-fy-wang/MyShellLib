#!/bin/bash 

# 提示mysqlhost的值将会自动替换为数据库ECS地址。
mysqlhost="%s"
dbuser="DBUser"
dbpassword="DBPassword!"

export HOME=/root 
export HOSTNAME=`hostname` 
systemctl stop firewalld.service 
systemctl disable firewalld.service 
sed -i 's/^SELINUX=/# SELINUX=/' /etc/selinux/config 
sed -i '/# SELINUX=/a SELINUX=disabled' /etc/selinux/config 
setenforce 0 
yum -y install httpd httpd-manual mod_ssl mod_perl mod_auth_mysql
yum install yum-priorities -y 
yum -y install php-fpm 
systemctl start php-fpm.service 
systemctl enable php-fpm.service 
yum -y install php php-mysql php-gd libjpeg* php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-bcmath php-mhash php-mcrypt 
MDSRING=`find / -name mbstring.so` 
echo extension=$MDSRING >> /etc/php.ini 
systemctl start httpd.service 
cd /root 
systemctl restart php-fpm.service 
echo \<?php >  /var/www/html/test.php 
echo \$conn=mysql_connect\("'$mysqlhost'", "'$dbuser'", "'$dbpassword'"\)\; >>  /var/www/html/test.php 
echo if \(\$conn\){ >>  /var/www/html/test.php 
echo   echo \"LAMP platform connect to mysql is successful\!\"\; >>  /var/www/html/test.php 
echo   }else{  >>  /var/www/html/test.php 
echo echo \"LAMP platform connect to mysql is failed\!\"\;  >>  /var/www/html/test.php 
echo }  >>  /var/www/html/test.php 
echo \?\>  >>  /var/www/html/test.php 