create or alter procedure uspNewOrder(
	@SessionID uniqueidentifier,
	@OrderID int = null output
)
as

set @OrderID = ( -- keresés
	select o.OrderID
	from dbo.Orders o
	where o.SessionID = @SessionID and o.Status = 0
)

if @OrderID is null --ha nincs ilyen, akkor beszúrunk
	begin
		create table #pqal91(OrderID int) -- talán nem létezik ilyen nevû tábla...
	
		insert into dbo.Orders(OrderDate,Status,SessionID)
		output inserted.OrderID into #pqal91 -- az új OrderID mentése ideiglenes táblába
		values(default,default,default)

		set @OrderID = (select * from #pqal91) -- az új OrderID mentése változóba

		drop table if exists #pqal91
	end

--select @OrderID
go

declare @ID int

exec uspNewOrder @SessionID = '97E4873E-200C-47BC-AC30-7658912ADB40',
	@OrderID = @ID output --kifelé irányuló paraméter átadás

select @ID