
--"Keil,Gage,Amland,Emmanuel,Gates,Koch,Bourne,Colvin,Chambers,Ruth,Benson,Ray,West"

select 'Keil,Gage,Amland,Emmanuel,Gates,Koch,Bourne,Colvin,Chambers,Ruth,Benson,Ray,West'

select * from string_split('Keil,Gage,Amland,Emmanuel,Gates,Koch,Bourne,Colvin,Chambers,Ruth,Benson,Ray,West',',')


-- közvetlen string_split-el
select *
from string_split('Keil,Gage,Amland,Emmanuel,Gates,Koch,Bourne,Colvin,Chambers,Ruth,Benson,Ray,West',',') s 
inner join Customer c on c.LastName = s.value

--ideiglenes temp táblákkal
drop table if exists #nevek
select value as Nev
into #nevek
from string_split('Keil,Gage,Amland,Emmanuel,Gates,Koch,Bourne,Colvin,Chambers,Ruth,Benson,Ray,West',',') s 

select c.* from #nevek s
inner join Customer c on c.LastName = s.Nev