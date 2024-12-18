select distinct Color
from dbo.Product
where color is not null


use MyDB
go
-- ezeket kell visszaadni pusz m�g Pink, Green, Silver
-- adatokat nem m�dos�that !!!
create or alter function dbo.GetColors()
returns @result table(Color varchar(20) unique)
as
begin

insert into @result(Color)
select distinct Color
from dbo.Product
where color is not null
-- t�blakostruktor, union all,ilyenekkel is meg lehetne 
insert into @result(Color)
select 'Pink'
where not exists(select * from @result r where r.Color = 'Pink')

insert into @result(Color)
select 'Green'
where not exists(select * from @result r where r.Color = 'Green')

insert into @result(Color)
select 'Silver'
where not exists(select * from @result r where r.Color = 'Silver')

return

end
go

--megh�v�s
select * from dbo.GetColors()
order by Color

-- megl�v� f�ggv�ny m�dos�t�sa: jobb eg�r gomb, Modify
USE [AdventureWorks2019]
GO
/****** Object:  UserDefinedFunction [dbo].[ufnOrderStat]    Script Date: 2024. 12. 11. 10:57:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[ufnOrderStat](@Year int = NULL)
returns table
as
return(
select year(OrderDate) as Year, month(OrderDate) as Month, count(*) as OrderCount,sum(SubTotal) as Total
from Sales.SalesOrderHeader
where year(OrderDate) = case when @Year is null then year(OrderDate) else @Year end -- ezt m�dos�tottuk
group by year(OrderDate), month(OrderDate)
)

select * from [dbo].[ufnOrderStat](2011)

select * from [dbo].[ufnOrderStat](default) -- alap�rtelmezett �rt�kkel h�vva mindet visszaadja
order by Year, Month

-- ld. m�g feladatok