
/*������������������student���е�ѧ��ʱ��
Ҳͬʱ����sc���е�ѧ��*/
create trigger selcou
on student
for insert
as if update(sno)--����ǰ��sno�����deleted���У����º��sno�����inserted����
begin
update sc
set sc.sno=inserted.sno
from sc,inserted,deleted
where sc.sno=deleted.sno--����where�������ȫ����ֵ
end
--��֤
update student set sno='95999' where sno='95001'
select *
from sc

/*����һ������������ɾ��student���е�ĳ����¼ʱ
��Ҳͬʱɾ��sc���еļ�¼*/

drop trigger selcou

create trigger T2
on student
for delete
as
delete sc
from sc,deleted
where sc.Sno=deleted.sno

--��֤
delete from student where sno='95001' 
select * from sc


