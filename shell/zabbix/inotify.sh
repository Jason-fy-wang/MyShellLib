#!/bin/bash
ZabbixPath=/etc/zabbix/
WebPath=/etc/httpd/conf/
WebPath2=/etc/httpd/conf.d/
Server=10.1.100.32 #对端IP
/usr/bin/inotifywait -mrq --timefmt '%d/%m/%y %H:%M' --format '%T %w%f%e' -e close_write,delete,create,attrib,move  $WebPath $WebPath2 $ZabbixPath |
while read line
do
    if [[ $line =~ $ZabbixPath ]];then
    rsync -vzrtopg --progress --delete  $ZabbixPath  root@$Server::zabbix  --password-file=/etc/rsyncd.pwd2
    elif [[ $line =~ $WebPath2 ]];then
    rsync -vzrtopg --progress --delete  $WebPath2  root@$Server::web2 --password-file=/etc/rsyncd.pwd2
    elif [[ $line =~ $WebPath ]];then
    rsync -vzrtopg --progress --delete  $WebPath  root@$Server::web1  --password-file=/etc/rsyncd.pwd2
    else
    echo $line >> /var/log/inotify.log
    fi
done
# 该脚本首先是用inotify分别监控 ‘ $WebPath $WebPath2 $ZabbixPath ’ 三个文件的状态，若有变化则分别触发对应的rsync同步。备机配置同主机，只是 ‘ Server ’ 项改为对端IP
