declare @valtozo int = 123 --alap�telmezett �rt�k null
--declare @datum datetime = getdate()
--declare @datum smalldatetime --m�sodpercek n�lk�l

-- az itt haszn�lt @valtozo egy m�sik, el�tte l�v� declare blokkban kell hogy legyen
declare @datum datetime = dateadd(day,@valtozo,getdate())
declare @rows int = (select count(*) from Customer)
declare @tort1 real --float
declare @tort numeric(20,4) = 0 --decimal(20,4)
declare @guid uniqueidentifier = newid()

--select @valtozo, @datum,@rows,@guid

print @valtozo --messages tab-on
-- v. az eredm�ny halmazok mellett egy k�l�n csatorn�n k�ldi el az sqlserver
-- csak az els� 4000 karaktert
-- fejleszt�shez, debug-ol�shoz

--print concat(@valtozo, @datum,@rows,@guid)

--t�pusok lek�rdez�se 
--select * from sys.types

--�rt�kad�s
select @valtozo = 999
select @valtozo = ProductID from Product  --minden sorra lefut...
select top 1 @valtozo = ProductID from Product order by ProductID desc -- max
select @valtozo = 777 from Product --ez is lefut minden sorra, feleslegesen
select @valtozo = @valtozo + 1 from Product
select @valtozo = @valtozo + 1, @tort = @tort + ListPrice from Product --�sszegz�s
--a select vagy �rt�ket ad, vagy eredm�nyt ad vissza. A kett� egy�tt nem megy

--set @valtozo = 111

print concat(@valtozo, @datum,@rows,@guid)

select @valtozo as [@valtozo] , @datum as [@datum],@rows as [@rows],@guid as [@guid],@tort as [@tort]
