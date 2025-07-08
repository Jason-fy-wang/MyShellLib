#!/bin/bash

dbuser="DBUser"
dbpassword="DBPassword!"

dbname = "DB"
dbrootpassword = "DBRootPassword!"

yum -y install mariadb mariadb-server
systemctl start mariadb.service
systemctl enable mariadb.service

mysqladmin -u root password "$dbpassword"
$(mysql $dbname -u root --password="$dbpassword" >> /dev/null 2>&1 </dev/null); (($? !=0))
echo "CREATE DATABASE $dbname;" > /tmp/setup.mysql
echo "GRANT ALL ON *.* TO $dbuser@localhost IDENTIFIED BY $dbpassword;" >> /tmp/setup.mysql
echo "GRANT ALL ON *.* TO $dbuser@% IDENTIFIED BY $dbpassword;" >> /tmp/setup.mysql
mysql -u root --password=$dbpassword  < /tmp/setup.mysql
$(mysql $dbname -u root --password="$dbpassword" > /dev/null 2>&1 </dev/null); (($? !=0))

#!/bin/bash 

dbuser="DBUser"
dbpassword="DBPassword!"

dbname="DB"
dbrootpassword="DBRootPassword!"

yum -y install mariadb mariadb-server 
systemctl start mariadb.service 
systemctl enable mariadb.service 

mysqladmin -u root password "$dbrootpassword"
$(mysql $dbname -u root --password="$dbrootpassword" >/dev/null 2>&1 </dev/null); (( $? != 0 )) 
echo CREATE DATABASE $dbname \; > /tmp/setup.mysql 
echo GRANT ALL ON *.* TO "$dbuser"@"localhost" IDENTIFIED BY "'$dbpassword'" \; >> /tmp/setup.mysql 
echo GRANT ALL ON *.* TO "$dbuser"@"'%'" IDENTIFIED BY "'$dbpassword'" \; >> /tmp/setup.mysql 
mysql -u root --password="$dbrootpassword" < /tmp/setup.mysql 
$(mysql $dbname -u root --password="$dbrootpassword" >/dev/null 2>&1 </dev/null); (( $? != 0 )) 


