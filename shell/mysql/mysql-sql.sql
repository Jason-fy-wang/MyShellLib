-- 查看配置
    -- 查看全局配置 和 session配置
select @@global.sql_mode
select @@session.sql_mode

-- 设置配置
    -- 全局设置和  session 设置
set global sql_mode='strict_trans_tables';
set session sql_mode='strict_trans_tables';

-- 查看表的创建sql
show create table tabName;

-- 
set names;  -- 显示当前的字符集
set names utf8 collate utf8_bin; -- 设置字符集和比较方式

-- 修改表
alter table t modify column a varchar(10) collate utf8_bin;

-- 设置一个变量
select @a:='张三';
select @a, length(@a); -- 查看变量


