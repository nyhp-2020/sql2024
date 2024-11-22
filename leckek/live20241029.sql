select *
from Orders
pivot(count(OrderID) for SalesPersonID in ([0],[111],[999]))  p-- itt az in nem sql in operátor, hanem egy oszlopfejléc definíció

--formázás
select OrderDate,format([0], 'N2') as [0],[111],[999]
from Orders
pivot(count(OrderID) for SalesPersonID in ([0],[111],[999]))  p


drop table if exists #temp
select OrderDate,[0],[111],[999]
into #temp
from Orders
pivot(count(OrderID) for SalesPersonID in ([0],[111],[999]))  p

select * from #temp

--unpivot -- ami pivotban oszlopokban volt, az most sorokban van
select OrderDate, Oszlop, Ertek
from (
    select * from #temp
) a
unpivot(Ertek for Oszlop in ([0],[111],[999])) u


select distinct SalesPersonID from Orders where SalesPersonID is not null 


drop table if exists #temp
select OrderDate,format([0], 'N2') as [0],[111],[999]
into #temp
from Orders
pivot(count(OrderID) for SalesPersonID in ([0],[111],[999]))  p

select * from #temp

-- mostmár az Ertek az szöveg típusu
select OrderDate, Oszlop, Ertek
from (
    select
        OrderDate,
        cast([0] as varchar(100)) as [0],
        cast([111] as varchar(100)) as [111],
          cast([999] as varchar(100)) as [999]
    from #temp
) a
unpivot(Ertek for Oszlop in ([0],[111],[999])) u --visszaforgatás