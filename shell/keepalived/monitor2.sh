#!/bin/bash
FILE=/etc/keepalived/keepalived.conf
# file exists 
Key=virtual_ipaddress
Key2=unicast_peer
VIP=$(sed -n -e "/${Key}/,+1p"  ${FILE} | grep -v  "${Key}" | awk '{print $1}')
PIP=$(sed -n "/${Key2}/,+1p" /etc/keepalived/keepalived.conf | grep -v "${Key2}" | awk '{print $1'})
$(ping -c 1 -t 1 $VIP >>/dev/null 2>&1) 
RES=$?
TCHECK=$(ps -ef | grep -v grep | grep keepalived >>/dev/null 2>&1)

if [ "$RES" -eq 0 -a  -n "$TCHECK" ];then
    echo 0
else 
    echo 1
    if [ -n "$TCHECK" ]; then
        # start
        $(keepalived)
    fi
fi


