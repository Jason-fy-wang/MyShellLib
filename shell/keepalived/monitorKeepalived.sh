#!/bin/bash
FILE=/etc/keepalived/keepalived.conf
# file exists 
Key=virtual_ipaddress
Key2=unicast_peer
VIP=$(sed -n -e "/${Key}/,+1p"  ${FILE} | grep -v  "${Key}" | awk '{print $1}')
PIP=$(sed -n "/${Key2}/,+1p" /etc/keepalived/keepalived.conf | grep -v "${Key2}" | awk '{print $1'})
$(ping -c 1 -t 1 $VIP >>/dev/null 2>&1) 
RES=$?
# localcheck
TCHECK=$(ps -ef | grep -v grep | grep keepalived >>/dev/null 2>&1)

if [ "$RES" -eq 0 -a  -n"$TCHECK" ];then
    echo 0
    exit 0
fi

############### shell 和 expect 的混用
# remote check
expect << EOF
set timeout 10
spawn ssh root@${PIP}
expect {
    "*yes/no" {send "yes\r"; exp_continue}
    "*password:" {send "loongson\r"; exp_continue}
}

expect "#*"
send "ps -ef | grep keepalived >>/dev/null 2>&1 \r"
send "exit\r"
EOF
