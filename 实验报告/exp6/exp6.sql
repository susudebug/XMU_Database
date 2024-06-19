--(1) 用T-SQL语言完成1+2+3……+100，并使用@@ERROE判断是否执行成功，
--如果成功则输出值，否则打印执行失败。
DECLARE @sum INT;
DECLARE @error INT;
DECLARE @i INT;

SET @sum=0;
SET @i=1;

WHILE @i <= 100
  BEGIN
      SET @sum=@sum + @i;
      SET @i=@i + 1;
  END

SET @error=@@ERROR;

IF @error = 0
  BEGIN
      PRINT '计算成功，结果为:' + Cast(@sum AS VARCHAR); --将int类型转化为char类型
  END
ELSE
  BEGIN
      PRINT '执行失败';
  END

--更新STUDENTS表中sid为80000759500的学生的email为ddff@sina.com，
--并通过@@ROWCOUNT判断是否有数据被更新，如果没有则打印警告。
-- 更新 STUDENTS 表中的 email
UPDATE STUDENTS
SET    email = 'ddff@sina.com'
WHERE  sid = '80000759500';

-- 检查更新的行数
IF @@ROWCOUNT = 0
  BEGIN
      PRINT '警告: 没有记录被更新';
  END
ELSE
  BEGIN
      PRINT '更新成功';
  END;

--3.使用`IF…ELSE…`语句，查询STUDENTS表中学号为800007595的学生，
--如果学生存在，则输出学生的各科成绩，否则打印查无此人。
USE School;

go

IF EXISTS(SELECT 1
          FROM   students
          WHERE  sid = '800007595')
  BEGIN
      SELECT *
      FROM   CHOICES
      WHERE  sid = '800007595';
  END
ELSE
  BEGIN
      PRINT '查无此人';
  END

--5
INSERT INTO CHOICES
            (no,
             sid,
             cid,
             score)
VALUES      (11133,
             '800007595',
             '10042',
             90);

-- ('800007595', '10042', 72),
-- ('800007595', '10042', 33);
USE School;

go

SELECT *
FROM   CHOICES
WHERE  sid = '800007595'
       AND cid = '10042';

DECLARE @Score INT;

-- 查询学号为800007595，课程号为10042的成绩
SELECT @Score = score
FROM   CHOICES
WHERE  sid = '800007595'
       AND cid = '10042';

-- 使用 CASE 语句根据成绩范围输出结果
DECLARE @Result VARCHAR(20);

SET @Result = CASE
                WHEN @Score >= 80 THEN '优秀'
                WHEN @Score >= 60
                     AND @Score < 80 THEN '及格'
                ELSE '不及格'
              END;

-- 打印结果
PRINT '成绩评定：' + @Result;

DELETE FROM CHOICES
WHERE  sid = '800007595'
       AND cid = '10042';

--6
DROP PROCEDURE UpdateStudentScore

CREATE PROCEDURE Updatestudentscore @sid           CHAR(10),
                                    @ResultMessage NVARCHAR(50) output
AS
  BEGIN
      BEGIN TRANSACTION

      DECLARE @Count INT

      SELECT @Count = Count(*)
      FROM   CHOICES
      WHERE  sid = @sid

      --若查找不到
      IF @Count = 0
        BEGIN
            SET @ResultMessage='查无此人'

            ROLLBACK TRANSACTION--回滚状态

            RETURN
        END

      --更新成绩
      UPDATE CHOICES
      SET    score = CASE
                       WHEN score < 60 THEN 60
                       WHEN score > 80 THEN 80
                       ELSE score
                     END
      WHERE  sid = @sid

      -- 检查更新是否成功
      IF @@ROWCOUNT = 0
        BEGIN
            -- 更新失败
            SET @ResultMessage = '更改失败'

            ROLLBACK TRANSACTION
        END
      ELSE
        BEGIN
            -- 更新成功
            SET @ResultMessage = '更改成功'

            COMMIT TRANSACTION
        END
  END

SELECT *
FROM   CHOICES

DECLARE @ResultMessage NVARCHAR(50);

-- 执行存储过程
EXEC Updatestudentscore
  @sid = '12345      ',
  @ResultMessage = @ResultMessage OUTPUT;

-- 输出结果信息
SELECT @ResultMessage AS ResultMessage; 


--7.

select UPPER(email) as UppercaseEmail,SUBSTRING(cname,1,3) as CourseNamePrefix
from STUDENTS as S,COURSES as C,CHOICES as CH
where S.sid = '800007595' and CH.sid=S.sid and CH.cid=C.cid


--8

--创建标量值函数：根据输入的学生学号参数，返回学生的选课的平均成绩
CREATE FUNCTION dbo.GetAverageScore
(
    @sid CHAR(10)
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @AverageScore FLOAT;

    SELECT @AverageScore = AVG(score)
    FROM CHOICES
    WHERE sid = @Sid;

    RETURN @AverageScore;
END;

SELECT dbo.GetAverageScore('800007595') AS AverageScore;

--创建内联表值函数：根据学生真实姓名显示其所有选修课程名和成绩
CREATE FUNCTION dbo.GetStudentCoursesAndScores
(
    @StudentName NVARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        C.cname, 
        Ch.Score
    FROM 
        Students S
    JOIN 
        Choices Ch ON S.sid = Ch.sid
    JOIN 
        Courses C ON Ch.cid = C.cid
    WHERE 
        S.sname = @StudentName
);

SELECT * FROM dbo.GetStudentCoursesAndScores('xcikvufj                      ');

--创建多语句表值函数：根据课程名称查询所有选修这些课程的学生姓名和分数
CREATE FUNCTION dbo.GetStudentsByCourse
(
    @CourseName NVARCHAR(100)
)
RETURNS @tb_scores TABLE
(
    StudentName NVARCHAR(50),
    Score INT
)
AS
BEGIN
    INSERT INTO @tb_scores
    SELECT 
        S.sname, 
        Ch.Score
    FROM 
        Courses C
    JOIN 
        Choices Ch ON C.cid = Ch.cid
    JOIN 
        Students S ON Ch.sid = S.sid
    WHERE 
        C.cname = @CourseName;

    RETURN;
END;

SELECT C.cname, COUNT(CH.sid) AS EnrollmentCount
FROM COURSES AS C
JOIN CHOICES AS CH ON C.cid = CH.cid
GROUP BY C.cname;


SELECT * FROM dbo.GetStudentsByCourse('algorithm                     ');

--9.定义一个游标，将学号为800007595的学生的选修课程名和成绩逐行打印出来。

--挑出选课最多的学生
SELECT TOP 1 Ch.sid,COUNT(*) as COURSECOUNT
FROM Courses AS C
JOIN Choices AS Ch ON C.cid = Ch.cid
GROUP BY Ch.sid
ORDER BY COUNT(*) DESC;


DECLARE @CourseName NVARCHAR(100), @Score INT;

-- 定义游标
DECLARE course_cursor CURSOR FOR
SELECT C.cname, Ch.Score
FROM Courses AS C
JOIN Choices AS Ch ON C.cid = Ch.cid
WHERE Ch.sid = '859761946 ';

-- 打开游标
OPEN course_cursor;

-- 获取第一行数据
FETCH NEXT FROM course_cursor INTO @CourseName, @Score;

-- 遍历游标中的每一行
WHILE @@FETCH_STATUS = 0
BEGIN
    -- 打印课程名和成绩
    PRINT 'Course Name: ' + @CourseName + ', Score: ' + CAST(@Score AS NVARCHAR(10));

    -- 获取下一行数据
    FETCH NEXT FROM course_cursor INTO @CourseName, @Score;
END;

-- 关闭游标
CLOSE course_cursor;

-- 释放游标资源
DEALLOCATE course_cursor;

SELECT C.cname, Ch.Score
FROM Courses AS C
JOIN Choices AS Ch ON C.cid = Ch.cid
WHERE Ch.sid = '859761946 ';

--定义一个游标，将学号为800007595的学生的第二门选修课程成绩（成绩降序排列）改为75分。

DECLARE @CourseID INT, @Score INT;
DECLARE @Counter INT = 0;

-- 定义游标
DECLARE second_course_cursor CURSOR FOR
SELECT cid, Score
FROM Choices
WHERE sid = '859761946 '
ORDER BY Score DESC;

-- 打开游标
OPEN second_course_cursor;

-- 获取第一行数据
FETCH NEXT FROM second_course_cursor INTO @CourseID, @Score;

-- 遍历游标中的每一行
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Counter = @Counter + 1;

    -- 如果是第二行数据
    IF @Counter = 2
    BEGIN
        -- 更新成绩为75分
        UPDATE Choices
        SET Score = 75
        WHERE sid = '859761946 ' AND cid = @CourseID;
        BREAK;
    END;

    -- 获取下一行数据
    FETCH NEXT FROM second_course_cursor INTO @CourseID, @Score;
END;

-- 关闭游标
CLOSE second_course_cursor;

-- 释放游标资源
DEALLOCATE second_course_cursor;

SELECT C.cname, Ch.Score
FROM Courses AS C
JOIN Choices AS Ch ON C.cid = Ch.cid
WHERE Ch.sid = '859761946 ';
--创建一个没有唯一索引的表，定义一个游标，删除其中一条记录，查看是否允许删除。

CREATE TABLE TestTable (
    ID INT,
    Value NVARCHAR(50)
);

-- 插入一些数据
INSERT INTO TestTable (ID, Value) VALUES (1, 'Value1');
INSERT INTO TestTable (ID, Value) VALUES (2, 'Value2');
INSERT INTO TestTable (ID, Value) VALUES (3, 'Value3');

DECLARE @ID INT, @Value NVARCHAR(50);

-- 定义游标
DECLARE delete_cursor CURSOR FOR
SELECT ID, Value
FROM TestTable;

-- 打开游标
OPEN delete_cursor;

-- 获取第一行数据
FETCH NEXT FROM delete_cursor INTO @ID, @Value;

-- 删除当前游标指向的记录
DELETE FROM TestTable
WHERE CURRENT OF delete_cursor;

-- 查看是否允许删除
IF @@ROWCOUNT = 1
BEGIN
    PRINT 'Record deleted successfully';
END
ELSE
BEGIN
    PRINT 'Failed to delete record';
END;

-- 关闭游标
CLOSE delete_cursor;

-- 释放游标资源
DEALLOCATE delete_cursor;

-- 查看表中的数据
SELECT * FROM TestTable;



