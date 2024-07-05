USE test

SELECT *
FROM   Course

SELECT *
FROM   SC

SELECT *
FROM   Student

/*查询选修了"以数据库作为先行课"的课程的学生姓名和学号*/
/*第一种方法：使用多表连接*/
SELECT Student.Sname,
       Student.Sno
FROM   Course first,
       Course second,
       Student,
       SC
WHERE  first.Cpno = second.Cno
       AND SC.Sno = Student.Sno
       AND SC.Cno = first.Cno
       AND second.Cname = '数据库'
/*使用嵌套查询*/
SELECT Student.Sname,
       Student.Sno
FROM   SC,
       Student
WHERE  SC.Cno IN (SELECT first.Cno
                  FROM   Course first,
                         Course second
                  WHERE  first.Cpno = second.Cno
                         AND second.Cname = '数据库')
       AND Student.Sno = SC.Sno


/*使用EXISTS查询*/
SELECT Sname,
       Sno
FROM   Student
WHERE  EXISTS(SELECT *
              FROM   course x
              WHERE  EXISTS(SELECT *
                            FROM   course y
                            WHERE  x.Cpno = y.Cno
                                   AND y.Cname = '数据库')
                     AND EXISTS(SELECT *
                                FROM   SC
                                WHERE  x.Cno = SC.Cno and SC.Sno=Student.Sno)) 
