#!/bin/bash
# health check
fpath='/etc/keepalived/keepalived.conf'
if [ ! -f "$fpath" ]; then
    echo "Should have keepalived conf"
    exit 1
fi
key="virtual_ipaddress"
vip=$(sed -n  "/${key}/,+1p" ${fpath} | grep -v "grep\|${key}"  | awk '{print $1}')

# alived; vip是否在当前机器上
$(ifconfig | grep "${vip}" > /dev/null 2>&1)
alived=$?

# running; 进程是否在运行
$(ps -ef|grep 'proc_name=fcaps-rem_sms_agent'|grep -v grep > /dev/null 2>&1)
rst=$?

# avtive 机器, app不存在,拉起并报警
# inctive 机器, app存在,则关闭 echo 0
if [ 0 -eq "$alived" ]; then
    if [ 1 -eq "$rst" ]; then
        echo 1
        echo "start app"
        exit 1
    fi
    echo 0
else 
    if [ 0 -eq "$rst" ];then
        echo 1
        echo "stop app"
        exit 1
    fi
    echo 0
fi



