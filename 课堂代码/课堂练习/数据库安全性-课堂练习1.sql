
exec sp_addlogin 'L1','123456';/*在总安全性找到*/
exec sp_addlogin 'L2','123456' ;
exec sp_addlogin 'L3','123456' ;

/* 登录名只能进"大厅",想要进"房间"需要用用户名 */

exec sp_adduser 'L1','U1' /*默认在当前数据库中的安全性的用户中*/
exec sp_adduser 'L2','U2';
exec sp_adduser 'L3','U3';
exec sp_dropuser 'U1'/*删除U1*/

/*查看登录名*/
select SYSTEM_USER

/*查看当前用户*/
select user

exec as user='U1';/*执行后再查看登录名为L1，用户为U2*/
select * from Student/*U1没有任何权限*/

revert /*切换回管理员权限*/

select * from Student

/*授权select权限给U1（切换回管理员权限才可以授权）*/
exec as user='U1';
grant select on student to U1
select * from Student

update student set sage=21 where sno='95001'/*U1没有更新权限*/

revert/*切换回管理员权限才可以授权*/

grant update on student to U1

update student set sage=21 where sno='95001'

/*尝试以U1授权给U2*/
exec as user='U1';
grant select on Student to U2/*失败*/

revert/*切换回管理员权限给U1授予---转授予权限*/
grant select on Student to U1 with grant option 
/*拥有转授予权限后，U1对U2授权*/
exec as user='U1';
grant select on Student to U2


/*用管理员权限收回不会有效，因为之前是U1授权的。U1对其转授权的权限还在*/
/*用U1回收U2权限*/
exec as user='U1';
select user
revoke select on Student from U2

/*验证回收效果*/
exec as user='U2';
select * from Student