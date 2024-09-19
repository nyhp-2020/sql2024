-- 3. Keressük ki azokat a vásárlókat, amelyek utóneve a következő listában van:
--"Keil,Gage,Amland,Emanuel,Gates,Koch,Bourne,Colvin,Chambers,Ruth,Benson,Ray,West"

-- a lista szövegének visszaadása egy mezőben
select 'Keil,Gage,Amland,Emanuel,Gates,Koch,Bourne,Colvin,Chambers,Ruth,Benson,Ray,West'
-- szöveg feldarabolása és visszaadása külön sorokban
select * from string_split('Keil,Gage,Amland,Emanuel,Gates,Koch,Bourne,Colvin,Chambers,Ruth,Benson,Ray,West',',')

--közvetlen string_split-el
select *
from string_split('Keil,Gage,Amland,Emanuel,Gates,Koch,Bourne,Colvin,Chambers,Ruth,Benson,Ray,West',',') s
inner join Customer c on c.LastName = s.value -- a string_split fv. által visszaadott oszlop sorértékét így hivatkozzuk

-- ideiglenes tábla létrehozása
drop table if exists #nevek

select value as Nev
into #nevek
from string_split('Keil,Gage,Amland,Emanuel,Gates,Koch,Bourne,Colvin,Chambers,Ruth,Benson,Ray,West',',') s
-- a string_split() függvény egy táblával tér vissza

select * from #nevek

-- ideiglenes táblával
select *
from #nevek s
inner join Customer c on c.LastName = s.Nev