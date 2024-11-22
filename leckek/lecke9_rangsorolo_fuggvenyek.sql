select
    OrderID,
    SubTotal,
    row_number() over(order by SubTotal, OrderID desc) as [ROW_NUMBER], --sorszám
    rank() over(order by SubTotal) as [RANK],                           --rang
    dense_rank() over(order by SubTotal) as [DENSE_RANK],               --sürített rang
    ntile(2) over(order by SubTotal) as [NTILE],                        --sorokat felosztja ennyi felé; Kevesebbet adjunk meg mint ahány sorra számítunk.
    percent_rank() over(order by SubTotal) as [PERCENT_RANK]            --rank érték százalékban?
from Orders
where OrderID in (43660, 43659, 43664, 60123, 74139)
order by SubTotal--, OrderID
--order by OrderID


select
    OrderID,
    SubTotal,
    row_number() over(order by SubTotal, OrderID desc) as [ROW_NUMBER], --sorszám
    rank() over(order by SubTotal, OrderID) as [RANK],                  --rang különbözőt ad vissza
    dense_rank() over(order by SubTotal) as [DENSE_RANK],
    ntile(2) over(order by SubTotal) as [NTILE],
    percent_rank() over(order by SubTotal) as [PERCENT_RANK]
from Orders
where OrderID in (43660, 43659, 43664, 60123, 74139)
order by SubTotal--, OrderID

select
    OrderID,
    SubTotal,
    row_number() over(order by SubTotal, OrderID desc) as [ROW_NUMBER], --sorszám
    rank() over(order by SubTotal) as [RANK],                           --rang
    dense_rank() over(order by SubTotal) as [DENSE_RANK],               --sürített rang
    ntile(3) over(order by SubTotal) as [NTILE],                        --sorokat felosztja ennyi felé (itt 3 felé)
    percent_rank() over(order by SubTotal) as [PERCENT_RANK]
from Orders
where OrderID in (43660, 43659, 43664, 60123, 74139)
order by SubTotal--, OrderID