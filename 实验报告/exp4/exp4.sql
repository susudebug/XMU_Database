USE School

/*�����ݿ�School�н�����Stu Union����������Լ������û��Υ��ʵ�������Ե�ǰ���²��벢����һ��
��¼*/
INSERT INTO Stu_Union
            (SUid,
             SUname)
VALUES      ('1',
             '����');

INSERT INTO Stu_Union
            (SUid,
             SUname)
VALUES      ('2',
             '����');

SELECT *
FROM   Stu_Union

--2 ��ʾΥ��ʵ�������ԵĲ������
--2.1 ��ϵ�������Բ���ȡ��ֵ
INSERT INTO Stu_Union
            (SUname)
VALUES      ('����');

--2.2 ���Բ����Ѿ����ڵ�����ֵ
INSERT INTO Stu_Union
            (SUid,
             SUname)
VALUES      ('1',
             '�');

--3 ��ʾΥ��ʵ�������Եĸ��²���
--����һ�������ڵļ�¼
UPDATE Stu_Union
SET    SUname = '����'
WHERE  SUid = '3'--����Υ��ʵ��������

--�������Գ�������
UPDATE Stu_Union
SET    SUname = '����2222222222222222'
WHERE  SUid = '2'

--��ʾ����Ĵ�����������Ľ����������Լ�����ʱ������ع�
--�ع��������
SELECT *
FROM   Stu_Union

--����Ľ���
BEGIN TRAN

--��������ִ��һϵ�в���
INSERT INTO Stu_Union
            (SUid,
             SUname)
VALUES      ('3',
             '��ǿ');

UPDATE Stu_Union
SET    SUname = '�Ʋ�'
WHERE  SUid = '3';

--ģ�����
UPDATE Stu_Union
SET    SUname = '����2222222222222222'
WHERE  SUid = '2'

--�ع�
COMMIT TRAN

SELECT *
FROM   Stu_Union

--�ع���������
SELECT *
FROM   Stu_Union

--����Ľ���
BEGIN TRAN

--��������ִ��һϵ�в���
INSERT INTO Stu_Union
            (SUid,
             SUname)
VALUES      ('3',
             '��ǿ');

UPDATE Stu_Union
SET    SUname = '�Ʋ�'
WHERE  SUid = '3';

--ģ�����
UPDATE Stu_Union
SET    SUname = '����2222222222222222'
WHERE  SUid = '2'

--�ع�
ROLLBACK TRAN

SELECT *
FROM   Stu_Union

DELETE Stu_Union
WHERE  SUid = '3'

SELECT *
FROM   Stu_Union

--ͨ������Scholarship������һЩ���ݡ�
CREATE TABLE Scholarship
  (
     ID   INT PRIMARY KEY,
     SUid CHAR(5),
     FOREIGN KEY(SUid) REFERENCES Stu_Union(SUid)
  )

--��ʾ�������е����ݻ�������ʱ���޷�����ʵ���������Լ�����������
--�޷�����ʵ��������
INSERT INTO Scholarship
            (SUid)
VALUES      ('2')

--�޷���������������
INSERT INTO Scholarship
            (ID,
             SUid)
VALUES      (1,
             '5')

USE School

-- 1. Ϊ��ʾ���������ԣ�������Course����cnoΪ������������Stu_Union�в������ݡ�Ϊ�����ʵ�鲽����Ԥ��׼����
CREATE TABLE Course
  (
     cno INT PRIMARY KEY
  )

SELECT *
FROM   Stu_Union

--2. ������sc����sno��cno�ֱ�Ϊ����Stu_Union���Լ�Course���������趨Ϊ����ɾ��������(sno, cno)Ϊ���������ڲ�Υ�����������Ե�ǰ���£��������ݡ�
DROP TABLE Stu_Union

CREATE TABLE Stu_Union
  (
     sno INT PRIMARY KEY
  )

CREATE TABLE sc
  (
     sno   INT,
     cno   INT,
     score FLOAT,
     CONSTRAINT PK PRIMARY KEY (sno, cno), --��(sno,cno)Ϊ����
     CONSTRAINT FK1 FOREIGN KEY(sno) REFERENCES Stu_Union(sno) ON DELETE CASCADE, --��sno��Ϊ����Stu_Union���������constraint FK1��Լ������ΪFK1����on delete cascade����Ϊ����ɾ��
     CONSTRAINT FK2 FOREIGN KEY(cno) REFERENCES Course(cno) ON DELETE CASCADE
  )

EXEC Sp_helpconstraint
  sc

SELECT *
FROM   Course

SELECT *
FROM   Stu_Union;

INSERT INTO Course
            (cno)
VALUES      (2000);

INSERT INTO Stu_Union
            (sno)
VALUES      (1000);

INSERT INTO sc
            (sno,
             cno,
             score)
VALUES      (1000,
             2000,
             99.5);

SELECT *
FROM   sc;

--3. ��ʾΥ�����������ԵĲ�������
--����������-������ݱ������Բ��ձ�
SELECT *
FROM   Course;

SELECT *
FROM   Stu_Union;

INSERT INTO sc
            (sno,
             cno,
             score)
VALUES      (1,
             2,
             99.5);

--4. ��Stu_Union��ɾ�����ݣ���ʾ����ɾ����
SELECT *
FROM   Stu_Union;

SELECT *
FROM   sc;

DELETE Stu_Union
WHERE  sno = 1000;

SELECT *
FROM   Stu_Union;

SELECT *
FROM   sc;

--5. Course��ɾ�����ݣ���ʾ����ɾ����
SELECT *
FROM   Course;

SELECT *
FROM   sc;

DELETE Course
WHERE  cno = 2000;

SELECT *
FROM   Course;

SELECT *
FROM   sc;

--6. Ϊ����ʾ���ؼ���ɾ��������Stu_Card����stu_idΪ����Stu_Union����������card_idΪ�����������������ݡ�
DROP TABLE sc, Stu_Union, Course;

CREATE TABLE Stu_Union
  (
     stu_id INT PRIMARY KEY
  );

CREATE TABLE Stu_Card
  (
     stu_id  INT,
     card_id INT PRIMARY KEY,
     grade   INT,
     CONSTRAINT FK1 FOREIGN KEY (stu_id) REFERENCES Stu_Union(stu_id) ON DELETE CASCADE
  )

INSERT INTO Stu_Union
            (stu_id)
VALUES      (1);

INSERT INTO Stu_Union
            (stu_id)
VALUES      (2);

INSERT INTO Stu_Card
            (stu_id,
             card_id,
             grade)
VALUES      (1,
             2017,
             3);

INSERT INTO Stu_Card
            (stu_id,
             card_id)
VALUES      (2,
             2018);

SELECT *
FROM   Stu_Card;

--7. Ϊ����ʾ���ؼ���ɾ��������ICBC_Card����stu_card_idΪ����Stu_Card����������bank_idΪ�����������������ݡ�
CREATE TABLE ICBC_Card
  (
     stu_card_id INT,
     bank_id     INT,
     grade       INT,
     CONSTRAINT PK PRIMARY KEY (bank_id),
     CONSTRAINT FK2 FOREIGN KEY(stu_card_id) REFERENCES Stu_Card(card_id) ON DELETE CASCADE
  )

INSERT INTO ICBC_Card
            (stu_card_id,
             bank_id,
             grade)
VALUES      (2017,
             10,
             1);

INSERT INTO ICBC_Card
            (stu_card_id,
             bank_id)
VALUES      (2018,
             11);

SELECT *
FROM   ICBC_Card

--8. ͨ��ɾ��Stu_Union���е�һ����¼����ʾ������Ķ��ؼ���ɾ����
SELECT *
FROM   Stu_Union;

SELECT *
FROM   Stu_Card;

SELECT *
FROM   ICBC_Card;

DELETE Stu_Union
WHERE  stu_id = 1;

SELECT *
FROM   Stu_Union;

SELECT *
FROM   Stu_Card;

SELECT *
FROM   ICBC_Card;

--9. ��ʾ�����н��ж��ؼ���ɾ��ʧ�ܵĴ����޸�ICBC_Card���������ԣ�ʹ���ΪOn delete No action, ��ʾ������ͨ��ɾ��students���е�һ����¼�����ؼ���ɾ��ʧ�ܣ���������ع�������ĳ�ʼ״̬��
SELECT *
FROM   ICBC_Card;

BEGIN TRAN

ALTER TABLE ICBC_Card
  DROP CONSTRAINT FK2;

ALTER TABLE ICBC_Card
  ADD CONSTRAINT FK2 FOREIGN KEY(stu_card_id) REFERENCES Stu_Card(card_id) ON DELETE no action;

DELETE Stu_Union
WHERE  stu_id = 1;

ROLLBACK TRAN

EXEC Sp_helpconstraint
  ICBC_Card;

SELECT *
FROM   ICBC_Card;

--10. ��ʾ���������⼰����������������ʦ�ڿκͿγ�ָ����ʦ���ι�ϵ�����ű��涨һ����ʦ�����ڶ��ſΣ�����ֻ��ȥ��һ�ſΡ�
--Ϊ���ű����໥֮��Ĳ��չ�ϵ����ʱ���������ν�ʦ���ڿν�ʦ�Ƿ���ͬ����������ͬѧ���Գ����޶��������ڿν�ʦ����ͬ����
CREATE TABLE Course_Teacher_Teaching
  (
     CourseId  INT NOT NULL,
     TeacherId INT NOT NULL,
     PRIMARY KEY (CourseId)
  );

CREATE TABLE Teacher_Listening
  (
     TeacherId INT NOT NULL,
     CourseId  INT NOT NULL,
     PRIMARY KEY (TeacherId)
  );

ALTER TABLE Course_Teacher_Teaching
  ADD CONSTRAINT FK3 FOREIGN KEY(TeacherId) REFERENCES Teacher_Listening(TeacherId)

ALTER TABLE Teacher_Listening
  ADD CONSTRAINT FK4 FOREIGN KEY(CourseId) REFERENCES Course_Teacher_Teaching(CourseId)

--��Ҫ��ʾ������������ϰǰ����ɾ��sc��stu_union���������
EXEC Sp_helpconstraint
  Stu_Union

ALTER TABLE Stu_Card
  DROP CONSTRAINT FK1

--1. �ڱ�sc����ʾ��������insert��������ѧ���ɼ�����60��ʱ���Զ���Ϊ60���������ȴ����ļ�¼���в���һ��ѧ���ɼ�����60�ļ�¼��
--��ʾ�����ⴴ��һ�����¼�ɼ�����60�ֵ�ѧ������ʵ��¼��
USE test

DELETE sc
WHERE  grade < 60;

CREATE TABLE Student_Record
  (
     sno   CHAR(5),
     cno   CHAR(1),
     grade INT
  );

DROP TRIGGER Triger_SC_Insert

DROP TABLE Student_Record

CREATE TRIGGER Triger_SC_Insert
ON sc
after INSERT
AS
  BEGIN
      DECLARE @sno CHAR(5);
      DECLARE @cno CHAR(1);
      DECLARE @grade INT;
      DECLARE cur1 CURSOR FOR
        SELECT *
        FROM   inserted;

      BEGIN
          OPEN cur1

          FETCH next FROM cur1 INTO @sno, @cno, @grade;

          WHILE( @@FETCH_STATUS = 0 )
            BEGIN
                IF ( @grade < 60 )
                  BEGIN
                      --��sc����
                      UPDATE sc
                      SET    grade = 60
                      WHERE  sno = @sno
                             AND cno = @cno;

                      --��ԭֵ�����¼��
                      INSERT INTO Student_Record
                                  (sno,
                                   cno,
                                   grade)
                      VALUES      (@sno,
                                   @cno,
                                   @grade);
                  END

                FETCH next FROM cur1 INTO @sno, @cno, @grade;
            END
      END

      CLOSE cur1

      DEALLOCATE cur1
  END

INSERT INTO sc
            (sno,
             cno,
             grade)
VALUES      (95003,
             6,
             51)

SELECT *
FROM   sc

SELECT *
FROM   Student_Record

--2. �ڱ�stu_union�д����м��������������¼���UPDATE�������±�stu_union��Sidʱ��ͬʱ����sc�е�ѡ�μ�¼��
--��ʾ�����������������ʵ�����൱�ھ���CASCADE������������á�
USE test;

EXEC Sp_helpconstraint
  Stu_Union;

CREATE TABLE Stu_Union
  (
     Sid INT PRIMARY KEY
  );

DROP TABLE Stu_Union

DROP TRIGGER Trigger_StuUnion_UpdateSid

CREATE TRIGGER Trigger_StuUnion_UpdateSid
ON stu_union
AFTER UPDATE
AS
  BEGIN
      SET NOCOUNT ON;

      UPDATE sc
      SET    Sno = inserted.Sid
      FROM   sc
             INNER JOIN inserted
                     ON inserted.Sid = sc.Sno;
  END

INSERT INTO Stu_Union
            (Sid)
VALUES      (95003)

BEGIN TRAN

SELECT *
FROM   Stu_Union

SELECT *
FROM   sc

UPDATE Stu_Union
SET    sid = 001
WHERE  sid = 95001

SELECT *
FROM   Stu_Union

SELECT *
FROM   sc

ROLLBACK TRAN

--3. �ڱ�stu_union��ɾ��һѧ����ѧ��(��ʾ��������delete ����)��ʹ����sc�йص���Ϣͬʱ��ɾ����
CREATE TRIGGER Trigger_StuUnion_Delete
ON Stu_Union
after DELETE
AS
  BEGIN
      DECLARE @Sid INT;

      SELECT @Sid = Sid
      FROM   deleted;

      DELETE FROM sc
      WHERE  sc.sno = @Sid;
  END

BEGIN TRAN

SELECT *
FROM   Stu_Union;

SELECT *
FROM   sc;

DELETE FROM Stu_Union
WHERE  Sid = 95001;

SELECT *
FROM   Stu_Union;

SELECT *
FROM   sc;

ROLLBACK TRAN

--4. ��ʾ������ɾ��������
--��ʾ��SQL2005�������������﷨
USE test

--1. STUDENTS(sid,sname,email,grade)
--��sname�Ͻ����۴�������grade�Ͻ����Ǿ۴�������������������������
-- ���� STUDENTS ��
CREATE TABLE STUDENTS
  (
     sno   VARCHAR(10) PRIMARY KEY,
     sname VARCHAR(50),
     email VARCHAR(50),
     grade INT
  );

CREATE CLUSTERED INDEX idx_clus_sname
  ON STUDENTS(sname);

CREATE INDEX idx_grade
  ON STUDENTS(grade);

-- ���� CHOICES ��
CREATE TABLE CHOICES
  (
     no    INT IDENTITY(1, 1) PRIMARY KEY,
     sid   VARCHAR(10),
     tid   VARCHAR(10),
     cid   VARCHAR(10),
     score INT
  );

-- Ϊ cid �ֶ����������ʵ��2A��
SELECT Count(*)
FROM   CHOICES
WHERE  cid = '101';

-- Ϊ cid �ֶ���ӷǾ۴�������ʵ��2B��
CREATE NONCLUSTERED INDEX idx_cid
  ON CHOICES(cid);

-- �������в�ѯ��ʵ��2B��
SELECT Count(*)
FROM   CHOICES
WHERE  cid = '101'; 
