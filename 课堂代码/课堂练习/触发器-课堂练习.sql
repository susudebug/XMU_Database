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
                98)--ÿ��һִ��insert����ִ��select * from inserted
    INSERT INTO sc
                (sno,
                 cno,
                 grade)
    VALUES     ('95001',
                '5',
                97)--ÿ��ִ�ж����½�һ���µ�inserted��
    DROP TRIGGER T1

--ѧ���ɼ�������60��,����60���Զ���Ϊ60��
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

--�������sdeptΪ'CS'��ѧ���ɼ�������60��,����60���Զ���Ϊ60��
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
