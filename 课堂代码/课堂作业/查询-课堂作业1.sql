USE test

SELECT *
FROM   Course

SELECT *
FROM   SC

SELECT *
FROM   Student

/*��ѯѡ����"�����ݿ���Ϊ���п�"�Ŀγ̵�ѧ��������ѧ��*/
/*��һ�ַ�����ʹ�ö������*/
SELECT Student.Sname,
       Student.Sno
FROM   Course first,
       Course second,
       Student,
       SC
WHERE  first.Cpno = second.Cno
       AND SC.Sno = Student.Sno
       AND SC.Cno = first.Cno
       AND second.Cname = '���ݿ�'
/*ʹ��Ƕ�ײ�ѯ*/
SELECT Student.Sname,
       Student.Sno
FROM   SC,
       Student
WHERE  SC.Cno IN (SELECT first.Cno
                  FROM   Course first,
                         Course second
                  WHERE  first.Cpno = second.Cno
                         AND second.Cname = '���ݿ�')
       AND Student.Sno = SC.Sno


/*ʹ��EXISTS��ѯ*/
SELECT Sname,
       Sno
FROM   Student
WHERE  EXISTS(SELECT *
              FROM   course x
              WHERE  EXISTS(SELECT *
                            FROM   course y
                            WHERE  x.Cpno = y.Cno
                                   AND y.Cname = '���ݿ�')
                     AND EXISTS(SELECT *
                                FROM   SC
                                WHERE  x.Cno = SC.Cno and SC.Sno=Student.Sno)) 
