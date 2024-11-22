-- &file nevű változóba Backup_éééé_hh_nn_óóppmm.bak

declare @file varchar(2000)
--set @file = 'Backup_' + format(getdate(),'yyyy_MM_dd_hh_mm_ss') + '.bak'

set @file = 'Backup_' +  cast(year(getdate()) as varchar(4)) + '_'
                      +  cast(month(getdate()) as varchar(2)) + '_'
                      +  cast(day(getdate()) as varchar(2)) + '_'
                      +'.bak'

select @file

--lekérdezés futási ideje
declare @most datetime = getdate()

select top 100 * from Customer c 
outer apply (select sum(Subtotal) T from Orders where c.CustomerID = c.CustomerID) o

select datediff(ms, @most, getdate())
print datediff(ms, @most, getdate()) --ld messages tab


--mely vásárlónak volt a legtöbb vásárlása

declare @eredmeny nvarchar(100)

--select top 1 CustomerID, count(*) Orders
--from Orders
--group by CustomerID
--order by Orders desc

select top 1 @eredmeny = 'CustomerID:' + cast(CustomerID as varchar(10)) + ',Orders: ' + cast(count(*) as varchar(10))
from Orders
group by CustomerID
order by count(*) desc

print @eredmeny


-- a select -el értéket is adhatok, de akkor nem adhatok vissza eredményt is vele
declare @FirstName nvarchar(100)
select FirstName, LastName 
from Customer

select @FirstName = FirstName --az összes sorból értéket ad a @FirstName-nek, az utolsó marad
from Customer

-- ilyet nem lehet
--select @FirstName = FirstName, LastName
--from Customer

print @FirstName