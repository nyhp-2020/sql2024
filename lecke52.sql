-- allekérdezések where után
-- nem lehet alias
-- használhat külső oszlopokat a from utáni táblákból, de csak a where előttiekből
-- dinamikus szűréshez
-- 3 kategória
--1 EXISTS, ALL után
--2 IN után
--3 Aritmetikai operátor után (= < > LIKE)


--WHERE subquery
-- 1. EXISTS
select distinct o.OrderID, o.OrderDate, o.SubTotal -- ha egy rendelésen belül többet is rendeltek az in listából, többszöröződnének a sorok azért van a distinct
from Orders o
inner join OrderDetail od on od.OrderID= o.OrderID
where od.ProductID in (716,725,764)
order by o.OrderID

--vagy
--itt nem kapunk duplikátumokat az exists miatt
select o.OrderID, o.OrderDate, o.SubTotal
from Orders o
where exists( --itt az a fontos, hogy egy sorral visszatér-e a belső lekérdezés. Ha igen, az exist igazzal tér vissza, tehát visszakapjuk az Orders sort
    select *
    from OrderDetail od
    where od.OrderID= o.OrderID
    and od.ProductID in (716,725,764)
) -- ebből a belső lekérdezésből nem lehet semmit kinyerni külső használatra
order by o.OrderID

-- 2. IN
-- csak 1 oszloppal térhat vissza
-- bármennyi sort visszaadhat
-- nincs alias
-- a belső oszlopnevek nem számítanak,nem kötelezők
-- az IN használhat konstans értéklistát is

select *
from Orders o
where o.OrderDate in (
    select distinct o.OrderDate
    from OrderDetail od
    inner join Orders o on od.OrderID = o.OrderID
    where od.ProductID = 911
)

--ha eltávolítom a distinct-et a subquery-ből, nem változik az eredmény
-- az in operátort nem érdekli, hogy a listaelemek ismétlődnek belül
select *
from Orders o
where o.OrderDate in (
    select o.OrderDate
    from OrderDetail od
    inner join Orders o on od.OrderID = o.OrderID
    where od.ProductID = 911
)


--ha kézzel beírom a két dátumot
select *
from Orders o
where o.OrderDate in ('2013-05-30 00:00:00','2013-07-31 00:00:00')



-- a 911-es terméket ezeken a napokon adták el
select distinct o.OrderDate
from OrderDetail od
inner join Orders o on od.OrderID = o.OrderID
where od.ProductID = 911

select *
from OrderDetail
where ProductID = 911

-- több rendelésben is rendeltek 911-et ugyanazon dátummal
select o.OrderDate, o.OrderID, od.ProductID
from OrderDetail od
inner join Orders o on od.OrderID = o.OrderID
where od.ProductID = 911

select distinct o.OrderDate, o.OrderID, od.ProductID -- itt a distinct a mezőkombinációra vonatkozik, tehát nem hoz változást
from OrderDetail od
inner join Orders o on od.OrderID = o.OrderID
where od.ProductID = 911