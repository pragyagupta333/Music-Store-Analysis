---------------------------- Common Table Expression -----------------------
-- Also called as CTE, Sub Query Factoring, Queries using WITH clause
create table employee( 
	emp_id varchar(10),
	emp_name varchar(20),
	salary integer
);

insert into employee values(101,'Rahul',15000),
(102,'Manoj',15000),(103,'James',55000),
(104,'Michael',25000),(105,'Ali',20000),
(106,'Robin',35000);

select * from employee

-- Employees who earn more than avg salary of all employee
select * 
from employee 
where salary > (select avg(salary) from employee)
----- CTE Method ------------------ 
with avg_salary (avg_sal) as   -- avg_sal is the column in avg_salary table ,u need to mention the column u need as output
	(select avg(salary) from employee)
select * 
from employee e, avg_salary av -- avg_salary = a temp table(present only till executionof this query) ,av = alias of this table
where e.salary > av.avg_sal;

with alias_tb (col returned by this alias_tb) as
	( alias_tb query),
	alias_tb2(col returned by this alias_tb2) as
	(alias_tb2 query from alias_tb1)
select 
from alias_tb
join alias_tb2
on ....