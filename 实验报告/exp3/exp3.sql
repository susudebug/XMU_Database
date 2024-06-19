use School
--实验3.1
/*(1)	使用SQL语句向STUDENTS表中插入元组（编号：12345678  名字：LiMing EMAIL: LM@gmail.com  年级：2002）。
*/
insert into STUDENTS(sid,sname,email,grade)values('12345678','LiMing','LM@gmail.com',2002);
select * from STUDENTS

/*(2)	对每个课程，求学生的选课人数和学生的最高成绩，并把结果存入数据库。使用SELECT INTO 和INSERT INTO 两种方法实现。*/
drop table temp
select count(distinct sid) as count_students,max(score) as max_score,cid
into temp
from CHOICES
group by cid
select *
from temp


create table temp2(
count_students int,
max_score int,
cid int
);
insert into temp2(count_students,max_score,cid)
select count(distinct sid) as count_students,max(score) as max_score,cid
from CHOICES
group by cid

select * from temp2
/*
(3) 在STUDENTS表中使用SQL语句将姓名为LiMing.的学生的EMAIL改为LM@qq.com。*/
update STUDENTS
set email='LM@qq.com'
where sname='LiMing'

select sname,email
from STUDENTS
where sname='LiMing'
/*
(4) 在TEACHERS表中使用SQL语句将所有教师的工资翻倍。*/
select tid,tname,salary
from TEACHERS;

update TEACHERS
set salary=salary*2;

select tid,tname,salary
from TEACHERS;

/*
(5) 将姓名为waqcj的学生的课程C++的成绩加10分。*/

select sname,score,cname
from CHOICES,STUDENTS,COURSES
WHERE CHOICES.sid IN (SELECT sid FROM STUDENTS WHERE sname = 'waqcj')
AND CHOICES.cid IN (SELECT cid FROM COURSES WHERE cname = 'C++')and CHOICES.cid=COURSES.cid
and CHOICES.sid=STUDENTS.sid


UPDATE CHOICES
SET score = score + 10
WHERE sid IN (SELECT sid FROM STUDENTS WHERE sname = 'waqcj')
AND cid IN (SELECT cid FROM COURSES WHERE cname = 'C++');

select sname,score,cname
from CHOICES,STUDENTS,COURSES
WHERE CHOICES.sid IN (SELECT sid FROM STUDENTS WHERE sname = 'waqcj')
AND CHOICES.cid IN (SELECT cid FROM COURSES WHERE cname = 'C++')and CHOICES.cid=COURSES.cid
and CHOICES.sid=STUDENTS.sid
/*
(6) 在STUDENTS表中使用SQL语句删除姓名为LiMing的学生信息。*/
select * from STUDENTS
where sname='LiMing'

delete from STUDENTS
where sname='LiMing'

select * from STUDENTS
where sname='LiMing'
/*
(7) 删除所有选修课程C的选课记录。*/
select * from CHOICES
where cid in(select cid from COURSES where cname='C')

delete from CHOICES
where cid in(select cid from COURSES where cname='C')

select * from CHOICES
where cid in(select cid from COURSES where cname='C')
/*
(8) 对COURSES表做删去时间>80的元组的操作，讨论该删除操作所受到的约束。
*/
select * from COURSES
where hour>80

delete from COURSES
where hour>80

select * from COURSES
where hour>80

exec sp_helpconstraint temp

alter table temp
add constraint FK3 foreign key(cid) references COURSES(cid)

select *
from temp 
where not exists(
select *
from COURSES
where temp.cid=COURSES.cid
)


--实验3.2
/*
1. 建立薪水大于3000的教师的视图t_view，并要求进行修改和插入操作时仍需保证该视图只有薪水大于3000的教师信息。
*/

create view t_view as 
select *
from TEACHERS
where salary>3000
with check option

select *
from t_view
where salary<=3000

insert into TEACHERS(tid,tname,email,salary)values('12346','测试2','123@gmail.com',2000)

select *
from t_view
where salary<=3000





/*
2. 在视图t_view中查询邮件地址为xibl@izd.edu的教师的相关信息。*/
select *
from t_view
where email='xibl@izd.edu'
/*
3. 向视图t_view中插入一个新的教师记录，其中教师编号为199999998，姓名为abc，邮件地址为abc@def.com，薪水为5000。
*/

insert into t_view(tid,tname,email,salary)values('199999998','abc','abc@def.com',5000)
select *
from t_view
where tid='199999998'
/*4. 在视图t_view中将编号为200010493的教师的薪水改为6000。*/
select *
from t_view
where tid='200010493'
update t_view
set salary=6000
where tid='200010493'
select *
from t_view
where tid='200010493'
/*
5. 删除视图t_view。*/
drop view t_view

--实验3.3
exec sp_addlogin 'L1','123456'

exec sp_adduser 'L1','U1'
--实验3.4
/*使用查询验证“张三”这个用户名是否具有对学生表的SELECT权限。*/
exec as user='U1'

select user

select *
from STUDENTS
/*将School数据库的操作权限赋予数据库用户张三。*/
revert

select user

grant select on CHOICES to U1 
grant select on COURSES to U1 
grant select on STUDENTS to U1 
grant select on TEACHERS to U1 

select *
from STUDENTS
--实验3.5

/*新建查询，用管理员身份登陆数据库。
在choices表上创建视图ch_view，并显示其内容（选课课程号为10005）*/
select user

create view ch_view as
select *
from CHOICES
where cid='10005'

select *
from ch_view

/*在视图ch_view上给用户张三赋予INSERT的权限。*/

revoke select on CHOICES from U1 

grant insert on ch_view to U1

exec as user='U1'

select user

revert 

exec as user='U1'
insert into ch_view(no,sid,tid,cid,score)values(999999,'12345','12345','12345',99)

/*将视图ch_view上score列的权限赋予用户张三*/
revert
select user


grant all privileges on ch_view(score) to U1

exec as user='U1'

/*以用户张三登陆查询分析器，对ch_view进行查询操作*/
select SYSTEM_USER
select * from ch_view

/*以用户L1登陆查询分析器, 对no为500127998的学生的成绩进行修改，改为90分。*/
select no,score
from CHOICES
where no=500127998

update CHOICES
set score=90
where no=500127998

select no,score
from CHOICES
where no=500127998

/*收回对用户L1对视图ch_view查询权限的授权*/
revert 
revoke select on ch_view from U1