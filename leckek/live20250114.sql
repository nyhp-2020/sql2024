drop table #temp
select top 10 identity(int, 1, 1) Sorrend, *  --automatikus sorszám
into #temp
from Country
order by CountryName desc

alter table #temp add primary key (Sorrend) -- index létrehozás (nagy táblákra ajánlott!)

--select * from #temp

declare @x int = 0

--kurzoros megoldás
declare @c cursor
set @c = cursor static for --ez is létrehoz egy temp táblát a háttérben
select * from #temp

--végigmegy a tábla sorain (kurzor helyett)
while (1 = 1)
begin
	select top 1  @x = Sorrend
	from #temp
	where Sorrend > @x --ha van index, nem kell az egész táblát végigolvasni
	order by Sorrend

	--ez ugraszt ki a végtelen ciklusból
	if @@ROWCOUNT = 0 break

	--TODO
	print @x
end

select @x