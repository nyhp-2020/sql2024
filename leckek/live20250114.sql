drop table #temp
select top 10 identity(int, 1, 1) Sorrend, *  --automatikus sorsz�m
into #temp
from Country
order by CountryName desc

alter table #temp add primary key (Sorrend) -- index l�trehoz�s (nagy t�bl�kra aj�nlott!)

--select * from #temp

declare @x int = 0

--kurzoros megold�s
declare @c cursor
set @c = cursor static for --ez is l�trehoz egy temp t�bl�t a h�tt�rben
select * from #temp

--v�gigmegy a t�bla sorain (kurzor helyett)
while (1 = 1)
begin
	select top 1  @x = Sorrend
	from #temp
	where Sorrend > @x --ha van index, nem kell az eg�sz t�bl�t v�gigolvasni
	order by Sorrend

	--ez ugraszt ki a v�gtelen ciklusb�l
	if @@ROWCOUNT = 0 break

	--TODO
	print @x
end

select @x