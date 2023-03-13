create table accounts(id int,name varchar(20),balance int)
insert into accounts values(1,'first',100),(2,'second',100),(3,'third',100)
drop table accounts;
------------------------------------ Isolation levels -> Transaction 1 ----------------------------------------------------------
show transaction isolation level;
-- by Default in postgres its read commited (in Mysql its repeatable read)

--------------------------------------------- Read Uncommitted ------------------------------------
begin 
set transaction isolation level read uncommitted; -- Changing Transaction level 
show transaction isolation level; -->read uncommitted
select * from accounts
update accounts set balance=200 where id =1 --Value is updated(but only for this tranaction)
-- move to transaction 2
COMMIT
--  -> Dirty read is prevented here
--------------------------------------------- Read Committed ------------------------------------
begin 
set transaction isolation level read committed; -- Changing Transaction level 
show transaction isolation level;
select * from accounts
update accounts set balance=300 where id =1 --Value is updated(but only for this tranaction)
-- move to T2
commit;
--  -> Phantom read is prevented here
--------------------------------------------- Repeatable Read ------------------------------------
begin;
set transaction isolation level Repeatable Read; -- Changing Transaction level 
show transaction isolation level;
select * from accounts
update accounts set balance=balance-210 where id =1 --updated for T1
commit
--  -> Phantom read is prevented here
--------------------------------------------- what is serialization anomaly ------------------------------------
begin;
set transaction isolation level Repeatable Read;
show transaction isolation level;
select * from accounts
select sum(balance) from accounts; -- sum is 290.
insert into accounts values(4,'Sum',290);
select * from accounts -- sum 290 is inserted
-- go to T2
commit --> now go to t2 and commit it

--------------------------------------------- Serializable ------------------------------------
begin;
set transaction isolation level serializable;
show transaction isolation level;
select * from accounts
select sum(balance) from accounts; -- sum is 870.
insert into accounts values(4,'Sum',870);
select * from accounts  -->870 inserted.
---> go to T2
commit;