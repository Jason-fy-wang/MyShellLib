-- 1. 查看所有数据库
\list
select * from pg_database;
-- 2. 连接数据库 
\c  databasename;
\c - user;      --  切换用户
-- 3. list tables
\db

-- 4. 查找帮助
\?
\h create schema   -- 查看创建schema的帮助

fcapsdb=# \h create schema;
命令：       CREATE SCHEMA
描述：       建立新的架构模式
语法：
CREATE SCHEMA 模式名称 [ AUTHORIZATION role_specification ] [ 模式中对象 [ ... ] ]
CREATE SCHEMA AUTHORIZATION role_specification [ 模式中对象 [ ... ] ]
CREATE SCHEMA IF NOT EXISTS 模式名称 [ AUTHORIZATION role_specification ]
CREATE SCHEMA IF NOT EXISTS AUTHORIZATION role_specification

这里role_specification可以是：

    用户名
  | CURRENT_USER
  | SESSION_USER

-- 5. 创建schema
create  schema schemaname;
\dn    --  查看所有schema
drop schema [if exists] schemaname;

-- 查看当前schema
select current_schema;

-- 查看search_path
show search_path;

-- 修改schema的所属用户
alter schema schname owner to username;
-- 设置schema表空间
mkdir -p /data/pg_sql/tbs_space;
create tablespace tbs_space owner schname localtion '/data/pg_sql/tbs_space';

-- 创建数据库并制定所有者
create database dbname with owner username encoding UTF8 template template1 tablespace tbs_space;

-- 6. 创建用户
create user fcafm;
create user fm with password '123456';
create schema fm_db authorization 'fm';
alter user fm set search_path='fm';

-- 修改用户密码
alter user fcafm password '123456';
-- 修改用户权限
alter user fcafm createrole createdb replication login;

-- 修改search_path
alter user fcafm set search_path='fm','$user';

-- 7. 数据备份
pg_dump -h 10.163.119.68 -p 5432 -U user --schema=ff --table=tbl -d dbname > bak.sql
pg_restore -h 10.163.119.68 -p 5432 -U user --schema=ff   --table=tbl -d dbname < bak.sql

-- 8 jsonb 查询
-- 从slarm中查找ala_tent(jsonb字段)包含{"pFlag":"Yes"}内容的 Flag字段的值
select ala_tent->'Flag' from slarm where ala_tent @> '{"pFlag":"Yes"}'


-- 9. 模糊查找
-- like,not like 用于模糊查询,其中%表示任意个字符, _ 表示单个任意字符,如果需要在模糊查询中查询这两个通配符,需要使用
-- ESCAPE 进行转义
select * from tabname where name like 'zh/_%' ESCAPE '/';

-- postgresql 中特殊的操作符:ilike, not ilike: 
-- ilike: 表示在模糊匹配字符时不区分大小写, i 即 ignore
-- not ilike: 表示不模糊匹配字符串 且 不区分大小写

-- 10 正则查找
-- ~   ~*  以及   !~ !~*
-- ~  表示匹配正则表达式,且区分大小写
-- ~* 表示匹配正则表达式,且不区分大小写
-- !~  是·的否定用法,表示不匹配正则表达式,且区分大小写
-- !~* 是~* 的否定用法,表示不匹配正则表达式,且不区分大小写
-- ~~  等效于 like
-- ~~* 等效于 ilike
-- !~~ 等效于 not like
-- !~~* 等效于not ilike

-- 匹配以 "张" 开头的字符串
select * from  table where name ~ '^张';
-- 匹配以 "小" 结尾的字符串
select *  from table where name ~ '小$';
-- 导出数据到 csv文件
-- 查找帮助:\h  copy
psql "host=$host port=$port user=$user password=$password dbname=$db" -c "COPY (select * from standard_alarm where collection_time >= '$i1' and collection_time < '$i' and alarm_status = 1) TO STDOUT WITH DELIMITER ',' CSV HEADER" >$path/sta.csv
-- 需要是管理员
copy (select * from tabName  where time_point_stamp>='2020-11-06 00:00:00' and time_point_stamp<='2020-11-08 00:00:00') TO '/mnt/ttt.csv' delimiter ',' csv header;

-- 从文件中考入数据库
psql "host=10.163.119.68 port=5432 dbname=fcapsdb user=fcaps_fm password=fcaps_fm" -c "copy field_enum_value from  STDOUT with delimiter ',' csv header encoding 'UTF-8" < field.csv
-- 终端
\copy field_enum_value from '/root/field.csv' with DELIMITER ',' csv header encoding 'UTF-8';

-- 数据复制
insert into tablsa(age,name) select age,name from tablsb ;
-- 如果两个表的列完全一致
insert into tablsa select * from tablsb;
-- 增量复制
insert into tablsa select * from tablsb b where not exists (select * from tablsc a where a.name = b.name);
-- 整个表的复制
create table tmp_tablsa as select * from tablsa;

-- 11 修改表
-- 修改列名
alter table if exists tabName rename column old_columnName to new_Name;
-- 增加列
alter table if exists tableName add column columnName varchar(255);
alter table if exists tableNaname add column colName varchar(255) default '';
-- 修改列
alter table if exists tabName alter column columnName TYPE newType;
-- 修改字段的默认值
alter table if exists tabName alter column columnName SET DEFAULT '';
-- 删除主键
alter table if exists tableName drop constraint constraint_name if exists ;
-- 添加主键
alter table if exists tabnleName add primary key(id);
-- 修改约束名字
alter table if exists rename constraint constraint_name to new_constraint_name;
-- 修改表的属主
alter table if exists owner to userName;
-- 删除索引
drop index if exists IdxName;


-- 12 常用的管理命令
-- 查看版本
select version();
-- 查看数据库启动时间
select pg_postmaster_start_time();
-- 查看最后load配置时间
select pg_conf_load_time();
-- 显示当前时区
show  timezone;
-- 查看当前实例中有哪些数据库
psql -l  或者 \l
-- 查看当前用户名
select user;
select current_user;
-- 查看session用户; session_user始终是原始用户,user是当前的角色用户
select session_user;
-- 查看当前session所在客户端的ip地址和端口
select inet_client_addr(), inet_client_port();
-- 查询当前数据库服务器的ip地址及端口
select inet_server_addr(), inet_server_port();
-- 查看当前session的后台服务器进程的PID
select pg_backend_pid();
-- 查看当前参数的配置情况
show shared_buffers;
select current_setting('shared_buffered');
-- 修改当前session的参数配置
set maintenance_work_mem to '128MB';
select set_config('maintenance_work_mem','128MB');
-- 查看当前正在写的wal文件
select pg_xlogfile_name(pg_currrent_xlog_location());
-- 查看当前wal文件的buffer中还有多少字节的数据没有写入到磁盘中
select pg_xlog_location_diff(pg_current_xlog_insert_location(),pg_current_xlog_location());
-- 查看数据库实例是否正在做基础备份
select pg_is_in_backup(), pg_backup_start_time();
-- 查看当前数据库实例处于hot standby状态还是正常数据库状态
select pg_is_in_recovery();  -- 输出为true,则处于hot standby状态
-- 查看数据库的大小
select pg_database_size('osdba'), pg_size_pretty(pg_database_size('osdba'));
-- 查看表的大小
select pg_size_pretty(pg_relation_size('ipdba'));
select pg_size_pretty(pg_total_relation_size('ipdba'));
pg_relation_size()仅仅计算表的大小,不包括索引大小;而pg_total_relation_size()则会把索引的大小也计算进来
-- 查看表上的所有索引的大小
---- pg_indexes_size()函数的参数名是一个表对应的OID,输入表名会自动转换成表OID,而不是索引名称
select pg_size_pretty(pg_indexes_size('ipdba'));
-- -查看表空间大小
select pg_size_pretty(pg_tablespace_size('pg_global'));
select pg_size_pretty(pg_tablespace_size('pg_degault'));
-- 查看表对应的数据文件
select pg_relation_filepath('test01');
-- 重新加载
pg_ctl reload;
select pg_reload_conf();
-- 切换日志文件到下一个
select pg_rotate_logfile();
-- 切花wal文件
select pg_switch_xlog();
-- 手动产生一次checkpoint
checkpoint;  -- sql 终端执行命令
-- 取消正在长时间执行的sql命令
select pg_cancel_backend(pid);
select pg_terminate_backend(pid);
---- 两个函数区别：pg_cancel_backend(pid)函数实际上是给正在执行的sql任务设置一个取消标志,正在执行的任务在合适的时候检测到此标志后会主动退出,但如果没有主动检测到此标志就无法正常退出
---- pg_terminage_backend() 终止一个后台服务进程,同时释放后台服务进程的资源
-- 查看后台运行的sql进程
select pid,username,query_stat,query from pg_stat_activity;
-- 数据库的存储目录
$PGDATA/base/oid
-- 查看数据库的OID
select oid,dataname from pg_database;
-- 每张表或索引都会分配一个relfilenode,数据文件则以"<relfilenode>[.顺序号]"命名,每个文件最大为1G,当表或者索引的内容大于1G时,就会从1开始生产顺序号,所以一张表的数据文件路径:
<默认表空间的目录>/<database oid>/<relfilenode>[.顺序号]
-- 查看一张表的 relfilenode
select relnamespace,relname,relfilenode from pg_class where relname='test01';
-- 查看Catalog version
pg_controldata | grep 'Catalog version number'
-- 表空间创建
create tablespace tbs01 location '/home/osdba/tbs01';
-- 此时就会在/home/osdba/tbs01 目录下生成一个子目录:PG_12_201909212
-- 此目录PG_12_201909212中的12代表大版本, 而201909212就是Catalog version.
-- 在PG_12_201909212这个目录下还会生成一些子目录,这些子目录就是 数据库的oid.
-- 所对于用户创建的表空间,表和索引存储数据文件的目录名:
<表空间根目录>/<Catalog version 目录>/<database oid>/<relfilenode>[.顺序号]




--- 商业版本的postgresql
systemctl status efm-2.1
systemctl status ppas-9.5
-- 主从切换
efm promote efm -switchover
-- 查看复制状态
select * from pg_stat_replication;

--- edb 运维命令
--#  添加node 到集群中
efm allow-node  <cluster-name>  ip_addrOfNewNode

-- 把一个node从集群中移除
efm disallow-node <cluster_name> <ip_address>


-- 切换master 
efm promote
efm promote <cluster_name> [-switchover] [-sourcenode <addredd>] [-quiet] [-noscripts]

-- e.f.: efm promote clusterName -switchover
-- 重新监控之前停止的数据库
efm resume <cluster_name>
-- # 设置standby node的优先级
efm set-priority
efm set-priority <cluster_name>  <ip_address> <priority>
-- ef: efm set-priority clusterName ipOfNode(要设置优先级的npde的ip)

-- 此是停止failover manager,不会影响正在运行的数据库
efm stop-cluster <cluster_name>

-- 
efm upgrade-conf <cluster_name> [-source <directory>]

-- 查看集群状态
efm cluster-status <cluster_name>
-- 生成json格式的集群状态信息
efm cluster-status-json <cluster_name>