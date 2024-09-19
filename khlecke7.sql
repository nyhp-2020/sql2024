--rangsoroló függvények
select
    OrderID,
    SubTotal,
    row_number()    over(order by Subtotal) as [ROW_NUMBER],
    rank()          over(order by Subtotal) as [RANK],
    dense_rank()    over(order by Subtotal) as [DENSE_RANK],
    ntile(2)         over(order by Subtotal) as [NTILE],
    percent_rank()  over(order by Subtotal) as [PERCENT_RANK]
from Orders
where OrderID in(43660,43659,43664,60123,74139)
order by SubTotal


select
    OrderID,
    SubTotal,
    row_number()    over(order by Subtotal, OrderID desc) as [ROW_NUMBER],
    rank()          over(order by Subtotal) as [RANK],
    dense_rank()    over(order by Subtotal) as [DENSE_RANK],
    ntile(2)         over(order by Subtotal) as [NTILE],
    percent_rank()  over(order by Subtotal) as [PERCENT_RANK]
from Orders
where OrderID in(43660,43659,43664,60123,74139)
order by SubTotal,OrderID

select
    OrderID,
    SubTotal,
    row_number()    over(order by Subtotal, OrderID desc) as [ROW_NUMBER],
    rank()          over(order by Subtotal) as [RANK], --rang, így van ismétlés, érték kihagyás
    dense_rank()    over(order by Subtotal) as [DENSE_RANK], --nem hagy ki értéket, ha ismétlődés van
    ntile(3)         over(order by Subtotal) as [NTILE], -- felosztás egyenlő arányban
    percent_rank()  over(order by Subtotal) as [PERCENT_RANK] --rank sorszám van kifelyezve százalékban 0 és 1 között
from Orders
where OrderID in(43660,43659,43664,60123,74139)
order by SubTotal

select
    OrderID,
    SubTotal,
    row_number()    over(order by Subtotal, OrderID desc) as [ROW_NUMBER],
    rank()          over(order by Subtotal, OrderID) as [RANK], --rang, így már különböző
    dense_rank()    over(order by Subtotal) as [DENSE_RANK],
    ntile(2)         over(order by Subtotal) as [NTILE],
    percent_rank()  over(order by Subtotal) as [PERCENT_RANK]
from Orders
where OrderID in(43660,43659,43664,60123,74139)
order by SubTotal