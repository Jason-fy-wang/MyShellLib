#!/bin/bash
FILE=/etc/keepalived/keepalived.conf
if [ ! -e $FILE ]; then
    echo 1
    exit 1
fi
Key=virtual_ipaddress
Key2=unicast_peer
VIP=$(sed -n -e "/${Key}/,+1p"  ${FILE} | grep -v  "${Key}" | awk '{print $1}')
PIP=$(sed -n "/${Key2}/,+1p" /etc/keepalived/keepalived.conf | grep -v "${Key2}" | awk '{print $1'})
$(ping -c 1 -t 1 $VIP >>/dev/null 2>&1) 
RES=$?
TCHECK=$(ps -ef | grep -v grep | grep keepalived >>/dev/null 2>&1)

if [ "$RES" -eq 0 ];then
    echo 0
else 
    echo 1
fi

if [ -z "$TCHECK" ]; then
    $(keepalived)
fi

