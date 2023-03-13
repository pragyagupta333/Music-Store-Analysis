------------------------------------ Isolation levels -> Transaction 2 ----------------------------------------------------------
show transaction isolation level; -- -> read committed by default
--------------------------------------------- Read Uncommitted ------------------------------------
begin
set transaction isolation level read uncommitted;
show transaction isolation level;  --> read uncommitted
select * from accounts where id=1;
-- after update in transaction 1 without commit
select * from accounts where id=1; --(this has not read an uncommited value)
-- According to postgres Documentation, READ UNCOMMITTED behaves same as READ COMMITTED.
-- After commit
select * from accounts where id=1;
commit;

--------------------------------------------- Read Committed ------------------------------------
begin
set transaction isolation level read committed;
show transaction isolation level;
select * from accounts where id=1;
-- after update,no commit in T1
select * from accounts where id=1; -- not updated
-- after commit
select * from accounts where id=1; -- updated,Hence read committed
commit
--  -> Phantom read is prevented here
--------------------------------------------- Repeatable Read ------------------------------------
begin;
set transaction isolation level Repeatable Read;
show transaction isolation level;
select * from accounts where id=1
select * from accounts where balance >=100
-- after update, commit
select * from accounts where balance >=100 -- after commit this should give newly updated result, but due to use of repeatable read it must keep givivg previous reault
-- gave previous results
--  -> Phantom read is prevented here
update accounts set balance=balance-10 where id =1 -- T1 value =90(after commit) ,T2 value =300 ->idealy this query should output 80(as in mysql) or give an error and not make updates
-- ERROR:  could not serialize access due to concurrent update. this is nice as it avoids confusing state like subtracting 10 from 300 gives 80.
commit
--------------------------------------------- what is serialization anomaly ------------------------------------
begin;
set transaction isolation level Repeatable Read;
show transaction isolation level;
select * from accounts -- no sum is inserted(due to no commit yet),table is in intial state as it should be
select sum(balance) from accounts; -- sum is 290.
insert into accounts values(4,'Sum',290);
select * from accounts -- sum 290 is inserted
-- go to t1 and commit it.
-- now commit t2
commit ---> now this commit shows insertion of 290 twice(one due to T1,other due to T2) which should'nt happen as second sum should be 290+290=580
-- this is problem called serialization anomaly
---> solved in serializable.

--------------------------------------------- Serializable ------------------------------------
begin;
set transaction isolation level serializable;
show transaction isolation level;
select * from accounts
select sum(balance) from accounts; -- sum is 870.
insert into accounts values(4,'Sum',870);
select * from accounts
----> commit T1
commit; --> will show error,which is nice as it wont allow insertion of wrong data as seen in serialization anomaly
/*ERROR:  could not serialize access due to read/write dependencies among transactions
DETAIL:  Reason code: Canceled on identification as a pivot, during commit attempt.
HINT:  The transaction might succeed if retried. */
select * from accounts
--> only one 870 insertion will be present.