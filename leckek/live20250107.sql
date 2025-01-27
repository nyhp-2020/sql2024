--ld update() f�ggv�ny
--ld
columns_updated() --nincs param�tere, bitsorozattal t�r vissza: 1 m�dos�tott�k, 0 nem m�dos�tott�k

substr(columns_updated(),1,1) -- a substr f�ggv�nnyel egy bin�ris byte t�mbb�l is kivehet�nk byte-okat

--audit�l�s: ki, mikor, mit m�dos�tott mir�l, mire

--bit �sszehasonl�t�s
select 123 & 1
select 1 & 1
select 2 & 1
select 3 & 1

select 2 & 2

select 3 & 3


--hibakiv�lt�s
raiserror('Ez itt egy hiba',16,0)

raiserror('Ez itt egy hiba %s - %d',16,0, 'ABC',123)

raiserror('Ez itt egy hiba %s - %d',16,0, 'ABC',123) with nowait

raiserror('Ez itt egy hiba',25,2) with log -- ilyen magas severity level-n�l a kapcsolat is megsz�nik

-- jobb eg�rgomb a query ablakon -> Query Option -> Execution time-out: 5 s (pl.)
begin transaction

waitfor delay '00:00:10' --ez timeout-al kil�p, tranzakci� rollback
