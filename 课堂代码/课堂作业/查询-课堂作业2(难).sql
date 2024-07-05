/*ĳʳƷ�����������ݿ��������3����ϵ��
ʳƷ��F(Fno,Fname,Fprice,Fdate,Fquality)��
��Ϊ��ʳƷ��ţ�ʳƷ���ƣ�ʳƷ���ۣ�����
���ڣ�������
�˿ͱ�c(Cno,Cname,Csex,cage)�ֱ�Ϊ����
�ͱ�ţ��˿����ƣ��˿��Ա𣬹˿����䣻
���۱�S(Sno,Fno,Cno,Scount,Ssum,Sdate)��
��Ϊ��������ˮ�ţ�ʳƷ��ţ��˿ͱ�ţ���
�����������۽���������*/
/*
��Ŀһ
(1)��������������2018��1��1����2018
��3��1���ڼ䣬���������е��۴���50ʳ
Ʒ���Թ˿͵Ĺ˿����ơ��˿��Ա�͹˿�
����
ʳƷ��F(Fno,Fname,Fprice,Fdate,Fquality)
�˿ͱ�C(Cno,Cname,Csex,Cage)
���۱�s(Sno,Fno,Cno,Scount,Ssum,Sdate)*/
/*û��һ�����۴���50��ʳƷû�б��й˿���*/
SELECT C.cno,
       C.cname
FROM   C
WHERE  C.csex = '��'
       AND NOT EXISTS(SELECT *
                      FROM   F
                      WHERE  Fprice > 50
                             AND NOT EXISTS(SELECT *
                                            FROM   S
                                            WHERE  Sdate <= '2018.3.1'
                                                   AND Sdate >= '2018.1.1'
                                                   AND S.Cno = C.Cno
                                                   AND S.Fno = F.Fno));

/*��Ŀ��
(2)��ѯ��2018��1��1�յ�2018��5��31
���ڼ�������Ѿ�������������͵�ʳƷ
�����ۼ�¼������ʳƷ��š�ʳƷ���ơ�
����������
ʳƷ��F(Fno,Fname,Fprice,Fdate,Fquality)
�˿ͱ�c(Cno,Cname,Csex,Cage)
���۱�s(Sno,Fno,Cno,Scount,Ssum,Sdate)
*/
SELECT TOP 1 Fno,
             Fname,
             Sum(Scount)
FROM   S,
       F
WHERE  Sdate <= '2018.5.31'
       AND Sdate >= '2018.1.1'
       AND S.Fno = F.Fno
GROUP  BY Fno,
          Fname
ORDER  BY Sum(Scount) ASC;

UPDATE F
SET    Fprice = Fprice - 5
WHERE  Fprice > 50
       AND Fno IN(SELECT TOP 3 Fno
                  FROM   s
                  GROUP  BY Fno
                  ORDER  BY Sum(Ssum) DESC)

/*(3)��ʳƷ��F�е�ʳƷ���۽��е�����
�������й˿͹���ʳƷ���۴���50����
���۽����ߵ�ǰ3��ʳƷ�ֱ𽵼�5Ԫ��
ʳƷ��F(Fno,Fname,Fprice,Fdate,Fquality
�˿ͱ�c(Cno,Cname,Csex,Cage)
���۱�sSno,Fno,Cno,Scount,Ssum,Sdate)*/
UPDATE F
SET    Fprice = Fprice - 5
WHERE  Fno IN(SELECT TOP 3 Fno
              FROM   s
              WHERE  s.fno IN(SELECT fno
                              FROM   F f1
                              WHERE  Fprice > 50
                                     AND NOT EXISTS(SELECT *
                                                    FROM   C
                                                    WHERE  NOT EXISTS(SELECT *
                                                                      FROM   S s1
                                                                      WHERE  f1.Fno = s1.Fno
                                                                             AND C.Cno = s1.Cno)))
              GROUP  BY Fno
              ORDER  BY Sum(Ssum) DESC)

/*��װ��G(Gno,Gname,Gsize,Gcolor,Gprice,Gmaterial)�ֱ�Ϊ��
��װ��ţ���װ���ƣ�
��װ�ߴ磬��װ��ɫ����װ���ۣ���װ���ʣ�
�˿ͱ�c(Cno,Cname,Csex,Cage,Cphone,
Caddress)�ֱ�Ϊ���˿ͱ�ţ��˿����ƣ���
���Ա𣬹˿����䣬�˿͵绰���˿͵�ַ��
������o(Ono,Gno,Cno,Ocount,,Osum,Odate)�ֱ�Ϊ�������ţ���װ��ţ��˿ͱ�ţ�
�������������۽��µ����ڣ�
�˻���B(Bno,Ono,Gno,Cno,Bcount,Bsum,Bdate)�ֱ�Ϊ���˻����ţ������ţ���װ��
�ţ��˿ͱ�ţ��˻��������˻����˻�ʱ�䣻
����GW(Gno,Wno,num,Ttime)�ֱ�Ϊ����װ��ţ��ֿ��ţ�����������
ʱ�䣻
�ֿ��W(Wno,Wname,Naddress)�ֱ�Ϊ�ֿ��š��ֿ����ơ��ֿ��ַ��
���У���G��GnoΨһ��ʶ����c��CnoΨһ��ʶ����o��Ono��GnoΨһ��ʶ����B��Bno��
Ono��GnoΨһ��ʶ����GW��Gno��WnoΨһ��ʶ����W��WnoΨһ��ʶ��*/
/*
��Ŀһ
�����µ�������2019��4��1�գ�������2019��5��31�գ������ڼ䣬���������з�װ����Ϊ�����ޡ���Ů�Թ˿͵Ĺ˿���Ϣ��
�����˿��������˿��Ա𡢹˿����䡢�˿͵绰���˿͵�ַ��
��װ��G(Gno,Gname,Gsize,Gcolor,Gprice,Gmaterial)
�˿ͱ�C(Cno,Cname,Csex,Cage,Cphone,Caddress)
������0(Ono,Gno,Cno,Ocount,Osum,Odate)
�˻���B(Bno,Ono,Gno,Cno,Bcount,Bsum,Bdate)
����GW(Gno,Wno,num,Ttime)
*/
/*û��һ������Ϊ���޵��·�û�б��Ա�ΪŮ�Ĺ˿͹���*/
SELECT Cname,
       Csex,
       Cage,
       Cphone,
       Caddress
FROM   C
WHERE  Csex = 'Ů'
       AND Cno IN (SELECT Cno
                   FROM   O o1
                   WHERE  o1.Odate >= '2019.4.1'
                          AND o1.Odate <= '2019.5.31')
       AND NOT EXISTS(SELECT *
                      FROM   G
                      WHERE  Gmaterial = '����'
                             AND NOT EXISTS(SELECT *
                                            FROM   O o2
                                            WHERE  o2.Gno = G.Gno
                                                   AND o2.Cno = C.Cno))

/*��ʦ�Ĵ�*/
SELECT Cname,
       Csex,
       Cage,
       Cphone,
       Caddress
FROM   C
WHERE  Csex = 'Ů'
       AND NOT EXISTS (SELECT*
                       FROM   G
                       WHERE  Gmaterial = '����'
                              AND NOT EXISTS(SELECT*
                                             FROM   O
                                             WHERE  O.Odate BETWEEN'2019-04-01'AND '2019-05-31'
                                                    AND G.Gno = O.Gno
                                                    AND O.Cno = C.Cno)) 
