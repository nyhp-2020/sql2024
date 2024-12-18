create or alter procedure uspNewOrder(
	@SessionID uniqueidentifier,
	@OrderID int = null output
)
as

set @OrderID = ( -- keres�s
	select o.OrderID
	from dbo.Orders o
	where o.SessionID = @SessionID and o.Status = 0
)

if @OrderID is null --ha nincs ilyen, akkor besz�runk
	begin
		create table #pqal91(OrderID int) -- tal�n nem l�tezik ilyen nev� t�bla...
	
		insert into dbo.Orders(OrderDate,Status,SessionID)
		output inserted.OrderID into #pqal91 -- az �j OrderID ment�se ideiglenes t�bl�ba
		values(default,default,default)

		set @OrderID = (select * from #pqal91) -- az �j OrderID ment�se v�ltoz�ba

		drop table if exists #pqal91
	end

--select @OrderID
go

declare @ID int

exec uspNewOrder @SessionID = '97E4873E-200C-47BC-AC30-7658912ADB40',
	@OrderID = @ID output --kifel� ir�nyul� param�ter �tad�s

select @ID