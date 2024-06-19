USE School

/*在数据库School中建立表Stu Union，进行主键约束，在没有违反实体完整性的前提下插入并更新一条
记录*/
INSERT INTO Stu_Union
            (SUid,
             SUname)
VALUES      ('1',
             '李明');

INSERT INTO Stu_Union
            (SUid,
             SUname)
VALUES      ('2',
             '张三');

SELECT *
FROM   Stu_Union

--2 演示违反实体完整性的插入操作
--2.1 关系的主属性不能取空值
INSERT INTO Stu_Union
            (SUname)
VALUES      ('李四');

--2.2 尝试插入已经存在的主键值
INSERT INTO Stu_Union
            (SUid,
             SUname)
VALUES      ('1',
             '李华');

--3 演示违反实体完整性的更新操作
--更新一个不存在的记录
UPDATE Stu_Union
SET    SUname = '王力'
WHERE  SUid = '3'--并不违反实体完整性

--超过属性长度限制
UPDATE Stu_Union
SET    SUname = '王力2222222222222222'
WHERE  SUid = '2'

--演示事务的处理，包括事务的建立，处理以及出错时的事物回滚
--回滚出错语句
SELECT *
FROM   Stu_Union

--事物的建立
BEGIN TRAN

--在事物中执行一系列操作
INSERT INTO Stu_Union
            (SUid,
             SUname)
VALUES      ('3',
             '张强');

UPDATE Stu_Union
SET    SUname = '黄波'
WHERE  SUid = '3';

--模拟出错
UPDATE Stu_Union
SET    SUname = '王力2222222222222222'
WHERE  SUid = '2'

--回滚
COMMIT TRAN

SELECT *
FROM   Stu_Union

--回滚整个事务
SELECT *
FROM   Stu_Union

--事物的建立
BEGIN TRAN

--在事物中执行一系列操作
INSERT INTO Stu_Union
            (SUid,
             SUname)
VALUES      ('3',
             '张强');

UPDATE Stu_Union
SET    SUname = '黄波'
WHERE  SUid = '3';

--模拟出错
UPDATE Stu_Union
SET    SUname = '王力2222222222222222'
WHERE  SUid = '2'

--回滚
ROLLBACK TRAN

SELECT *
FROM   Stu_Union

DELETE Stu_Union
WHERE  SUid = '3'

SELECT *
FROM   Stu_Union

--通过建立Scholarship表，插入一些数据。
CREATE TABLE Scholarship
  (
     ID   INT PRIMARY KEY,
     SUid CHAR(5),
     FOREIGN KEY(SUid) REFERENCES Stu_Union(SUid)
  )

--演示当与现有的数据环境不等时，无法建立实体完整性以及参照完整性
--无法建立实体完整性
INSERT INTO Scholarship
            (SUid)
VALUES      ('2')

--无法建立参照完整性
INSERT INTO Scholarship
            (ID,
             SUid)
VALUES      (1,
             '5')

USE School

-- 1. 为演示参照完整性，建立表Course，令cno为其主键，并在Stu_Union中插入数据。为下面的实验步骤做预先准备。
CREATE TABLE Course
  (
     cno INT PRIMARY KEY
  )

SELECT *
FROM   Stu_Union

--2. 建立表sc，另sno和cno分别为参照Stu_Union表以及Course表的外键，设定为级连删除，并令(sno, cno)为其主键。在不违反参照完整性的前提下，插入数据。
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
     CONSTRAINT PK PRIMARY KEY (sno, cno), --令(sno,cno)为主键
     CONSTRAINT FK1 FOREIGN KEY(sno) REFERENCES Stu_Union(sno) ON DELETE CASCADE, --将sno设为参照Stu_Union的外键，用constraint FK1将约束命名为FK1；用on delete cascade设置为级连删除
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

--3. 演示违反参照完整性的插入数据
--参照完整性-外键内容必须来自参照表
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

--4. 在Stu_Union中删除数据，演示级连删除。
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

--5. Course中删除数据，演示级连删除。
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

--6. 为了演示多重级连删除，建立Stu_Card表，令stu_id为参照Stu_Union表的外键，令card_id为其主键，并插入数据。
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

--7. 为了演示多重级连删除，建立ICBC_Card表，令stu_card_id为参照Stu_Card表的外键，令bank_id为其主键，并插入数据。
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

--8. 通过删除Stu_Union表中的一条记录，演示三个表的多重级连删除。
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

--9. 演示事务中进行多重级连删除失败的处理。修改ICBC_Card表的外键属性，使其变为On delete No action, 演示事务中通过删除students表中的一条记录，多重级连删除失败，整个事务回滚到事务的初始状态。
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

--10. 演示互参照问题及其解决方法。建立教师授课和课程指定教师听课关系的两张表，规定一个教师可以授多门课，但是只能去听一门课。
--为两张表建立相互之间的参照关系，暂时不考虑听课教师和授课教师是否相同（有余力的同学可以尝试限定听课与授课教师不相同）。
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

--重要提示：在做以下练习前，先删除sc对stu_union的外键引用
EXEC Sp_helpconstraint
  Stu_Union

ALTER TABLE Stu_Card
  DROP CONSTRAINT FK1

--1. 在表sc中演示触发器的insert操作，当学生成绩低于60分时，自动改为60，并在事先创建的记录表中插入一条学生成绩低于60的记录。
--提示：另外创建一个表记录成绩低于60分的学生的真实记录。
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
                      --将sc更新
                      UPDATE sc
                      SET    grade = 60
                      WHERE  sno = @sno
                             AND cno = @cno;

                      --将原值移入记录表
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

--2. 在表stu_union中创建行级触发器，触发事件是UPDATE。当更新表stu_union的Sid时，同时更新sc中的选课记录。
--提示：这个触发器的作用实际上相当于具有CASCADE参数的外键引用。
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

--3. 在表stu_union中删除一学生的学号(演示触发器的delete 操作)，使他在sc中关的信息同时被删除。
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

--4. 演示触发器删除操作。
--提示：SQL2005创建触发器的语法
USE test

--1. STUDENTS(sid,sname,email,grade)
--在sname上建立聚簇索引，grade上建立非聚簇索引，并分析所遇到的问题
-- 创建 STUDENTS 表
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

-- 创建 CHOICES 表
CREATE TABLE CHOICES
  (
     no    INT IDENTITY(1, 1) PRIMARY KEY,
     sid   VARCHAR(10),
     tid   VARCHAR(10),
     cid   VARCHAR(10),
     score INT
  );

-- 为 cid 字段添加索引（实验2A）
SELECT Count(*)
FROM   CHOICES
WHERE  cid = '101';

-- 为 cid 字段添加非聚簇索引（实验2B）
CREATE NONCLUSTERED INDEX idx_cid
  ON CHOICES(cid);

-- 重新运行查询（实验2B）
SELECT Count(*)
FROM   CHOICES
WHERE  cid = '101'; 
