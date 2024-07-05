USE test

SELECT TOP 2 *
FROM   Student
WHERE  Sage > ALL (SELECT Sage
                   FROM   Student
                   WHERE  Sdept = 'IS')
       AND Sdept <> 'IS'
ORDER  BY Sname

SELECT TOP 2 *
FROM   Student
WHERE  Sno > (SELECT Max(Sno)
              FROM   (SELECT TOP 2 Sno
                      FROM   Student
                      ORDER  BY Sno) AS t)
ORDER  BY Sno

SELECT TOP 2 *
FROM   Student
WHERE  Sno > (SELECT Max(Sno)
              FROM   Student
              WHERE  Sno IN (SELECT TOP 2 Sno
                             FROM   Student
                             ORDER  BY Sno)) 
