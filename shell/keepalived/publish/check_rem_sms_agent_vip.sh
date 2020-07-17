#!/bin/bash
FILE=/etc/keepalived/keepalived.conf
if [ ! -e $FILE ]; then
    echo "Should have keepalived conf"
    exit 1
fi
Key=virtual_ipaddress
VIP=$(sed -n -e "/${Key}/,+1p"  ${FILE} | grep -v  "${Key}" | awk '{print $1}')
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