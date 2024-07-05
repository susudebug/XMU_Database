/*某食品销售网店数据库包含以下3个关系：
食品表F(Fno,Fname,Fprice,Fdate,Fquality)分
别为：食品编号，食品名称，食品单价，生产
日期，保质期
顾客表c(Cno,Cname,Csex,cage)分别为：顾
客编号，顾客名称，顾客性别，顾客年龄；
销售表S(Sno,Fno,Cno,Scount,Ssum,Sdate)分
别为：销售流水号，食品编号，顾客编号，销
售数量，销售金额，销售日期*/
/*
题目一
(1)查找销售日期在2018年1月1日至2018
年3月1日期间，购买了所有单价大于50食
品男性顾客的顾客名称、顾客性别和顾客
年龄
食品表F(Fno,Fname,Fprice,Fdate,Fquality)
顾客表C(Cno,Cname,Csex,Cage)
销售表s(Sno,Fno,Cno,Scount,Ssum,Sdate)*/
/*没有一个单价大于50的食品没有被男顾客买*/
SELECT C.cno,
       C.cname
FROM   C
WHERE  C.csex = '男'
       AND NOT EXISTS(SELECT *
                      FROM   F
                      WHERE  Fprice > 50
                             AND NOT EXISTS(SELECT *
                                            FROM   S
                                            WHERE  Sdate <= '2018.3.1'
                                                   AND Sdate >= '2018.1.1'
                                                   AND S.Cno = C.Cno
                                                   AND S.Fno = F.Fno));

/*题目二
(2)查询从2018年1月1日到2018年5月31
日期间该网店已经销售且销量最低的食品
的销售记录，包括食品编号、食品名称、
销售总数量
食品表F(Fno,Fname,Fprice,Fdate,Fquality)
顾客表c(Cno,Cname,Csex,Cage)
销售表s(Sno,Fno,Cno,Scount,Ssum,Sdate)
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

/*(3)对食品表F中的食品单价进行调整，
将被所有顾客购买、食品单价大于50且总
销售金额最高的前3件食品分别降价5元。
食品表F(Fno,Fname,Fprice,Fdate,Fquality
顾客表c(Cno,Cname,Csex,Cage)
销售表sSno,Fno,Cno,Scount,Ssum,Sdate)*/
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

/*服装表G(Gno,Gname,Gsize,Gcolor,Gprice,Gmaterial)分别为：
服装编号，服装名称，
服装尺寸，服装颜色，服装单价，服装材质；
顾客表c(Cno,Cname,Csex,Cage,Cphone,
Caddress)分别为：顾客编号，顾客名称，顾
客性别，顾客年龄，顾客电话，顾客地址；
订单表o(Ono,Gno,Cno,Ocount,,Osum,Odate)分别为：订单号，服装编号，顾客编号，
销售数量，销售金额，下单日期；
退货表B(Bno,Ono,Gno,Cno,Bcount,Bsum,Bdate)分别为：退货单号，订单号，服装编
号，顾客编号，退货数量，退货金额，退货时间；
库存表GW(Gno,Wno,num,Ttime)分别为：服装编号，仓库编号，库存量，清点
时间；
仓库表W(Wno,Wname,Naddress)分别为仓库编号、仓库名称、仓库地址；
其中，表G由Gno唯一标识，表c由Cno唯一标识，表o由Ono和Gno唯一标识，表B由Bno、
Ono、Gno唯一标识，表GW由Gno和Wno唯一标识，表W由Wno唯一标识。*/
/*
题目一
查找下单日期在2019年4月1日（含）至2019年5月31日（含）期间，购买了所有服装材质为“纯棉”的女性顾客的顾客信息，
包括顾客姓名、顾客性别、顾客年龄、顾客电话、顾客地址。
服装表G(Gno,Gname,Gsize,Gcolor,Gprice,Gmaterial)
顾客表C(Cno,Cname,Csex,Cage,Cphone,Caddress)
订单表0(Ono,Gno,Cno,Ocount,Osum,Odate)
退货表B(Bno,Ono,Gno,Cno,Bcount,Bsum,Bdate)
库存表GW(Gno,Wno,num,Ttime)
*/
/*没有一件材质为纯棉的衣服没有被性别为女的顾客购买*/
SELECT Cname,
       Csex,
       Cage,
       Cphone,
       Caddress
FROM   C
WHERE  Csex = '女'
       AND Cno IN (SELECT Cno
                   FROM   O o1
                   WHERE  o1.Odate >= '2019.4.1'
                          AND o1.Odate <= '2019.5.31')
       AND NOT EXISTS(SELECT *
                      FROM   G
                      WHERE  Gmaterial = '纯棉'
                             AND NOT EXISTS(SELECT *
                                            FROM   O o2
                                            WHERE  o2.Gno = G.Gno
                                                   AND o2.Cno = C.Cno))

/*老师的答案*/
SELECT Cname,
       Csex,
       Cage,
       Cphone,
       Caddress
FROM   C
WHERE  Csex = '女'
       AND NOT EXISTS (SELECT*
                       FROM   G
                       WHERE  Gmaterial = '纯棉'
                              AND NOT EXISTS(SELECT*
                                             FROM   O
                                             WHERE  O.Odate BETWEEN'2019-04-01'AND '2019-05-31'
                                                    AND G.Gno = O.Gno
                                                    AND O.Cno = C.Cno)) 
