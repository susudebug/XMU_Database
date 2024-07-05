CREATE TRIGGER T1
ON sc
FOR INSERT
AS
    SELECT *
    FROM   inserted

    INSERT INTO sc
                (sno,
                 cno,
                 grade)
    VALUES     ('95001',
                '4',
                98)--每次一执行insert都会执行select * from inserted
    INSERT INTO sc
                (sno,
                 cno,
                 grade)
    VALUES     ('95001',
                '5',
                97)--每次执行都会新建一个新的inserted表
    DROP TRIGGER T1

--学生成绩不低于60分,低于60分自动赋为60分
CREATE TRIGGER T1
ON sc
FOR INSERT
AS
    UPDATE sc
    SET    grade = 60
    WHERE  EXISTS(SELECT *
                  FROM   inserted
                  WHERE  sc.sno = inserted.sno
                         AND sc.cno = inserted.cno
                         AND sc.grade < 60)

    INSERT INTO sc
                (sno,
                 cno,
                 grade)
    VALUES     ('95001',
                '6',
                45)

    DROP TRIGGER T1

--计算机（sdept为'CS'）学生成绩不低于60分,低于60分自动赋为60分
CREATE TRIGGER T1
ON sc
FOR INSERT
AS
    UPDATE sc
    SET    grade = 60
    WHERE  EXISTS(SELECT *
                  FROM   inserted
                  WHERE  sc.sno = inserted.sno
                         AND sc.cno = inserted.cno
                         AND sc.grade < 60)
           AND EXISTS(SELECT *
                      FROM   student
                      WHERE  sc.Sno = Student.sno
                             AND Student.Sdept = 'SC')

    INSERT INTO sc
                (sno,
                 cno,
                 grade)
    VALUES     ('95002',
                '6',
                45)

    SELECT *
    FROM   sc,
           student
    WHERE  sc.sno = Student.sno

    DELETE FROM sc
    WHERE  grade = 60 
