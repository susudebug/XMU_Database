use test




insert into student(sname,sage) values('��С��',26)--ʧ�ܣ���Ϊsno��not null��check

--��Student���Լ����check not null��Լ��ȥ��
exec sp_helpconstraint Student
alter table student
alter column Sno char(5)

insert into student(sname,sage) values('��С��',26)
alter table student 
add check(sno is not null)--�ᱨ����Ϊ��ǰ����sno�Ѿ��п��ֶ�

alter table student 
with nocheck add check(sno is not null)--���ᱨ����ȥ�����ǰ�Ŀ��ֶ�

insert into student(sname,sage) values('����',28)--��ʱ��������sno��check�ǿ�Լ��

--ɾ����Լ��
exec sp_helpconstraint Student--���ҵ�ǰԼ��

alter  table student
drop constraint CK__Student__Sno__02084FDA

--�ᱨ����ǰstudent��course���ж�������
create table sc1(
sno char(5) foreign key references student(sno),
cno char(1) foreign key references course(cno),
grade int constraint C1 check(grade>0 and grade<100)--����Լ��
)

alter table student
add constraint C1 check(sno is not null)--����check�ǿ�Լ���ҽ����������ᱨ����Ϊ��ʱ������null

alter table student
with nocheck add constraint C1  check(sno is not null)--����check�ǿ�Լ���ҽ�������������with nocheck�ؼ��ֿ���������

--��֤Ч��
exec sp_helpconstraint student

alter table SC
add constraint FK1 foreign key(sno) references student(sno)--�ᱨ����ǰѧ����û��������
--��������Լ��
alter table Student
add constraint PK1 primary key(sno)--�޷���������,��sno���÷ǿ�Լ��������������˵��check�ǲ��еģ�ֻ�����������ſ�

alter table student
alter column sno char(5) not null--��ʧ�ܣ���Ϊ�пռ�¼

delete from student where sno is null

--��������Լ��
alter table Student
add constraint PK1 primary key(sno)

--��֤Ч��
exec sp_helpconstraint student

--�ɳɹ�������
alter table SC
add constraint FK1 foreign key(sno) references student(sno)

delete from Course where cno is null

alter table course
alter column cno char(1) not null


alter table course
add primary key (cno)

alter table SC
add constraint FK2 foreign key(cno) references course(cno)

--��ԭ����FK1ɾ�����������Լ��
alter table SC
add constraint FK1 foreign key(sno) references student(sno) on update cascade --cascada��������

exec sp_helpconstraint sc



alter table SC
drop constraint FK1

alter table SC
add constraint FK1 foreign key(sno) references student(sno) on update cascade on delete cascade

