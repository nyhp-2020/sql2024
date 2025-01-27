-- rekurzív cte (max 100 a rekurzió mértéke alap esetben)
with cte as(
	select 1 Num
	union all
	select Num + 1 from cte
	where Num < 50  --így lehet kilépni
)
select * from cte
option (maxrecursion 110) --max 32767-ig lehet emelni (alapértelmezetten ez 100)

-- hierarchia felderítés, konkrét adatbázisra futtatjuk
select * from sys.sql_dependencies

-- object_id
select  distinct object_id from sys.sql_dependencies


--ez egyelõre nem mûködik jól...
with obj as (
	select  distinct object_id from sys.sql_dependencies
	union all
	select d.referenced_major_id
	from sys.sql_dependencies d
	join obj o on o.object_id = d.referenced_major_id
)
select *
from obj
option (maxrecursion 1000)


select * from sys.sql_expression_dependencies


--rekurzió pl hierarhia szintekre

-- rekurzív cte replace-lésre

/*
drop table if exists #temp
select cast (Name as nvarchar(100)) as Name
into #temp
from(
	values('ABCASDASDGFSD'),
		('CCC'),
		('_ABC'),
		('AAAAAAAAA_FFFFF'),
		('C_B_A')
) list (Name)

*/

--select Name,replace(replace(replace(Name, 'A', ''), 'B',''), 'C', '')
--from #temp 

select * from #temp

declare @chars nvarchar(1000) = 'ABC';
declare @length int = len(@chars) + 1;

with CTE as(
select Name, Name as txt, @length as id from #temp
union all
select Name, cast(replace(txt, substring(@chars, id -1 , 1), '') as nvarchar(100)) as txt, id - 1 as id from CTE where id > 0
)
select Name, txt,id
from CTE
where id = 0