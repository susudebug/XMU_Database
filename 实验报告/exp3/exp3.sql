use School
--ʵ��3.1
/*(1)	ʹ��SQL�����STUDENTS���в���Ԫ�飨��ţ�12345678  ���֣�LiMing EMAIL: LM@gmail.com  �꼶��2002����
*/
insert into STUDENTS(sid,sname,email,grade)values('12345678','LiMing','LM@gmail.com',2002);
select * from STUDENTS

/*(2)	��ÿ���γ̣���ѧ����ѡ��������ѧ������߳ɼ������ѽ���������ݿ⡣ʹ��SELECT INTO ��INSERT INTO ���ַ���ʵ�֡�*/
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
(3) ��STUDENTS����ʹ��SQL��佫����ΪLiMing.��ѧ����EMAIL��ΪLM@qq.com��*/
update STUDENTS
set email='LM@qq.com'
where sname='LiMing'

select sname,email
from STUDENTS
where sname='LiMing'
/*
(4) ��TEACHERS����ʹ��SQL��佫���н�ʦ�Ĺ��ʷ�����*/
select tid,tname,salary
from TEACHERS;

update TEACHERS
set salary=salary*2;

select tid,tname,salary
from TEACHERS;

/*
(5) ������Ϊwaqcj��ѧ���Ŀγ�C++�ĳɼ���10�֡�*/

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
(6) ��STUDENTS����ʹ��SQL���ɾ������ΪLiMing��ѧ����Ϣ��*/
select * from STUDENTS
where sname='LiMing'

delete from STUDENTS
where sname='LiMing'

select * from STUDENTS
where sname='LiMing'
/*
(7) ɾ������ѡ�޿γ�C��ѡ�μ�¼��*/
select * from CHOICES
where cid in(select cid from COURSES where cname='C')

delete from CHOICES
where cid in(select cid from COURSES where cname='C')

select * from CHOICES
where cid in(select cid from COURSES where cname='C')
/*
(8) ��COURSES����ɾȥʱ��>80��Ԫ��Ĳ��������۸�ɾ���������ܵ���Լ����
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


--ʵ��3.2
/*
1. ����нˮ����3000�Ľ�ʦ����ͼt_view����Ҫ������޸ĺͲ������ʱ���豣֤����ͼֻ��нˮ����3000�Ľ�ʦ��Ϣ��
*/

create view t_view as 
select *
from TEACHERS
where salary>3000
with check option

select *
from t_view
where salary<=3000

insert into TEACHERS(tid,tname,email,salary)values('12346','����2','123@gmail.com',2000)

select *
from t_view
where salary<=3000





/*
2. ����ͼt_view�в�ѯ�ʼ���ַΪxibl@izd.edu�Ľ�ʦ�������Ϣ��*/
select *
from t_view
where email='xibl@izd.edu'
/*
3. ����ͼt_view�в���һ���µĽ�ʦ��¼�����н�ʦ���Ϊ199999998������Ϊabc���ʼ���ַΪabc@def.com��нˮΪ5000��
*/

insert into t_view(tid,tname,email,salary)values('199999998','abc','abc@def.com',5000)
select *
from t_view
where tid='199999998'
/*4. ����ͼt_view�н����Ϊ200010493�Ľ�ʦ��нˮ��Ϊ6000��*/
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
5. ɾ����ͼt_view��*/
drop view t_view

--ʵ��3.3
exec sp_addlogin 'L1','123456'

exec sp_adduser 'L1','U1'
--ʵ��3.4
/*ʹ�ò�ѯ��֤������������û����Ƿ���ж�ѧ�����SELECTȨ�ޡ�*/
exec as user='U1'

select user

select *
from STUDENTS
/*��School���ݿ�Ĳ���Ȩ�޸������ݿ��û�������*/
revert

select user

grant select on CHOICES to U1 
grant select on COURSES to U1 
grant select on STUDENTS to U1 
grant select on TEACHERS to U1 

select *
from STUDENTS
--ʵ��3.5

/*�½���ѯ���ù���Ա��ݵ�½���ݿ⡣
��choices���ϴ�����ͼch_view������ʾ�����ݣ�ѡ�ογ̺�Ϊ10005��*/
select user

create view ch_view as
select *
from CHOICES
where cid='10005'

select *
from ch_view

/*����ͼch_view�ϸ��û���������INSERT��Ȩ�ޡ�*/

revoke select on CHOICES from U1 

grant insert on ch_view to U1

exec as user='U1'

select user

revert 

exec as user='U1'
insert into ch_view(no,sid,tid,cid,score)values(999999,'12345','12345','12345',99)

/*����ͼch_view��score�е�Ȩ�޸����û�����*/
revert
select user


grant all privileges on ch_view(score) to U1

exec as user='U1'

/*���û�������½��ѯ����������ch_view���в�ѯ����*/
select SYSTEM_USER
select * from ch_view

/*���û�L1��½��ѯ������, ��noΪ500127998��ѧ���ĳɼ������޸ģ���Ϊ90�֡�*/
select no,score
from CHOICES
where no=500127998

update CHOICES
set score=90
where no=500127998

select no,score
from CHOICES
where no=500127998

/*�ջض��û�L1����ͼch_view��ѯȨ�޵���Ȩ*/
revert 
revoke select on ch_view from U1