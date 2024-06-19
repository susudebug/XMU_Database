/*实验2.1 数据查询
1）	要求
以School数据库为例，在该数据库中存在四张表格，分别为：
	表STUDENT(sid, sname, email, grade);
	表TEACHERS(tid, tname, email, salary);
	表COURSES(cid, cname, hour);
	表CHOICES(no, sid, tid, cid, score)
在数据库中，存在这样的关系：学生可以选择课程，一个课程对应一个教师。在表CHOICES中保存学生的选课记录。
按以下要求对数据库进行查询操作：
*/
USE School

/*
(1)	查询年级为2001的所有学生的名称并按编号升序排列。
*/
SELECT sname,
       sid
FROM   STUDENTS
WHERE  grade = 2001
ORDER  BY sid ASC;

/*
(2)	查询学生的选课成绩合格的课程成绩，并把成绩换算为积点（60分对应积点为1，每增加1分，积点增加0.1）。
*/
/*Step1：将SCORE改为浮点型*/
ALTER TABLE CHOICES
  ALTER COLUMN SCORE FLOAT;

/*Step2：新建一个名为GPA，类型为浮点型的属性*/
ALTER TABLE CHOICES
  ADD GPA FLOAT;

/*Step3：将成绩换算为绩点*/
UPDATE CHOICES
SET    GPA = CASE
               WHEN score >= 60 THEN ( score - 50 ) / 10
               ELSE 0
             END

/*Step4：输出结果*/
SELECT sname,
       CHOICES.sid,
       cid,
       score,
       GPA
FROM   CHOICES,
       STUDENTS
WHERE  score >= 60
       AND CHOICES.sid = STUDENTS.sid

/*Step5：复原*/
ALTER TABLE CHOICES
  DROP COLUMN GPA

ALTER TABLE CHOICES
  ALTER COLUMN SCORE INT

/*
(3)	查询课时是48或64的课程的名称。*/
SELECT cname
FROM   COURSES
WHERE  hour = 48
        OR hour = 64;


/*
(4)	查询所有课程名称中含有data的课程编号。*/
/*不可用=替代LIKE*/
SELECT cname,
       cid
FROM   COURSES
WHERE  cname LIKE '%data%';

/*
(5)	查询所有选课记录的课程号（不重复显示）。*/
SELECT DISTINCT cid
FROM   CHOICES

/*
(6)	统计所有教师的平均工资。*/
SELECT Avg(salary) AS avg_salary
FROM   TEACHERS

/*
(7)	查询所有教师的编号及选修其课程的学生的平均成绩，按平均成绩降序排列。*/
SELECT tid,
       Avg(score) AS avg_score
FROM   CHOICES
GROUP  BY tid
ORDER  BY avg_score DESC

/*
(8)	统计各个课程的选课人数和平均成绩。*/
/*sid需要剔除重复选课的人*/
SELECT cid,
       Count(DISTINCT sid) AS count_sid,
       Avg(score)          AS avg_score
FROM   CHOICES
GROUP  BY CID

/*
(9)	查询至少选修了三门课程的学生编号。*/
SELECT sid,
       Count(CID) AS count_cid
FROM   CHOICES
GROUP  BY SID
HAVING Count(CID) >= 3;

/*
(10)	查询编号800009026的学生所选的全部课程的课程名和成绩。*/
/*使用score is not null筛除含null值的行*/
/*错误的写法*/
SELECT DISTINCT cname,
                sid,
                score
FROM   COURSES,
       CHOICES
WHERE  sid = '800009026'
       AND score IS NOT NULL

/*正确的写法*/
SELECT DISTINCT cname,
                sid,
                score
FROM   CHOICES
       INNER JOIN COURSES
               ON COURSES.cid = CHOICES.cid
WHERE  sid = '800009026'
       AND score IS NOT NULL;

/*
(11)	查询所有选修了database的学生的编号。*/
/*错误写法  -9w条*/
SELECT DISTINCT sid
FROM   COURSES,
       CHOICES
WHERE  cname = 'database'

/*正确写法  -5757条*/
SELECT DISTINCT sid
FROM   CHOICES
       INNER JOIN COURSES
               ON COURSES.cid = CHOICES.cid
WHERE  cname = 'database'

/*
(12)	求出选择了同一个课程的学生数。*/
/*注意如果同一个学生选了两遍同一门课，只算一次*/
SELECT cid,
       Count(DISTINCT sid) AS count_sid
FROM   CHOICES
GROUP  BY cid

/*
(13)	求出至少被两名学生选修的课程编号。*/
SELECT cid
FROM   CHOICES
GROUP  BY CID
HAVING Count(sid) >= 2;

/*
(14)	查询选修了编号80009026的学生所选的某个课程的学生编号。*/
SELECT sid
FROM   CHOICES
WHERE  cid IN (SELECT cid
               FROM   CHOICES
               WHERE  sid = '80009026');

/*
(15)	查询学生的基本信息及选修课程编号和成绩。*/
SELECT DISTINCT CHOICES.sid,
                sname,
                email,
                grade,
                cid,
                score
FROM   CHOICES
       INNER JOIN STUDENTS
               ON CHOICES.sid = STUDENTS.sid

/*
(16)	查询学号850955252的学生的姓名和选修的课程名及成绩。*/
SELECT sname,
       cname,
       score
FROM   CHOICES,
       STUDENTS,
       COURSES
WHERE  CHOICES.sid = '850955252'
       AND STUDENTS.sid = CHOICES.sid
       AND COURSES.cid = CHOICES.cid;

/*找到选修课程最多的人的学号*/
SELECT TOP (1) CHOICES.sid,
               Count(*) AS count_sid
FROM   CHOICES
       INNER JOIN STUDENTS
               ON CHOICES.sid = STUDENTS.sid
       INNER JOIN COURSES
               ON CHOICES.cid = COURSES.cid
GROUP  BY CHOICES.sid
ORDER  BY count_sid DESC

/*查询该学生*/
SELECT sname,
       cname,
       score
FROM   CHOICES,
       STUDENTS,
       COURSES
WHERE  CHOICES.sid = '887150338'
       AND STUDENTS.sid = CHOICES.sid
       AND COURSES.cid = CHOICES.cid;

/*
(17)	查询与学号850955252的学生同年纪的所有学生资料。*/
SELECT *
FROM   STUDENTS
WHERE  grade = (SELECT grade
                FROM   STUDENTS
                WHERE  sid = '850955252')

/*(18)	查询所有有选课的学生的详细信息。*/
SELECT *
FROM   STUDENTS
WHERE  sid IN(SELECT DISTINCT sid
              FROM   CHOICES)

SELECT *
FROM   STUDENTS
WHERE  EXISTS(SELECT *
              FROM   CHOICES
              WHERE  CHOICES.sid = STUDENTS.sid)

/*
(19)	查询没有学生选的课程的编号。*/
SELECT cid
FROM   COURSES
WHERE  NOT EXISTS(SELECT *
                  FROM   CHOICES
                  WHERE  COURSES.cid = CHOICES.cid)

SELECT cid
FROM   COURSES
WHERE  cid NOT IN(SELECT DISTINCT cid
                  FROM   CHOICES)

/*
(20)	查询选修了课程名为C++的课时一样课程的学生名称。*/
SELECT sname
FROM   STUDENTS
WHERE  sid IN (SELECT sid
               FROM   CHOICES
               WHERE  CHOICES.sid = STUDENTS.sid /*选修了课程*/
                      AND CHOICES.cid IN(SELECT cid
                                         FROM   COURSES x
                                         WHERE  hour = (SELECT hour
                                                        FROM   COURSES y
                                                        WHERE  x.hour = y.hour /*这个课程的课时与C++一样*/
                                                               AND y.cname = 'C++')))

/*
(21)	找出选修课程成绩最好的选课记录。*/
SELECT TOP(1) *
FROM   CHOICES
ORDER  BY score DESC

/*
(22)	找出和课程UML或课程C++的课时一样课程名称。*/
SELECT *
FROM   COURSES x
WHERE  hour = (SELECT hour
               FROM   COURSES y
               WHERE  x.hour = y.hour /*这个课程的课时与C++一样*/
                      AND ( y.cname = 'C++'
                             OR y.cname = 'UML' ))

/*
(23)	查询所有选修编号10001的课程的学生的姓名。*/
SELECT sname
FROM   STUDENTS
WHERE  sid IN(SELECT DISTINCT sid
              FROM   CHOICES
              WHERE  cid = '10001');

/*
(24)	查询选修了所有课程的学生姓名。*/
/*没有一门课学生没有选*/
SELECT sname
FROM   STUDENTS
WHERE  NOT EXISTS(SELECT *
                  FROM   COURSES
                  WHERE  NOT EXISTS(SELECT *
                                    FROM   CHOICES
                                    WHERE  COURSES.cid = CHOICES.cid
                                           AND CHOICES.sid = STUDENTS.sid))

/*
(25)	利用集合运算，查询选修课程C++或选修课程Java的学生的编号。*/
/*求并集*/
SELECT sid
FROM   CHOICES
WHERE  cid IN(SELECT cid
              FROM   COURSES
              WHERE  cname = 'C++')
UNION
SELECT sid
FROM   CHOICES
WHERE  cid IN(SELECT cid
              FROM   COURSES
              WHERE  cname = 'Java')
/*
(26)	实现集合交运算，查询既选修课程C++又选修课程Java的学生的编号。*/
SELECT sid
FROM   CHOICES
WHERE  cid IN(SELECT cid
              FROM   COURSES
              WHERE  cname = 'C++')
intersect 
SELECT sid
FROM   CHOICES
WHERE  cid IN(SELECT cid
              FROM   COURSES
              WHERE  cname = 'Java')
/*
(27)	实现集合减运算，查询选修课程C++而没有选修课程Java的学生的编号。
*/
SELECT sid
FROM   CHOICES
WHERE  cid IN(SELECT cid
              FROM   COURSES
              WHERE  cname = 'C++')
except 
SELECT sid
FROM   CHOICES
WHERE  cid IN(SELECT cid
              FROM   COURSES
              WHERE  cname = 'Java')
