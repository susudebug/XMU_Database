
/*创建触发器，当更新student表中的学号时，
也同时更新sc表中的学号*/
create trigger selcou
on student
for insert
as if update(sno)--更新前的sno会放在deleted表中，更新后的sno会放在inserted表中
begin
update sc
set sc.sno=inserted.sno
from sc,inserted,deleted
where sc.sno=deleted.sno--若无where，会更新全部的值
end
--验证
update student set sno='95999' where sno='95001'
select *
from sc

/*创建一个触发器，当删除student表中的某条记录时
，也同时删除sc表中的记录*/

drop trigger selcou

create trigger T2
on student
for delete
as
delete sc
from sc,deleted
where sc.Sno=deleted.sno

--验证
delete from student where sno='95001' 
select * from sc


