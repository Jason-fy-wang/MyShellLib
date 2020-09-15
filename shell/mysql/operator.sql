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



