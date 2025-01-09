declare @valtozo int = 123 --alapételmezett érték null
--declare @datum datetime = getdate()
--declare @datum smalldatetime --másodpercek nélkül

-- az itt használt @valtozo egy másik, elõtte lévõ declare blokkban kell hogy legyen
declare @datum datetime = dateadd(day,@valtozo,getdate())
declare @rows int = (select count(*) from Customer)
declare @tort1 real --float
declare @tort numeric(20,4) = 0 --decimal(20,4)
declare @guid uniqueidentifier = newid()

--select @valtozo, @datum,@rows,@guid

print @valtozo --messages tab-on
-- v. az eredmény halmazok mellett egy külön csatornán küldi el az sqlserver
-- csak az elsõ 4000 karaktert
-- fejlesztéshez, debug-oláshoz

--print concat(@valtozo, @datum,@rows,@guid)

--típusok lekérdezése 
--select * from sys.types

--értékadás
select @valtozo = 999
select @valtozo = ProductID from Product  --minden sorra lefut...
select top 1 @valtozo = ProductID from Product order by ProductID desc -- max
select @valtozo = 777 from Product --ez is lefut minden sorra, feleslegesen
select @valtozo = @valtozo + 1 from Product
select @valtozo = @valtozo + 1, @tort = @tort + ListPrice from Product --összegzés
--a select vagy értéket ad, vagy eredményt ad vissza. A kettõ együtt nem megy

--set @valtozo = 111

print concat(@valtozo, @datum,@rows,@guid)

select @valtozo as [@valtozo] , @datum as [@datum],@rows as [@rows],@guid as [@guid],@tort as [@tort]
