postgresql的流复制是异步的,异步的缺点是standby上的数据落后于主库上的数据,如果使用Hot standby做读写分离,
就会存在数据一致性的问题,对于一些一致性高的应用来说不可接受. 从PG9.1之后提供了同步流复制架构. 
注意:
同步复制要求在数据写入standby数据后,事务的commit才返回,所以standby库出现问题时,会导致主库被hang住.
解决这个问题的方法是启动两个standby数据库,这两个standby数据库只有一个是正常的,就不会导致主库hang住.故在实际应用中,
同步流复制,总是有一个主库和2个以上的standby库.

### 配置:
# 主库主要配置参数: synchronous_standby_names, 此餐宿指定多个standby名称,各个名称之间通过都好分隔.
# standby名称是在standby连接到主库时,由连接参数:application_name 指定的.
# 在standby数据库中,recovery.conf中的primary_conninfo一定要指定连接参数 application_name.
# 环境:
# pg1   10.0.2.60  主库     centos7   
# pg2   10.0.2.61  从库     centos7    
# pg3   10.0.2.62  从库     centos7   
#

# 主库配置: 在pg_hba.conf 中修改
# host replication postgre  10.0.2.0/24  md5
# postgresql.conf
max_wal_senders=4
wal_level=hot_standby
hot_standby=on
# 指定从库名称
synchronous_standby_names='standby01,standby02'

# pg2 从库配置
# recovery.conf
standby_mode='on'
primary_conninfo='application_name=standby01 user=postgre password=postgre host=10.0.20.60 port=5432 sslmode=disable sslcompression=1'
# 启动pg2
pg_ctl start -D/usr/local/postgresql-9.5/data  -l logfile

# pg3配置
# recovery.conf
standby_mode='on'
primary_conninfo='application_name=standby02 user=postgre password=postgre host=10.0.2.60  port=5432 sslmode=disable sslcompression=1'

## 查看同步状态
pocdb=# SELECT client_addr,application_name,sync_state FROM pg_stat_replication;
 client_addr | application_name | sync_state 
-------------+------------------+------------
 10.10.56.17 | slave1           | async
 10.10.56.19 | slave2           | async
(2 rows)


##################################################################################################################################
## 异步同步
# 主库配置
listen_addresses="*"
port=5432
log_destionation="csvlog"
logging_collector=on
log_filename='postgresql-%Y-%m-%d_%H%M%S.log'
max_connections=1000


# 创建复制账户
create USER repl ENCRYPTED PASSWORD '123456' REPLICATION;
# 检查用户权限
\du+
# pg_hba.conf添加用户
host   replication  repl  192.168.1.61/32    md5  # 设置repl用户的登陆方式

## 启动主库
pg_ctl -D /use/lib/data  reload

#### 备库配置
pg_basebackup -h 192.168.1.61 -U repl -W -Fp  -Pv  -Xx -R -D /use/lib/data

# postgres.conf
host_standby=on
# recovery.conf 配置文件
standby_mode='on'
primary_conninfo='user=repl password=123456  host=192.168.1.61 port=5432 sslmode=disable sslcompression=1'
# 启动从库
pg_ctl -D /usr/lib/data


#主库上验证
postgres=# \x
Expanded display is on.
postgres=# select * from pg_stat_replication;
-[ RECORD 1 ]----+------------------------------
pid              | 29210
usesysid         | 16386
usename          | repl
application_name | walreceiver
client_addr      | 192.168.1.162                                     ------>从备库连接上主库
client_hostname  | 
client_port      | 59590
backend_start    | 2018-11-15 17:13:54.269887+08
backend_xmin     | 
state            | streaming
sent_location    | 0/4032A78
write_location   | 0/4032A78
flush_location   | 0/4032A78
replay_location  | 0/4032A78
sync_priority    | 0
sync_state       | async

#启动服务
/usr/ppas-9.5/bin/edb-postgres -D /var/lib/ppas/9.5/data -p 5432
# 重新加载配置
su enterprisedb -c "pg_ctl -D /var/lib/ppas/9.5/data -p 5432 restart"


