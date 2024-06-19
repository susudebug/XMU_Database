/*实验2.2 空值和空集的处理
1）	要求
（1）	查询所有选课记录的成绩并将它换算为五分制（满分5分，合格3分），注意SCORE取NULL值的情况。*/
USE School

SELECT no,
       sid,
       tid,
       cid,
       score / 20 AS gpa
FROM   CHOICES
WHERE  score IS NOT NULL

/*
（2）	通过查询选修编号10028的课程的学生的人数，其中成绩合格的学生人数，不合格的学生人数，讨论NULL值的特殊含义。*/
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

/*错误写法：统计了10028课程中各个分数的人数*/
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
（3）	通过实验检验在使用ORDER BY进行排序时，取NULL的项是否出现在结果中？如果有，在什么位置？*/
/*将课程号为10028的成绩以降序排序*/
SELECT *
FROM   CHOICES
WHERE  cid = '10028'
ORDER  BY score DESC

/*
（4）	在上面的查询过程中如果加上保留字DISTINCT会有什么效果？*/
SELECT score
FROM   CHOICES
WHERE  cid = '10028'
ORDER  BY score DESC

SELECT DISTINCT score
FROM   CHOICES
WHERE  cid = '10028'
ORDER  BY score DESC

/*
（5）	通过实验说明使用分组GROUP BY对取值为NULL的项的处理。*/

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
（6）	结合分组，使用集合函数求每个同学的平均分、总的选课记录、最高成绩、最低成绩和总成绩。*/
/*集合函数：SUM、COUNT、MAX、MIN*/

/*不考虑NULL，集合函数不会将其一起运算*/
SELECT sid,
       Avg(score) AS avg_score,
       Count(*)   AS records_count,
       Max(score) AS max_score,
       Min(score) AS mini_score
FROM   CHOICES
GROUP  BY sid
/*考虑NULL值，将NULL替换为0*/
SELECT sid,
       Avg(isnull(score,0)) AS avg_score,
       Count(*)   AS records_count,
       Max(isnull(score,0)) AS max_score,
       Min(isnull(score,0)) AS mini_score
FROM   CHOICES
GROUP  BY sid
/*
（7）	查询成绩小于60的选课记录，统计总数、平均分、最大值和最小值。*/
select        
       Count(*)   AS fail_records_count,
	   Avg(score) AS avg_score,
       Max(score) AS max_score,
       Min(score) AS mini_score
from CHOICES
where score<60

/*
（8）	采用嵌套查询的方式，利用比较运算符和谓词ALL的结合来查询表COURSES中最少的课时。假设数据
库中只有一个记录的时候，使用前面的方法会得到什么结果，为什么？*/
select distinct hour
from COURSES
where hour<=all(select hour
from COURSES)
/*如果数据库中只有一个记录，那么子查询SELECT hour FROM COURSES将返回该记录的课时，并且它是
该表课时的最小值。因此，主查询中WHERE子句的条件 hour <= ALL(SELECT hour FROM COURSES)也
将成立，因此查询结果将为该记录的课时值。*/

/*
（9）	创建一个学生表S（NO， SID， SNAME），教师表T（NO， TID， TNAME）作为实验用的表。
其中NO分别是这两个表的主键，其他键允许为空。
向S插入元组（1， 0129871001， 王小明）、
（2， 0129871002， 李兰）、
（3， 0129871005， NULL）、
（4， 0129871004， 关红）；
向T插入元组1， 100189， 王小明）、
（2， 100180， 李小）、
（3， 100121， NULL）、
（4， 100128， NULL）。
对这两个表作对姓名的等值连接运算，找出既是老师又是学生的人员的学生编号和老师编号。 
*/
CREATE TABLE S(
NO INT PRIMARY KEY,
SID CHAR(10),
SNAME CHAR(10)
)
INSERT INTO S(NO,SID,SNAME)VALUES(1, '0129871001','王小明');
INSERT INTO S(NO,SID,SNAME)VALUES(2, '0129871002','李兰');
INSERT INTO S(NO,SID,SNAME)VALUES(3, '0129871005',NULL);
INSERT INTO S(NO,SID,SNAME)VALUES(4, '0129871004','关红');
CREATE TABLE T(
NO INT PRIMARY KEY,
TID CHAR(10),
TNAME CHAR(10)
)
INSERT INTO T(NO,TID,TNAME)VALUES(1, '100189','王小明');
INSERT INTO T(NO,TID,TNAME)VALUES(2, '100180','李小');
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

