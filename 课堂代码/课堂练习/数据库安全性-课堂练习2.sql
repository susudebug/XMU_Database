use test
select user

execute as user='U1'

/*�ù���Ա�ջ�U1Ȩ��*/
revert
select user

revoke select on student from U1/*�ᱨ����Ϊ��ʱU1���ҽ���U2*/

revoke select on student from U1 cascade /*��ʹ��cascade�ؼ���ǿ�Ƴ���U1��Ȩ��ͬʱU1��U2�����Ȩ��Ҳ�ᱻ���*/

revert 
select user
/*����U2Ȩ��*/
execute as user='U2'
select * from Student

revert 
select user
create role R1 /*����Ҫ������*/

grant select on student to R1
exec sp_addrolemember 'R1','U1'/*����ɫR1�ҽӸ�U1*/

create role R2
exec sp_addrolemember 'R1','R2'/*��R1�ҽ�R2*/
exec sp_addrolemember 'R2','U2'/*��R2�ҽӸ�U2*/

drop role R2/*�ᱨ��R2�ж����Ա��Ҫ�����ſ�ɾ��*/

exec sp_droprolemember 'R2','U2'
drop role R2 /*�ɳɹ�ɾ��*/

drop role R1 /*�ᱨ��R1�ж�U1�Ĺҽ�*/
exec sp_droprolemember 'R1','U1'
drop role R1 


revert
select user

select * from Student
/*Student������������Լ������˿��Բ���������*/
insert into Student(sname,sage)values('Ҧ��',23)
delete from Student where sno is null
select * from Student


/*��SC������һ�������������������Student���е�sno��Ҫ��snoΪ����һ����������ſ�*/
alter table SC
add foreign key (sno) references Student(sno)/*�ᱨ��,��ΪStudent����������*/


/*��ͼ��Student�е�sno��Ϊ������snoû�п�ֵ�������β�������Ϊ����*/
alter table Student
add primary key(sno)/*��Ϊsno����Ϊ��*/

alter table Student
alter column sno char(5) not null/*���÷ǿ�Լ��*/

alter table Student
add primary key(sno)/*���ڿ�������Ϊ����*/

alter table SC
add foreign key (sno) references Student(sno)/*��sno����Ϊ���������������*/

/*��ʱStudent������ΪSno��Υ���������ķǿ�Լ�����޷�����ִ��*/
insert into Student(sname,sage)values('����',24)

/*����Student���е�Լ��*/
exec sp_helpconstraint Student

update student set sno='95020' where sno='95001'/*�ᱨ��*/

update sc set sno='95020' where sno='95001'/*Ҳ�ᱨ��*/

/*����Student���е�Լ��*/
alter table Student drop constraint PK__Student__CA1FE4644AFEA49E/*Ҫ�Ƚ�SC����������*/

/*����Student���е�Լ��*/
exec sp_helpconstraint SC

alter table SC drop constraint FK__SC__Sno__778AC167
alter table Student drop constraint PK__Student__CA1FE4644AFEA49E/*	���SC���sno�����ù�ϵ�󼴿����Student���ж�sno��Լ��*/