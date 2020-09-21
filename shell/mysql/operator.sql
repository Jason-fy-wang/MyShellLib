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



---
-- 查看表结构
show create table user;

-- 查看表字段
describe user;
