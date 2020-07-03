#!/bin/bash
#
# 监测vip的脚本; 思路: vip可用且keepalived存活,则输出0; vip 或者 keepalived有一个 不正常,则输出1
#
# health check; keepalived 配置文件必须存在
FILE=/etc/keepalived/keepalived.conf
if [ ! -e $FILE ]; then
    echo "Should have keepalived conf"
    exit 1
fi
Key=virtual_ipaddress
VIP=$(sed -n -e "/${Key}/,+1p"  ${FILE} | grep -v  "${Key}" | awk '{print $1}')
# 
$(ping -c 1 -t 1 $VIP > /dev/null 2>&1) 
RES=$?
$(ps -ef | grep -v grep | grep keepalived > /dev/null 2>&1)
TCHECK=$?

if [ "$RES" -ne 0 ] || [ "$TCHECK" -ne 0 ]; then
    echo 1
    if [ "$TCHECK" -ne 0 ]; then
        $(keepalived >/dev/null 2>&1)
    fi
    exit 1
fi
echo 0

