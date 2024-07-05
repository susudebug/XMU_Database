use test
select s1.Sname,s2.Sname
from Student s1,Student s2
where s1.Sname='Áõ³¿'or s2.Sname='Áõ³¿'

select Sno,avg(Grade)
from SC
where Sno in (
select Sno
from SC
where Cno='1'and Grade>85
)
group by Sno
having avg(Grade)>90

select Sno,Cno
from SC
where Grade>80


select Sno,Cno
from SC
where Grade>(
select avg(grade) from sc
)


select Sno,Cno
from SC
where Grade>(
select avg(grade) from sc 
where Sno='95001'
)

select Sno
from SC s1
where Grade >(
select avg(s2.Grade)
from SC s2
where s1.Sno=s2.Sno
)
