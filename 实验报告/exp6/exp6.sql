--(1) ��T-SQL�������1+2+3����+100����ʹ��@@ERROE�ж��Ƿ�ִ�гɹ���
--����ɹ������ֵ�������ӡִ��ʧ�ܡ�
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
      PRINT '����ɹ������Ϊ:' + Cast(@sum AS VARCHAR); --��int����ת��Ϊchar����
  END
ELSE
  BEGIN
      PRINT 'ִ��ʧ��';
  END

--����STUDENTS����sidΪ80000759500��ѧ����emailΪddff@sina.com��
--��ͨ��@@ROWCOUNT�ж��Ƿ������ݱ����£����û�����ӡ���档
-- ���� STUDENTS ���е� email
UPDATE STUDENTS
SET    email = 'ddff@sina.com'
WHERE  sid = '80000759500';

-- �����µ�����
IF @@ROWCOUNT = 0
  BEGIN
      PRINT '����: û�м�¼������';
  END
ELSE
  BEGIN
      PRINT '���³ɹ�';
  END;

--3.ʹ��`IF��ELSE��`��䣬��ѯSTUDENTS����ѧ��Ϊ800007595��ѧ����
--���ѧ�����ڣ������ѧ���ĸ��Ƴɼ��������ӡ���޴��ˡ�
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
      PRINT '���޴���';
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

-- ��ѯѧ��Ϊ800007595���γ̺�Ϊ10042�ĳɼ�
SELECT @Score = score
FROM   CHOICES
WHERE  sid = '800007595'
       AND cid = '10042';

-- ʹ�� CASE �����ݳɼ���Χ������
DECLARE @Result VARCHAR(20);

SET @Result = CASE
                WHEN @Score >= 80 THEN '����'
                WHEN @Score >= 60
                     AND @Score < 80 THEN '����'
                ELSE '������'
              END;

-- ��ӡ���
PRINT '�ɼ�������' + @Result;

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

      --�����Ҳ���
      IF @Count = 0
        BEGIN
            SET @ResultMessage='���޴���'

            ROLLBACK TRANSACTION--�ع�״̬

            RETURN
        END

      --���³ɼ�
      UPDATE CHOICES
      SET    score = CASE
                       WHEN score < 60 THEN 60
                       WHEN score > 80 THEN 80
                       ELSE score
                     END
      WHERE  sid = @sid

      -- �������Ƿ�ɹ�
      IF @@ROWCOUNT = 0
        BEGIN
            -- ����ʧ��
            SET @ResultMessage = '����ʧ��'

            ROLLBACK TRANSACTION
        END
      ELSE
        BEGIN
            -- ���³ɹ�
            SET @ResultMessage = '���ĳɹ�'

            COMMIT TRANSACTION
        END
  END

SELECT *
FROM   CHOICES

DECLARE @ResultMessage NVARCHAR(50);

-- ִ�д洢����
EXEC Updatestudentscore
  @sid = '12345      ',
  @ResultMessage = @ResultMessage OUTPUT;

-- ��������Ϣ
SELECT @ResultMessage AS ResultMessage; 


--7.

select UPPER(email) as UppercaseEmail,SUBSTRING(cname,1,3) as CourseNamePrefix
from STUDENTS as S,COURSES as C,CHOICES as CH
where S.sid = '800007595' and CH.sid=S.sid and CH.cid=C.cid


--8

--��������ֵ���������������ѧ��ѧ�Ų���������ѧ����ѡ�ε�ƽ���ɼ�
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

--����������ֵ����������ѧ����ʵ������ʾ������ѡ�޿γ����ͳɼ�
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

--����������ֵ���������ݿγ����Ʋ�ѯ����ѡ����Щ�γ̵�ѧ�������ͷ���
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

--9.����һ���α꣬��ѧ��Ϊ800007595��ѧ����ѡ�޿γ����ͳɼ����д�ӡ������

--����ѡ������ѧ��
SELECT TOP 1 Ch.sid,COUNT(*) as COURSECOUNT
FROM Courses AS C
JOIN Choices AS Ch ON C.cid = Ch.cid
GROUP BY Ch.sid
ORDER BY COUNT(*) DESC;


DECLARE @CourseName NVARCHAR(100), @Score INT;

-- �����α�
DECLARE course_cursor CURSOR FOR
SELECT C.cname, Ch.Score
FROM Courses AS C
JOIN Choices AS Ch ON C.cid = Ch.cid
WHERE Ch.sid = '859761946 ';

-- ���α�
OPEN course_cursor;

-- ��ȡ��һ������
FETCH NEXT FROM course_cursor INTO @CourseName, @Score;

-- �����α��е�ÿһ��
WHILE @@FETCH_STATUS = 0
BEGIN
    -- ��ӡ�γ����ͳɼ�
    PRINT 'Course Name: ' + @CourseName + ', Score: ' + CAST(@Score AS NVARCHAR(10));

    -- ��ȡ��һ������
    FETCH NEXT FROM course_cursor INTO @CourseName, @Score;
END;

-- �ر��α�
CLOSE course_cursor;

-- �ͷ��α���Դ
DEALLOCATE course_cursor;

SELECT C.cname, Ch.Score
FROM Courses AS C
JOIN Choices AS Ch ON C.cid = Ch.cid
WHERE Ch.sid = '859761946 ';

--����һ���α꣬��ѧ��Ϊ800007595��ѧ���ĵڶ���ѡ�޿γ̳ɼ����ɼ��������У���Ϊ75�֡�

DECLARE @CourseID INT, @Score INT;
DECLARE @Counter INT = 0;

-- �����α�
DECLARE second_course_cursor CURSOR FOR
SELECT cid, Score
FROM Choices
WHERE sid = '859761946 '
ORDER BY Score DESC;

-- ���α�
OPEN second_course_cursor;

-- ��ȡ��һ������
FETCH NEXT FROM second_course_cursor INTO @CourseID, @Score;

-- �����α��е�ÿһ��
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Counter = @Counter + 1;

    -- ����ǵڶ�������
    IF @Counter = 2
    BEGIN
        -- ���³ɼ�Ϊ75��
        UPDATE Choices
        SET Score = 75
        WHERE sid = '859761946 ' AND cid = @CourseID;
        BREAK;
    END;

    -- ��ȡ��һ������
    FETCH NEXT FROM second_course_cursor INTO @CourseID, @Score;
END;

-- �ر��α�
CLOSE second_course_cursor;

-- �ͷ��α���Դ
DEALLOCATE second_course_cursor;

SELECT C.cname, Ch.Score
FROM Courses AS C
JOIN Choices AS Ch ON C.cid = Ch.cid
WHERE Ch.sid = '859761946 ';
--����һ��û��Ψһ�����ı�����һ���α꣬ɾ������һ����¼���鿴�Ƿ�����ɾ����

CREATE TABLE TestTable (
    ID INT,
    Value NVARCHAR(50)
);

-- ����һЩ����
INSERT INTO TestTable (ID, Value) VALUES (1, 'Value1');
INSERT INTO TestTable (ID, Value) VALUES (2, 'Value2');
INSERT INTO TestTable (ID, Value) VALUES (3, 'Value3');

DECLARE @ID INT, @Value NVARCHAR(50);

-- �����α�
DECLARE delete_cursor CURSOR FOR
SELECT ID, Value
FROM TestTable;

-- ���α�
OPEN delete_cursor;

-- ��ȡ��һ������
FETCH NEXT FROM delete_cursor INTO @ID, @Value;

-- ɾ����ǰ�α�ָ��ļ�¼
DELETE FROM TestTable
WHERE CURRENT OF delete_cursor;

-- �鿴�Ƿ�����ɾ��
IF @@ROWCOUNT = 1
BEGIN
    PRINT 'Record deleted successfully';
END
ELSE
BEGIN
    PRINT 'Failed to delete record';
END;

-- �ر��α�
CLOSE delete_cursor;

-- �ͷ��α���Դ
DEALLOCATE delete_cursor;

-- �鿴���е�����
SELECT * FROM TestTable;



