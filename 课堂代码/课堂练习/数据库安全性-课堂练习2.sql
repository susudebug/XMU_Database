use test
select user

execute as user='U1'

/*用管理员收回U1权限*/
revert
select user

revoke select on student from U1/*会报错，因为此时U1还挂接着U2*/

revoke select on student from U1 cascade /*可使用cascade关键字强制撤销U1特权，同时U1给U2赋予的权限也会被清除*/

revert 
select user
/*测试U2权限*/
execute as user='U2'
select * from Student

revert 
select user
create role R1 /*不需要加引号*/

grant select on student to R1
exec sp_addrolemember 'R1','U1'/*将角色R1挂接给U1*/

create role R2
exec sp_addrolemember 'R1','R2'/*将R1挂接R2*/
exec sp_addrolemember 'R2','U2'/*将R2挂接给U2*/

drop role R2/*会报错，R2有多个成员，要解除后才可删除*/

exec sp_droprolemember 'R2','U2'
drop role R2 /*可成功删除*/

drop role R1 /*会报错，R1有对U1的挂接*/
exec sp_droprolemember 'R1','U1'
drop role R1 


revert
select user

select * from Student
/*Student表无主键，无约束，因此可以插入此条语句*/
insert into Student(sname,sage)values('姚晨',23)
delete from Student where sno is null
select * from Student


/*在SC中增加一个外键，这个外键是引用Student表中的sno。要求sno为另外一个表的主键才可*/
alter table SC
add foreign key (sno) references Student(sno)/*会报错,因为Student表中无主键*/


/*试图将Student中的sno改为主键。sno没有空值，但是任不能设置为主键*/
alter table Student
add primary key(sno)/*因为sno可能为空*/

alter table Student
alter column sno char(5) not null/*设置非空约束*/

alter table Student
add primary key(sno)/*现在可以设置为主键*/

alter table SC
add foreign key (sno) references Student(sno)/*将sno设置为主键后可正常运行*/

/*此时Student表主键为Sno，违反了主键的非空约束，无法正常执行*/
insert into Student(sname,sage)values('李涛',24)

/*查找Student表中的约束*/
exec sp_helpconstraint Student

update student set sno='95020' where sno='95001'/*会报错*/

update sc set sno='95020' where sno='95001'/*也会报错*/

/*撤销Student表中的约束*/
alter table Student drop constraint PK__Student__CA1FE4644AFEA49E/*要先将SC表的引用清除*/

/*查找Student表中的约束*/
exec sp_helpconstraint SC

alter table SC drop constraint FK__SC__Sno__778AC167
alter table Student drop constraint PK__Student__CA1FE4644AFEA49E/*	清除SC表对sno的引用关系后即可清除Student表中对sno的约束*/