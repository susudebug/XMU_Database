
exec sp_addlogin 'L1','123456';/*���ܰ�ȫ���ҵ�*/
exec sp_addlogin 'L2','123456' ;
exec sp_addlogin 'L3','123456' ;

/* ��¼��ֻ�ܽ�"����",��Ҫ��"����"��Ҫ���û��� */

exec sp_adduser 'L1','U1' /*Ĭ���ڵ�ǰ���ݿ��еİ�ȫ�Ե��û���*/
exec sp_adduser 'L2','U2';
exec sp_adduser 'L3','U3';
exec sp_dropuser 'U1'/*ɾ��U1*/

/*�鿴��¼��*/
select SYSTEM_USER

/*�鿴��ǰ�û�*/
select user

exec as user='U1';/*ִ�к��ٲ鿴��¼��ΪL1���û�ΪU2*/
select * from Student/*U1û���κ�Ȩ��*/

revert /*�л��ع���ԱȨ��*/

select * from Student

/*��ȨselectȨ�޸�U1���л��ع���ԱȨ�޲ſ�����Ȩ��*/
exec as user='U1';
grant select on student to U1
select * from Student

update student set sage=21 where sno='95001'/*U1û�и���Ȩ��*/

revert/*�л��ع���ԱȨ�޲ſ�����Ȩ*/

grant update on student to U1

update student set sage=21 where sno='95001'

/*������U1��Ȩ��U2*/
exec as user='U1';
grant select on Student to U2/*ʧ��*/

revert/*�л��ع���ԱȨ�޸�U1����---ת����Ȩ��*/
grant select on Student to U1 with grant option 
/*ӵ��ת����Ȩ�޺�U1��U2��Ȩ*/
exec as user='U1';
grant select on Student to U2


/*�ù���ԱȨ���ջز�����Ч����Ϊ֮ǰ��U1��Ȩ�ġ�U1����ת��Ȩ��Ȩ�޻���*/
/*��U1����U2Ȩ��*/
exec as user='U1';
select user
revoke select on Student from U2

/*��֤����Ч��*/
exec as user='U2';
select * from Student