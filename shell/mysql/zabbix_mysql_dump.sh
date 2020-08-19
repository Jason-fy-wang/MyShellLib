#!/bin/bash

systemctl stop zabbix-server
systemctl stop zabbix-agent

mysql -uroot -prootroot -e "
use zabbix;
SET foreign_key_checks=0;
truncate table history;
truncate table history_uint;
truncate table history_str;
truncate table history_text;
truncate table history_log;
truncate table trends;
truncate table trends_uint;
truncate table problem;
truncate table events;
truncate table event_recovery;
SET foreign_key_checks=1;
"
systemctl start zabbix-server
systemctl start zabbix-agent

mysqldump -uroot -prootroot zabbix > /root/zabbix.sql

cd /root

tar zcvf fcaps_HA_zabbix_db.tar.gz zabbix.sql