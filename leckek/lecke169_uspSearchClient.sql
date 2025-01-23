use [AdventureWorks2019]
go

--declare @Value nvarchar(100) = 'S%'
create or alter procedure uspSearchClient(
		@ColumnName nvarchar(1000),
		@ColumnValue nvarchar(1000),
		@Operator nvarchar(10) = '='
)
as
declare @sql nvarchar(max)

set @sql ='
select
	c.CustomerID,
	p.FirstName,
	p.LastName,
	st.Name as SalesTerritory,
	a.City
from Sales.Customer c
inner join Person.Person p on p.BusinessEntityID = c.CustomerID
left join Sales.SalesTerritory st on st.TerritoryID = c.TerritoryID
left join Person.BusinessEntityAddress pa on pa.BusinessEntityID = c.CustomerID
left join Person.Address a on a.AddressID = pa.AddressID
where '+ @ColumnName + ' ' + @Operator + ' ' + ' @Value '
--exec(@sql)
--exec sp_executesql @sql, N'@Value nvarchar(1000)', @Value = @ColumnValue

-- n�v szerinti param�ter �tad�s
exec sp_executesql
@stmt = @sql,
@params = N'@Value nvarchar(1000), @Param2 int',
@Value = @ColumnValue,
@Param2 =4

go

-- pr�bah�v�sok
exec uspSearchClient 'FirstName', 'John'

exec uspSearchClient 'FirstName', 'J%','like'

--n�v szerint
exec uspSearchClient
	@ColumnName = 'FirstName',
	@ColumnValue = 'J%',
	@Operator = 'like'

--sql injection
exec uspSearchClient
	@ColumnName = 'LastName = ''''; drop table Production.WorkOrderRouting --',



--kiindul�si lek�rdez�s
select
	c.CustomerID,
	p.FirstName,
	p.LastName,
	st.Name as SalesTerritory,
	a.City
from Sales.Customer c
inner join Person.Person p on p.BusinessEntityID = c.CustomerID
left join Sales.SalesTerritory st on st.TerritoryID = c.TerritoryID
left join Person.BusinessEntityAddress pa on pa.BusinessEntityID = c.CustomerID
left join Person.Address a on a.AddressID = pa.AddressID

-- egy kor�bbi verzi�
set @sql ='
select
	c.CustomerID,
	p.FirstName,
	p.LastName,
	st.Name as SalesTerritory,
	a.City
from Sales.Customer c
inner join Person.Person p on p.BusinessEntityID = c.CustomerID
left join Sales.SalesTerritory st on st.TerritoryID = c.TerritoryID
left join Person.BusinessEntityAddress pa on pa.BusinessEntityID = c.CustomerID
left join Person.Address a on a.AddressID = pa.AddressID
where '+ @ColumnName + ' ' + @Operator + ' ' + '''' + @ColumnValue + '''' --aposztr�fok dinamikus sql-ben

