declare @message nvarchar(1000) = 'Ez itt egy hiba�zenet!'
--hiba l�trehoz�sa
raiserror(@message,16,0)

raiserror('Ez itt egy hiba�zenet!',10,0)

select * from sys.messages

raiserror(46918,10,0)
select * from sys.messages where message_id = 46918 --k�l�nb�z� nyelveken

declare @table_name sysname= 'Person'
raiserror('A megadott t�bla (%s:%d) nem l�tezik (%s)',16,0,@table_name,1354684,'!')
go

begin try

--select top 0 * from dbo.Product
select top 1 * from dbo.Product where ProductName = 'X'

--select top 1 * from dbo.Product where ProductName = 1 -- ez is hiba
--select top 1 * from dbo.Product

if @@rowcount = 0
	--raiserror('Nincsenek sorok',10,0)
	raiserror('Nincsenek sorok',20,0) with log --szerver megszak�tja a kapcsolatot

end try
begin catch
	print 'Hiba keletkezett: ' + error_message()
end catch
go

--v�rakoz�s
waitfor delay '00:00:05'

print 'Teszt1'
waitfor delay '00:00:05'

raiserror('Teszt2',0,0)
waitfor delay '00:00:05'

print 'Teszt1'
raiserror('Teszt2',0,0) with nowait --kik�nyszer�tj�k az �zenetpuffer �r�t�s�t
print 'Teszt3'
waitfor delay '00:00:5'

declare @c int = 0
while (1 = 1) --v�gtelen ciklus
begin

	set @c += 1
	--print concat('Sor', @c)
	--raiserror('Sor%d', 0, 0, @c)
	raiserror('Sor%d', 0, 0, @c) with nowait --azonnal kiirja az aktu�lis sorsz�mot
	waitfor delay '00:00:01'

end
go

--objektumok list�z�sa
declare @c int = 100000
declare @table_name sysname
while (1 = 1) --v�gtelen ciklus
begin
	select top 1
		@c = object_id,
		@table_name = name
	from sys.objects
	where object_id > @c
	order by object_id

	if @@rowcount = 0 break

	raiserror('ObjectID: %d , ObjectName: %s', 0, 0, @c,@table_name) with nowait
	waitfor delay '00:00:01'

end

go

-- throw

throw 50000, 'Ez itt a hiba�zenet', 0 --hibak�d minimum 50000, csak 16-os severity (s�lyoss�g)

throw 50000, 'Ez itt egy �jabb hiba', 0

begin try
	--throw 500,'gsdfsdf',0
	throw 50030, 'Ez itt egy �jabb hiba', 0
end try
begin catch
	select @@error, error_number(),error_message()
end catch


begin try
	throw 50030, 'Ez itt egy �jabb hiba', 0
end try
begin catch
	declare @error_message nvarchar(2000) = error_message() --elmentj�k
	;throw --hiba tov�bbdob�sa
end catch