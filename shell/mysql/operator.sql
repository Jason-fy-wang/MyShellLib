-- 查看变量
-- 此处是查看是否自动提交
show variables like '%autocommit%';
-- 关闭自动提交
set autocommit=0;

-- 查看当前会话事务隔离级别
show variables like '%tx_iso%';
select @@tx_isolation;

-- 设置当前会话的隔离级别
-- 事务: read uncommmitted, read committed, repeatable read,serializable
set session transaction isolation level repeatable read;

-- 查看系统当前的隔离级别
select @@global.tx_isolation;

-- 设置系统当前的隔离级别
set global transaction isolation level repeatable read;


-----------------------------------分布式事务
-- 启动xid事务,xid必须是一个唯一标识;不支持[JOIN | RESUME]子句
XA {START | BEGIN} xid [JOIN | RESUME]
-- 结束xid事务; 不支持[SUSPEND [FOR MIGRATE]]子句
XA  END  xid [SUSPEND [FOR MIGRATE]]
-- xid 准备,预提交xid事务
XA  PREPARE xid
-- 提交xid事务
XA  COMMIT xid [ONE PHASE]
-- xid事务回滚
XA  ROLLBACK xid
-- 查看处于prepare阶段的所有事务
XA  RECOVER

--- 单击编程
XA START 'a';
INSERT INTO Z SELECT 11;
XA END 'a';
XA PREPARE 'a';
XA RECOVER ;
XA commit 'a';

-- mysql 检测是否开启分布式事务
show variables like 'innodb_support_xa';
--- 打开分布式事务
set  innodb_support_xa = on;



-- 查看表结构
show create table user;

-- 查看表字段
describe user;

-- 查看表的状态
show table status like 'user' \G;

-- 设置变量
---- 设置用户变量
set @t=1;
select @t; /* 查看变量*/

-- 设置全局变量
set global sort_buffer_size=10m;
set @@global.sort_buffer_size=10m;
-- 如果没有添加global关键字,那么默认是 session
set session sort_buffer_size=10m;
set @@session.sort_buffer_size=10m;

-- sql注释方式有三种:
1. # 字符至行尾
2. -- 到行尾. 注意: -- 注释风格要求第2个破折号的后面至少要跟一个空格符
3. /**/



-- 数值函数
1. 常见的操作符  + -  *  /
2. ABS(x)    : x的绝对值
3. ceil(x)  : 返回不小于x的最小整数值
4. floor(x) : 返回不小于x的最大整数值
5. crc32(x) : 计算循环冗余校验码值并返回一个32比特位无符号值
6. rand()  rand(x) :返回一个随机浮点数,返回在0-1节点.
7. sign(x)  : 返回x的符号
8. truncate(x,d): 返回被舍去至小数点后D位的数组x. 若D的值为0, 则结果不带有小数点或不带有小数部分
9. round(x), round(x,d): 返回参数x,其值接近于最近似的整数.在有两个参数的情况下,返回x,其值保留到小数点后D位.

-- 字符函数
1. char_length(str) : 返回值为字符串str的长度,长度单位为字符
2. length(str) : 返回值为字符串str的长度,单位为字节
3. concat(str1,str2....): 返回结果为连接参数产生的字符串.
4. left(str,len) : 从字符串str开始,返回最左边的len个字符.
5. right(str,len) : 从字符串str开始, 返回最右len个字符.
6. substring(str,pos), substring(str,pos,len): 不带有len参数的格式是从字符串str返回一个子字符串,起始于位置pos. 带有len参数的是从字符串str返回一个长度同len相同的子字符串,起始位置于pos.
7. lower(str): 返回字符串str转换为小写字母的字符.
8. upper(Str): 返回字符串str转换为大写字母

-- 日期函数
1. now() : 返回当前日期和时间的值,格式为YYYY-MM-DD HH:MM:SS  或者  YYYYMMDDHHMMSS
2. curtime():  将当前时间以 HH:MM:SS 或 HHMMSS 格式返回
3. curdate():  将当前日期以 YYYY-MM-DD 或YYYYMMDD 格式返回
4. datediff(expr1, expr2) :  是返回开始日期expr1 和 结束日期expr2之间相差的天数,计算中只用到这些值的日期部分. 返回值为正数或负数
5. date_add(date, INTERVAL expr type), date_sub(date, INTERVAL expr type): 这些函数执行日期运算.date是一个datatime或date值,用来指定时间. expr是一个表达式,用来指定从起始日志添加或减去的时间间隔值. type为关键字,他指示了表达式被解释的方式.  type常用: SECOND,MINUTE,HOUR,DAY,WEEK,MONTH,YEAR.
    select date_add('1997-12-31 23:59:59',interval 1 second);  
        ->  '1998-01-01 00:00:00'
    select date_add('1997-12-31 23:59:59', interval 1 DAY);
        -> '1998-01-01 23:59:59'
6. date_format(date, format): 根据format字符串格式安排date至的格式. 常用格式: YYYY-MM-DD HH:MM:SS, 对应的format: %Y-%m-%d%H:%i:%S.
7. str_to_date(str, format): 是date_format函数的倒转.



--- DDL
-- 1. 重命名表
alter table t1  rename to t2; -- 把表t1 重命名为  t2

-- 2. 把列a从integer类型转换为tinyint not null, 名称不变, 并把列 b 从char(10) 更改为 char(20),同时把列b重命名为列c
alter table t2 modify a tinyint not null, change b c char(20);

-- 3. 添加一个新列
alter table t2 add d timestamp;

-- 4. 在列d和列a中添加索引
alter table t2 add index(d), add index(a);

-- 5. 删除列c
alter table t2 drop column c;

-- 6. 添加一个新的 auto_increment 整数列,名称为c
alter table t2 add c int unsigned not null  auto_increment;

-------使用 create index创建索引
-- 7. 在表lookup的lieid上创建索引
create index id_index ON lookup(id);

-- 8. 在customer表的name列上创建一个索引, 索引使用name列的前10个字符
create index part_name on  customer (name(10));

-- 9.在tbl_name 表的a,b,c列上创建一个复合索引
create index idx_abc on  tbl_name(a,b,c);
------ 使用drop index删除索引
-- 10. 删除tbl_name上的index_name索引
drop index index_name on tbl_name;

------ 修改字符集和排序集合
-- 11. 更改排序字符集
alter table tt1 change v2 v2 varchar(10) character set utf8 collate utf8_general_ci;

alter table tabl_name change col_a col_a varchar(10) character set latin1 collate latin1_bin;

-- 12. 设置密码验证策略
set global validate_password_policy=0;
set global validate_password_length=6

-- 13 修改密码
alter user 'root'@'localhost' identified by 'admin@123';
set password for 'root'@'localhost'=password('123');
flush  privileges;


validate_password_length: 固定面的长度
validate_password_dictionary_file: 指定密码验证的文件路径
validate_password_mixed_case_count: 整个面中至少要包含大/小写字母的总数
validate_password_number_count:整个密码中至少要包含的阿拉伯数字的个数
validate_password_policy: 指定密码的强度验证等级,默认为medium,取值如下:
        0/low: 只验证长度
        1/medium: 验证长度,数字,大小写,特殊字符
        2/strong: 验证长度,数字,大小写,特殊字符,字典文件
validate_password_special_char_count:整个密码中至少要包含特殊字符的个数


-- 14 数据备份
-- 备份数据
select * from test.info into outfile '/mn/info.txt' fields terminated by '"' lines terminated "?";
load data infile '/mnt/info.txt' into table test.info fields terminated by "," optionally enclosed by '"' 
lines terminated by '?';

-- 备份数据库
mysqldump -hhost -uuser -ppassword databasename > backup.sql -- 

-- 带删除表的格式
mysqldump --add-drop-table -hhost -uuser -ppassword databasename > backup.sql

-- 压缩
mysqldump -hhost -uuser -ppassword databasename | gzip > backup.sql

-- 备份某些表
mysqldumo -hhost -uuser -ppassword databasename specific_table1 specific_table2 >backup.sql

-- 备份多个数据库
mysqldump -hhost -uuser -ppassword -databases databasename1 databasename2 databasename3 > backup.sql

-- 仅仅备份数据库结构
mysqldump -hhost -uuser -ppassword databasename --no-data 

-- 还原数据
mysql -hhost -uuser -ppassword databasename < backup.sql

-- 压缩还原
gunzip < backup.sql.gz | mysql -hhost -uuser -ppassword databasename

-- 15 配置
skip-grant-tables=1


-- 16 创建用户
create user 'zabbix'@'%' identified by 'zabbix';
grant all on zabbix.*  to  'zabbix'@'%' identified by 'zabbix';


