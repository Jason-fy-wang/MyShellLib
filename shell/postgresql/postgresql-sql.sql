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
-- 从文件中考入数据库
psql "host=10.163.119.68 port=5432 dbname=fcapsdb user=fcaps_fm password=fcaps_fm" -c "copy field_enum_value from  STDOUT with delimiter ','" < field.csv
-- 终端
\copy field_enum_value from '/root/field.csv' with DELIMITER ',';

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
alter table if exists engineering_suppression_rule rename column alarm_title to master_alarm_title;
-- 增加列
alter table if exists engineering_suppression_rule add cilumn match_alarm_title varchar(255);

insert into engineering_suppression_rule(rule_id,rule_name,rule_desc,slave_mvel,alarm_object_list,master_alarm_title,start_time,end_time,if_report_oss,update_time,match_alarm_title) values('123','engewin1','desc1','slavemven','{"title":"title"}','123','2020-10-26 00:00:00','2020-10-26 00:00:00', true,'2020-10-26 00:00:00', ,);

