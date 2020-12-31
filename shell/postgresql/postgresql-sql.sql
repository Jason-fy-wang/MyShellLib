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

--查看所有运行中的参数值
show all;

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
-- 创建用户
create USER logical_user REPLICATION  LOGIN CONNECTION LIMIT 8 ENCRYPTED PASSWORD 'logical_user';
--- ~/.pgpass 文件
-- 192.168.28.74:5432:mydb:logical_user:password 
-- host:port:dbname:userName:userPassword

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
-- !~  是~的否定用法,表示不匹配正则表达式,且区分大小写
-- !~* 是~* 的否定用法,表示不匹配正则表达式,且不区分大小写
-- ~~  等效于 like
-- ~~* 等效于 ilike
-- !~~ 等效于 not like
-- !~~* 等效于not ilike

-- 匹配以 "张" 开头的字符串
select * from  table where name ~ '^张';
-- 匹配以 "小" 结尾的字符串
select *  from table where name ~ '小$';

-- 11 数据备份
-- 导出数据到 csv文件
-- 查找帮助:\h  copy
psql "host=$host port=$port user=$user password=$password dbname=$db" -c "COPY (select * from standard_alarm where collection_time >= '$i1' and collection_time < '$i' and alarm_status = 1) TO STDOUT WITH DELIMITER ',' CSV HEADER" >$path/sta.csv
-- 需要是管理员
copy (select * from tabName  where time_point_stamp>='2020-11-06 00:00:00' and time_point_stamp<='2020-11-08 00:00:00') TO '/mnt/ttt.csv' with delimiter ',' csv header;

-- 从文件中考入数据库
psql "host=10.163.119.68 port=5432 dbname=fcapsdb user=fcaps_fm password=fcaps_fm" -c "copy field_enum_value from  STDOUT with delimiter ',' csv header encoding 'UTF-8" < field.csv
-- 终端
\copy field_enum_value from '/root/field.csv' with DELIMITER ',' csv header encoding 'UTF-8';
\copy (select id,name,age from users) to '/mnt/tt.csv' with delimiter ',' encoding 'UTF-8' csv header;
\copy users(id,name,age) from '/mnt/tt.csv' with delimiter ',' encoding 'UTF-8' csv header;

-- 数据复制
insert into tablsa(age,name) select age,name from tablsb ;
-- 如果两个表的列完全一致
insert into tablsa select * from tablsb;
-- 增量复制
insert into tablsa select * from tablsb b where not exists (select * from tablsc a where a.name = b.name);
-- 整个表的复制
create table tmp_tablsa as select * from tablsa;

-- 12 修改表
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
-- 修改表明
alter table if exists tabName rename to newName;

-- 删除索引
drop index if exists IdxName;

-- 修改系统属性
alter system set wal_level = 'replica';  --修改系统配置参数
-- 查看系统配置
show wal_level;
show archive_command;

-- 13 常用的管理命令
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

insert into engineering_suppression_rule(rule_id,rule_name,rule_desc,slave_mvel,alarm_object_list,master_alarm_title,start_time,end_time,if_report_oss,update_time,match_alarm_title) values('123','engewin1','desc1','slavemven','{"title":"title"}','123','2020-10-26 00:00:00','2020-10-26 00:00:00', true,'2020-10-26 00:00:00', ,);

-- 14 联合主键查询
create table tt (id serial, name varchar(255), address varchar(255), primary key(id, name));

select * frmo tt where (id,name) in ((1,'zhangsan'),(2,'wagnwu'));

-- 备份表
insert into measurement_y2020_12_bak select * from  measurement_y2020_12;

--- 时间有效field
--- 发送命令查询表
psql "user=uname dbname=dbname host=ip port=5432  password=pass" -t -1  -c "\dt+ measurement*"
-- 查询时间的加减操作
psql "user=uname dbname=dbname host=ip port=5432  password=pass" -t -1  -c "select date '2020-12-14' + interval '1 month'"
-- 格式化时间
psql "user=uname dbname=dbname host=ip port=5432  password=pass" -t -1  -c "select to_char(timestamp'2020-12-14' + interval'1 month', 'YYYY-MM-DD HH24:MI:SS')"
microseconds
milliseconds
second
minute
hour
day
week
month
quarter
year
decade
century
millennium
--------- 时间格式化方式  to_char(时间, format)
HH	  一天中的小时 （01-12）
HH12	一天中的小时 （01-12）
HH24	一天中的小时 （00-23）
MI	  分钟 （00-59）minute (00-59)
SS	  秒（00-59）
MS	  毫秒（000-999）
US	  微秒（000000-999999）
SSSS	午夜后的秒（0-86399）
AM, am, PM or pm	            正午指示器（不带句号）
A.M., a.m., P.M. or p.m.	    正午指示器（带句号）
Y,YYY	带逗号的年（4 位或者更多位）
YYYY	年（4 位或者更多位）
YYY	  年的后三位
YY	  年的后两位
Y	    年的最后一位
IYYY	ISO 8601 周编号方式的年（4 位或更多位）
IYY	  ISO 8601 周编号方式的年的最后 3 位
IY	  ISO 8601 周编号方式的年的最后 2 位
I	    ISO 8601 周编号方式的年的最后一位
BC, bc, AD或者ad	        纪元指示器（不带句号）
B.C., b.c., A.D.或者a.d.	纪元指示器（带句号）
MONTH	全大写形式的月名（空格补齐到 9 字符）
Month	全首字母大写形式的月名（空格补齐到 9 字符）
month	全小写形式的月名（空格补齐到 9 字符）
MON	  简写的大写形式的月名（英文 3 字符，本地化长度可变）
Mon	  简写的首字母大写形式的月名（英文 3 字符，本地化长度可变）
mon	  简写的小写形式的月名（英文 3 字符，本地化长度可变）
MM	  月编号（01-12）
DAY	  全大写形式的日名（空格补齐到 9 字符）
Day	  全首字母大写形式的日名（空格补齐到 9 字符）
day	  全小写形式的日名（空格补齐到 9 字符）
DY	  简写的大写形式的日名（英语 3 字符，本地化长度可变）
Dy	  简写的首字母大写形式的日名（英语 3 字符，本地化长度可变）
dy	  简写的小写形式的日名（英语 3 字符，本地化长度可变）
DDD	  一年中的日（001-366）
IDDD	ISO 8601 周编号方式的年中的日（001-371，年的第 1 日时第一个 ISO 周的周一）
DD	  月中的日（01-31）
D	    周中的日，周日（1）到周六（7）
ID	  周中的 ISO 8601 日，周一（1）到周日（7）
W	    月中的周（1-5）（第一周从该月的第一天开始）
WW	  年中的周数（1-53）（第一周从该年的第一天开始）
IW	  ISO 8601 周编号方式的年中的周数（01 - 53；新的一年的第一个周四在第一周）
CC	  世纪（2 位数）（21 世纪开始于 2001-01-01）
J	    儒略日（从午夜 UTC 的公元前 4714 年 11 月 24 日开始的整数日数）
Q	    季度（to_date和to_timestamp会忽略）
RM	  大写形式的罗马计数法的月（I-XII；I 是 一月）
rm	  小写形式的罗马计数法的月（i-xii；i 是 一月）
TZ	  大写形式的时区缩写（仅在to_char中支持）
tz	  小写形式的时区缩写（仅在to_char中支持）
TZH	  时区的小时
TZM	  时区的分钟
OF	  从UTC开始的时区偏移（仅在to_char中支持）

---------------------------------------------- 函数 ----------------------------------------------
--------------------------- 查看文件大小的函数
-- 查询表的存储文件位置
select pg_relation_filepath('measurement_y2020_12');

-- 查看索引文件位置
select pg_relation_filepath(索引名字);
--查看索引大小
select pg_relation_size(索引名字);

-- 查看表大小
select pg_relation_size(TABLENAME);

select pg_total_relation_size(tabName); -- 查看表的总大小,包括索引
-- 查看数据库大小
select pg_database_size("DBNAME");
-- 大小转换为合适大小
select pg_size_pretty(pg_database_size(bdName));

-- 查看表空间大小
select pg_tablespace_size(tablespaceName);
-- 查看表空间
select spcname from pg_tablespace;
-- 序列函数
select generate_series(start,end,step);
select generate_series(1,10,1);
select generate_series('2020-12-21 00:00:00'::timestamp,'2020-12-22 00:00:00'::timestamp,'1 minute');
--------------------------- 查看复制的函数
-- wal xlog
/*
在pg9.x 叫做 xlog location
在pg10.x 叫做  wal  lsn
*/
----------- 9.5
-- 查看当前的xlog
select pg_current_xlog_location();
-- 查看xlog文件名
select pg_xlogfile_name(pg_current_xlog_location());
-- 查看xlog文件offset
select pg_xlogfile_name_offset(pg_current_xlog_location());
----------- 10 以后
-- 查看当前复制的wal
select pg_current_wal_lsn(); 
-- wal文件名
select pg_walfile_name(pg_current_wal_lsn());
-- wal文件offset
select pg_wal_file_name_offset(pg_current_wal_lsn());
-- 查看两个lsn之间的延迟
select pg_wal_lsn_diff(pg_current_wal_lsn(), write_lsn);
----------------- 查看主备的延迟
-- pg_current_wal_lsn() 函数显示流复制主库当前wal日志文件写入的位置
-- pg_wal_lsn_diff 函数计算两个wal日志位置之间的偏移量,返回单位为字节数
select pid, usename,client_addr,state,pg_wal_lsn_diff(pg_current_wal_lsn(), write_lsn) write_delay,
      pg_wal_lsn_diff(pg_current_wal_lsn(),flush_lsn) flush_delay, pg_wal_lsn_diff(pg_current_wal_lsn(),replay_lsn) replay_delay
      from pg_stat_replication();
-- pg_last_xact_replay_timestamp 函数显示备库最近wal日志应用时间
select EXTRACT(SECOND from now()-pg_last_xact_replay_timestamp());

---------- 显示备库最近接收的wal日志位置
select pg_last_wal_receive_lsn();
---------- 显示备库最近应用wal日志的位置
select pg_last_wal_replay_lsn();
---------- 显示备库备库最近事务的应用时间
select pg_last_xact_replay_timestamp();

--------- 判断是否是主库,返回t表示备库,f表示主库
select pg_is_in_recovery();

-- 制作备库的时的初始同步操作
pg_basebackup -D $PGDATA -Fp -Xs -v -P -h host -p 5432 -U repuser

-- 参数
-D,--pgdata: receive base backup into directory,即备份放到哪个目录
-F,--format=p|t: 输出格式(plain默认的, tar)
-X,--xlog : 备份时包括需要的wal文件
-v,--verbose
-P,--progress : 显示处理信息
-R,--write-recovery-conf: 复制时生成recovery.conf文件
-X,--xlog-method=fetch|stream: 获取需要的wal文件方式
--xlogdir: 指定xlog文件位置
-h: 主机
-p: 端口
-U: 用户

------ slot 操作
select * from pg_create_physical_replication_slot('node_a_slot');  --- 创建一个物理slot
select * from pg_create_logical_replication_slot('node_a_slot');  --- 创建一个逻辑 slot
select * from pg_replication_slots;   -- 查看创建的slot
-- 删除slot
select pg_drop_replication_slot('logical_slot1');

-- 重新加载
select pg_reload_conf();
--------------------------- cmd
pg_recvlogical -d postgres --slot logical_slot1 --start -f -
/*
  -d 指定数据库名称
  --slot 指定逻辑复制槽名称
  --start 表示通过--slot选项指定的逻辑槽来解析数据变化
  -f 将解析的数据变化写入指定文件
  - 表示输出到终端
*/

---- 使用参数的压测脚本  insert_t.sql 
\setrandom  v_id 1 1000000      -- http://www.postgres.cn/docs/9.5/pgbench.html
insert into t_perl(id,name) values(:v_id, :v_id||'a');
pgbench -c 8 -T 120 -d mydb -U pguser -nN -M prepared -f insert_t.sql > insert_t.out 2>&1 &
/*
-c 客户端连接数
-T 指定时间
-n do not run VACUUM before tests
-N skip updates of pgbench_tellers and pgbench_branches
-M 模式 --protocol=simple|extended|prepared
-f  指定要运行的脚本
*/
--- 更新的压缩脚本 update_t.sql
\setrandom  v_id 1 1000000
update t_perl2 set create_time=clock_timestamp() where id=:v_id;


------------------------------------ 事务
-- 查看当前事务id
select txid_current();
-- 查看默认事务隔离级别
select name,setting from pg_setting where name='default_transaction_isolation';
select current_setting('default_transaction_isolation');
-- 修改默认事务隔离级别
----- 修改配置文件中的 default_transaction_isolation 配置项
alter system set default_transaction_isolation TO 'REPEATABLE_READ';
-- 重新加载配置
select pg_reload_conf();
-- 查看当前会话的隔离级别
show transaction_isolation;
select current_setting('transaction_isolation');
-- 设置当前会话的隔离级别
set session characteristics as transaction isolation level read uncommitted;
-- 设置当前事务的隔离级别
start transaction isolation level read uncommitted;
begin isolation read uncommitted read write;
/*
postgresql为每一个事务分配一个递增的类型为int32的整型数作为唯一的事务ID,称为xid.

创建一个新的快照时,将收集当前正在执行的事务id和已提交的最大事务id.
Postgresql的内部数据结构中,每个元组(行记录)有4个与事务可见性相关的隐藏列,分别是
xmin,xmax,cmin,cmax,其中cmin,cmax分别是插入和删除该元组的命令在事务中命令序列号标识,
xmin,xmax与事务对其他事务可见性判断有关,用于同一个事务中的可见性判断. 可以通过sql直接查询到他们的值.
select xmin,xmax,cmin,cmax,id, ival from  tal_mvcc where id=1;
其中xmin保存了创建该行数据的事务的xid, xmax保存的是删除该行的xid. postgresql在不同事务
时间使用xmin和xmax控制事务对其他事务的可见性.

无论提交成功或回滚的事务,xid都会递增.

Repeatable read和serializable隔离级别的事务, 如果它的xid小于另外一个事务的xid,也就是元组的xmin
小于另外一个事务的xmin,那么另外一个事务对这个事务是不可见.

通过xmax值判断事务的更新操作和删除操作对其他事务的可见性有这几种情况:
1. 如果没有设置xmax值,该行对其他事务总是可见的
2. 如果它被设置为回滚事务的xid,该行对其他事务也是可见的
3. 如果它被设置为一个正在运行,没有commit和rollback的事务的xid,该行对其他事务是可见的
4. 如果它被设置为一个已提交的事务的xid,该行对在这个已提交事务之后发起的所有事务都是不可见的

利用 pageinspect 进行事务的查看.
创建扩展:
create extension pageinspect;
\dx+  pageinspect;

pageinspect 中的函数:
get_raw_page  get_raw_page(relname text, fork text, blkno int);
              get_raw_page(relname text, blkno int)
  用于读取relation中指定的块的值,其中relname是relation name,其中fork可以有main,vm,fsm,init这几个值.
  fork默认值是main,main表示数据文件的主文件
                  vm是可见性映射的块文件
                  fsm是free space map的块文件
                  init是初始化的块
  get_raw_page以一个byte值的形式返回一个拷贝.

heap_page_items 显示一个堆页面上所有的行指针. 对那些使用中的行指针,元组头部和元组原始数据也会被显示.不管元组
                对于拷贝原始页面时的MVCC是否可见,它们都会被显示.
一般使用get_raw_page函数获得堆页面映像作为参数传递给heap_page_items.

创建视图:
drop view if exists  v_pageinspect;
create view v_pageinspect as select '(0,' || lp || ')' as ctid,
    case lp_flags when 0 then 'Unused' when 1 then 'Normal' when 2 then 'Redirect to' || lp_off when 3 then 'Dead' END,
    t_xmin::int8 as xmin, t_xmax::int8 as xmax, t_ctid from heap_page_items(get_raw_page('ttt',0)) order by lp;

# 9.5 上创建
create view v_pageinspect as select '(0,'||lp||')' as ctid,case lp_flags when 0 then 'Unused' when 1 then 'Normal' when 2 then 'Redirect to' || lp_off when 3 then 'Dead' end, t_xmin as xmin, t_xmax as xmax, t_ctid from heap_page_items(get_raw_page('fcaps_fm.ttt',0));
*/


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