select avg(Bonus) as avbonus
from Sales.SalesPerson

with cte as(
select avg(Bonus) as avbonus
from Sales.SalesPerson
)

select *
from Sales.SalesPerson
where Bonus > (select * from cte)
