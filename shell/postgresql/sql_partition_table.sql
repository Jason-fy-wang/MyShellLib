-- postgresql 三种分区表  RANGE | LIST | HASH 
--- 语法结构:
CREATE TABLE [ IF NOT EXISTS ] table_name(
        ...
    )
PARTITION BY { RANGE | LIST | HASH } ( { column_name | ( expression ) } [ COLLATE collation ] [ opclass ] [, ... ] )

CREATE TABLE [ IF NOT EXISTS ] table_name
    PARTITION OF parent_table (
        ....
    ) { FOR VALUES partition_bound_spec | DEFAULT }

partition_bound_spec: 
-- list分区
IN ( { numeric_literal | string_literal | TRUE | FALSE | NULL } [, ...] )
-- range分区
FROM ( { numeric_literal | string_literal | TRUE | FALSE | MINVALUE | MAXVALUE } [, ...] )
  TO ( { numeric_literal | string_literal | TRUE | FALSE | MINVALUE | MAXVALUE } [, ...] ) 
-- hash分区
WITH ( MODULUS numeric_literal, REMAINDER numeric_literal )
MODULUS: 表示hash分区的mod数, 
REMAINDER: 表示hash的余数

-- range 分区表
create table if not exists measurement(
    auto_id serial,
    city_id int not null,
    logdate timestamp not null,
    unitsales int,
    primary key(auto_id,logdate)            ---  
) PARTITION BY RANGE (logdate);
-- 默认分区表的创建,即当插入数据不属于已存在的分区表中时,插入到默认分区
create table measurement_default partition of measurement default;
create table measurement_y2018_12 partition of measurement
    for values from ('2018-12-01') to ('2019-01-01');
create table measurement_y2020_12 partition of measurement
    for values from ('2020-12-01') to ('2021-01-01');
create table measurement_y2020_11 partition of measurement
    for values from ('2020-11-01') to ('2020-12-01')
    with (parallel_workers=4)
    TABLESPACE fasttablespace;
insert into measurement(city_id, logdate,unitsales) values
(2,'2018-12-05 00:00:00',10),
(2,'2018-12-06 00:00:00',10),
(3,'2020-12-05 00:00:00',20),
(3,'2020-12-05 00:00:00',20),
(4,'2020-11-05 00:00:00',30),
(4,'2020-11-05 00:00:00',30);

insert into measurement(city_id, logdate,unitsales) values
(2,'2020-12-01 00:00:00',10);
-- 此会报错,可见range分区表示 [)区间,即是 左闭右开区间
(2,'2021-01-01 00:00:00',10);

-- 创建表
create table measurement_y2020_12_bak 
(like measurement_y2020_12 including  defaults including constraints);


update measurement set logdate='2020-12-10 00:00:00'  where auto_id=1;
delete from measurement where auto_id=1;

-- list分区表
create table if not exists measurement_list(
    auto_id serial,
    city_id int not null,
    logdate timestamp not null,
    unitsales int,
    primary key(auto_id,city_id)
) partition by list (city_id);

create table measurement_list_one partition of measurement_list
    for values in (1);
create table measurement_list_two partition of measurement_list
    for values in (2);

insert into measurement_list(city_id, logdate,unitsales) values
(1,'2018-12-05 00:00:00',10),
(2,'2020-12-05 00:00:00',20);

insert into measurement(city_id, logdate,unitsales) values 
(3,'2020-11-05 00:00:00',30);

-- hash 分区表

create table if not exists measurement_hash(
    auto_id serial,
    city_id int not null,
    logdate timestamp not null,
    unitsales int not null,
    primary key(auto_id,unitsales)
)partition by HASH (unitsales);

create table measurement_hash_m00 partition of  measurement_hash
    for values with(MODULUS 3, REMAINDER 0);
create table measurement_hash_m01 partition of  measurement_hash
    for values with(MODULUS 3, REMAINDER 1);
create table measurement_hash_m02 partition of  measurement_hash
    for values with(MODULUS 3, REMAINDER 2);

insert into measurement_hash(city_id, logdate,unitsales) values
(1,'2018-12-05 00:00:00',1),
(2,'2020-12-05 00:00:00',2),
(3,'2020-11-05 00:00:00',3);



