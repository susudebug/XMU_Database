/*ʵ��2.2 ��ֵ�Ϳռ��Ĵ���
1��	Ҫ��
��1��	��ѯ����ѡ�μ�¼�ĳɼ�����������Ϊ����ƣ�����5�֣��ϸ�3�֣���ע��SCOREȡNULLֵ�������*/
USE School

SELECT no,
       sid,
       tid,
       cid,
       score / 20 AS gpa
FROM   CHOICES
WHERE  score IS NOT NULL

/*
��2��	ͨ����ѯѡ�ޱ��10028�Ŀγ̵�ѧ�������������гɼ��ϸ��ѧ�����������ϸ��ѧ������������NULLֵ�����⺬�塣*/
SELECT cid,
       Count(CASE
               WHEN score >= 60 THEN 1
             END) AS pass_count,
       Count(CASE
               WHEN score < 60 THEN 1
             END) AS fail_count
FROM   CHOICES
GROUP  BY cid
HAVING cid = '10028';

/*����д����ͳ����10028�γ��и�������������*/
SELECT score,
       Count(CASE
               WHEN score >= 60 THEN 1
             END) AS pass_count,
       Count(CASE
               WHEN score < 60 THEN 1
             END) AS fail_count
FROM   CHOICES
WHERE  cid = '10028'
GROUP  BY score

/*
��3��	ͨ��ʵ�������ʹ��ORDER BY��������ʱ��ȡNULL�����Ƿ�����ڽ���У�����У���ʲôλ�ã�*/
/*���γ̺�Ϊ10028�ĳɼ��Խ�������*/
SELECT *
FROM   CHOICES
WHERE  cid = '10028'
ORDER  BY score DESC

/*
��4��	������Ĳ�ѯ������������ϱ�����DISTINCT����ʲôЧ����*/
SELECT score
FROM   CHOICES
WHERE  cid = '10028'
ORDER  BY score DESC

SELECT DISTINCT score
FROM   CHOICES
WHERE  cid = '10028'
ORDER  BY score DESC

/*
��5��	ͨ��ʵ��˵��ʹ�÷���GROUP BY��ȡֵΪNULL����Ĵ���*/

SELECT score,
       Count(CASE
               WHEN score >= 60 THEN 1
             END) AS pass_count,
       Count(CASE
               WHEN score < 60 THEN 1
             END) AS fail_count,
       Count(CASE
               WHEN score IS NULL THEN 1
             END) AS null_count
FROM   CHOICES
WHERE  cid = '10028'
GROUP  BY score

/*
��6��	��Ϸ��飬ʹ�ü��Ϻ�����ÿ��ͬѧ��ƽ���֡��ܵ�ѡ�μ�¼����߳ɼ�����ͳɼ����ܳɼ���*/
/*���Ϻ�����SUM��COUNT��MAX��MIN*/

/*������NULL�����Ϻ������Ὣ��һ������*/
SELECT sid,
       Avg(score) AS avg_score,
       Count(*)   AS records_count,
       Max(score) AS max_score,
       Min(score) AS mini_score
FROM   CHOICES
GROUP  BY sid
/*����NULLֵ����NULL�滻Ϊ0*/
SELECT sid,
       Avg(isnull(score,0)) AS avg_score,
       Count(*)   AS records_count,
       Max(isnull(score,0)) AS max_score,
       Min(isnull(score,0)) AS mini_score
FROM   CHOICES
GROUP  BY sid
/*
��7��	��ѯ�ɼ�С��60��ѡ�μ�¼��ͳ��������ƽ���֡����ֵ����Сֵ��*/
select        
       Count(*)   AS fail_records_count,
	   Avg(score) AS avg_score,
       Max(score) AS max_score,
       Min(score) AS mini_score
from CHOICES
where score<60

/*
��8��	����Ƕ�ײ�ѯ�ķ�ʽ�����ñȽ��������ν��ALL�Ľ������ѯ��COURSES�����ٵĿ�ʱ����������
����ֻ��һ����¼��ʱ��ʹ��ǰ��ķ�����õ�ʲô�����Ϊʲô��*/
select distinct hour
from COURSES
where hour<=all(select hour
from COURSES)
/*������ݿ���ֻ��һ����¼����ô�Ӳ�ѯSELECT hour FROM COURSES�����ظü�¼�Ŀ�ʱ����������
�ñ��ʱ����Сֵ����ˣ�����ѯ��WHERE�Ӿ������ hour <= ALL(SELECT hour FROM COURSES)Ҳ
����������˲�ѯ�����Ϊ�ü�¼�Ŀ�ʱֵ��*/

/*
��9��	����һ��ѧ����S��NO�� SID�� SNAME������ʦ��T��NO�� TID�� TNAME����Ϊʵ���õı�
����NO�ֱ����������������������������Ϊ�ա�
��S����Ԫ�飨1�� 0129871001�� ��С������
��2�� 0129871002�� ��������
��3�� 0129871005�� NULL����
��4�� 0129871004�� �غ죩��
��T����Ԫ��1�� 100189�� ��С������
��2�� 100180�� ��С����
��3�� 100121�� NULL����
��4�� 100128�� NULL����
�������������������ĵ�ֵ�������㣬�ҳ�������ʦ����ѧ������Ա��ѧ����ź���ʦ��š� 
*/
CREATE TABLE S(
NO INT PRIMARY KEY,
SID CHAR(10),
SNAME CHAR(10)
)
INSERT INTO S(NO,SID,SNAME)VALUES(1, '0129871001','��С��');
INSERT INTO S(NO,SID,SNAME)VALUES(2, '0129871002','����');
INSERT INTO S(NO,SID,SNAME)VALUES(3, '0129871005',NULL);
INSERT INTO S(NO,SID,SNAME)VALUES(4, '0129871004','�غ�');
CREATE TABLE T(
NO INT PRIMARY KEY,
TID CHAR(10),
TNAME CHAR(10)
)
INSERT INTO T(NO,TID,TNAME)VALUES(1, '100189','��С��');
INSERT INTO T(NO,TID,TNAME)VALUES(2, '100180','��С');
INSERT INTO T(NO,TID,TNAME)VALUES(3, '100121',NULL);
INSERT INTO T(NO,TID,TNAME)VALUES(4, '100128',NULL);
select *
from S;
select * 
from T;

select SID,TID,SNAME
from S
join T on SNAME=TNAME 
where SNAME is not null and TNAME is not null;

