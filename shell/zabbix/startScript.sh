#!/bin/bash
cmd=$1
case $cmd in
start)
systemctl start zabbix-server
systemctl start httpd
systemctl start zabbix-agent
#systemctl status php-fpm
;;
status)
systemctl status zabbix-server
systemctl status httpd
systemctl status zabbix-agent
#systemctl status php-fpm
;;
stop)
systemctl stop zabbix-server
systemctl stop  httpd
systemctl stop  zabbix-agent
#systemctl status php-fpm
;;
*)
echo "usage: $0 start|stop|status"
;;
esac
