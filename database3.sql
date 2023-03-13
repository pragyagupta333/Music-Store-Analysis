----------------------------- Copy a database --------------------
create database sampleTest
with template posttutdb;

create database sourcedb;

----------------------- Database Object Sizes --------------
select pg_size_pretty (pg_database_size ('PostTutDb'));
select pg_size_pretty (pg_indexes_size('actor'));
select pg_size_pretty ( pg_tablespace_size ('pg_default') );
select pg_column_size(5::bigint);

------------------------------ Managing Schema --------------------------
select current_schema();
show search_path;
create schema schematest;
set search_path to schematest, public;
create table demo ( id int,age int);
create role pragya login password '123';
create schema authorization pragya
alter schema schematest rename to schemaDemo
alter schema schemaDemo owner to postgres
drop schema s

create role roletest
select rolname from pg_roles
create role roledemo createdb login password '123' connection limit 100 valid until '2022-03-15'
alter role roletest rename to testRole;
drop role testrole
select usename from pg_catalog.pg_user