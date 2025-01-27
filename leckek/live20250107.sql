--ld update() függvény
--ld
columns_updated() --nincs paramétere, bitsorozattal tér vissza: 1 módosították, 0 nem módosították

substr(columns_updated(),1,1) -- a substr függvénnyel egy bináris byte tömbbõl is kivehetünk byte-okat

--auditálás: ki, mikor, mit módosított mirõl, mire

--bit összehasonlítás
select 123 & 1
select 1 & 1
select 2 & 1
select 3 & 1

select 2 & 2

select 3 & 3


--hibakiváltás
raiserror('Ez itt egy hiba',16,0)

raiserror('Ez itt egy hiba %s - %d',16,0, 'ABC',123)

raiserror('Ez itt egy hiba %s - %d',16,0, 'ABC',123) with nowait

raiserror('Ez itt egy hiba',25,2) with log -- ilyen magas severity level-nél a kapcsolat is megszûnik

-- jobb egérgomb a query ablakon -> Query Option -> Execution time-out: 5 s (pl.)
begin transaction

waitfor delay '00:00:10' --ez timeout-al kilép, tranzakció rollback
