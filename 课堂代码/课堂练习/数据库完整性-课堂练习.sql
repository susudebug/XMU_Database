use test




insert into student(sname,sage) values('王小二',26)--失败，因为sno有not null的check

--将Student表的约束和check not null的约束去除
exec sp_helpconstraint Student
alter table student
alter column Sno char(5)

insert into student(sname,sage) values('王小二',26)
alter table student 
add check(sno is not null)--会报错，因为当前表中sno已经有空字段

alter table student 
with nocheck add check(sno is not null)--不会报错，不去检查先前的空字段

insert into student(sname,sage) values('王四',28)--此时不允许，有sno的check非空约束

--删除该约束
exec sp_helpconstraint Student--查找当前约束

alter  table student
drop constraint CK__Student__Sno__02084FDA

--会报错，当前student、course表中都无主键
create table sc1(
sno char(5) foreign key references student(sno),
cno char(1) foreign key references course(cno),
grade int constraint C1 check(grade>0 and grade<100)--命名约束
)

alter table student
add constraint C1 check(sno is not null)--增加check非空约束且进行命名。会报错，因为此时表里有null

alter table student
with nocheck add constraint C1  check(sno is not null)--增加check非空约束且进行命名。增加with nocheck关键字可正常运行

--验证效果
exec sp_helpconstraint student

alter table SC
add constraint FK1 foreign key(sno) references student(sno)--会报错，当前学生表没有设主键
--增加主键约束
alter table Student
add constraint PK1 primary key(sno)--无法增加主键,将sno设置非空约束，对于主键来说，check是不行的，只有如下这条才可

alter table student
alter column sno char(5) not null--会失败，因为有空记录

delete from student where sno is null

--增加主键约束
alter table Student
add constraint PK1 primary key(sno)

--验证效果
exec sp_helpconstraint student

--可成功添加外键
alter table SC
add constraint FK1 foreign key(sno) references student(sno)

delete from Course where cno is null

alter table course
alter column cno char(1) not null


alter table course
add primary key (cno)

alter table SC
add constraint FK2 foreign key(cno) references course(cno)

--将原来的FK1删除后重新添加约束
alter table SC
add constraint FK1 foreign key(sno) references student(sno) on update cascade --cascada级联更新

exec sp_helpconstraint sc



alter table SC
drop constraint FK1

alter table SC
add constraint FK1 foreign key(sno) references student(sno) on update cascade on delete cascade

