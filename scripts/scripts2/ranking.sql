select row_number() over(partition by Country order by FirstName) as Sorszám, *
from Customer
where Country is not null
order by CustomerID


select 
    OrderID, 
    SubTotal,
    row_number() over(order by SubTotal, OrderID desc) as [ROW_NUMBER],
    rank() over(order by SubTotal) as [RANK],
    dense_rank() over(order by SubTotal) as [DENSE_RANK],
    ntile(2) over(order by SubTotal) as [NTILE],
    percent_rank() over(order by SubTotal) as [PERCENT_RANK]
from Orders
where OrderID in (43660, 43659, 43664, 60123, 74139)
order by SubTotal--, OrderID
--order by OrderID



