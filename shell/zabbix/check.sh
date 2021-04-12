# vi /etc/keepalived/check.sh
#! /bin/bash
zabbix_server=`ps -C zabbix_server --no-header | wc -l`
mysqld=`ps -C mysqld --no-header | wc -l`
case $1 in
    zabbix-server)
        if [ $zabbix_server -gt 0 ];then
            exit 0
        else
            exit 1
        fi
    ;;
    mysqld)
        if [ $mysqld -gt 0 ];then
            exit 0
        else
            exit 1
        fi
    ;;
esac
#v 该脚本为判断zabbix和mysql服务的状态。



# more zabbix.sh
#! /bin/bash
systemctl start zabbix-server
/etc/keepalived/exp.sh 10.1.100.32 #对端IP
# 备用节点
# more zabbix.sh
#! /bin/bash
systemctl start zabbix-server
/etc/keepalived/exp.sh 10.1.100.31 #对端IP
# 该脚本作用为当主备发生切换或者回切时始终保持有虚ip的机器有zabbix服务而另一台无zabbix服务，保证对外提供服务的只有一台机器。（若两台服务器都提供zabbix服务则每一次事件都会触发两次告警）



# more /etc/keepalived/exp.sh
#!/usr/bin/expect -f
set ip [lindex $argv 0 ]
set timeout 10
spawn ssh root@$ip
expect {
"*yes/no" { send "yes\r"; exp_continue}
"*password:" { send "rootroot\r";exp_continue }
}
expect "#*"
send "systemctl stop zabbix-server\r"
send  "exit\r"
expect eof
# 该脚本作用为当master keepalived崩溃导致主备切换时，notify_backup脚本不会执行，此时造成主备机器同时有zabbix服务。因此当slave切换为master时，拉起zabbix-server服务，同时远程到备机kill掉zabbix进程。
