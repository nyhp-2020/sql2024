--ufnMax

create or alter function ufnMax(
		@value0 int = null,
		@value1 int = null,
		@value2 int = null,
		@value3 int = null,
		@value4 int = null,
		@value5 int = null,
		@value6 int = null,
		@value7 int = null,
		@value8 int = null,
		@value9 int = null
)
returns int
as
begin
declare @result int

-- set @result = case when @value0 > @value1 then @value0 else @value1 end

select @result = max(v)
from (
		  select @value0
union all select @value1
union all select @value2
union all select @value3
union all select @value4
union all select @value5
union all select @value6
union all select @value7
union all select @value8
union all select @value9

/*
values(@value0),
	  (@value1),
	  (@value2),
	  (@value3),
	  (@value4),
	  (@value5),
	  (@value6),
	  (@value7),
	  (@value8),
	  (@value9)
*/
) value_list(v)

--select @result
return @result
end
go

select dbo.ufnMax(999,156,658,null,null,null,null,null,null,165)
select dbo.ufnMax(999,156,658,default,default,default,default,default,default,165)

go

create or alter function ufnMin(
		@value0 int = null,
		@value1 int = null,
		@value2 int = null,
		@value3 int = null,
		@value4 int = null,
		@value5 int = null,
		@value6 int = null,
		@value7 int = null,
		@value8 int = null,
		@value9 int = null
)
returns int
as
begin
declare @result int


select @result = min(v)
from (
		  select @value0
union all select @value1
union all select @value2
union all select @value3
union all select @value4
union all select @value5
union all select @value6
union all select @value7
union all select @value8
union all select @value9

/*
values(@value0),
	  (@value1),
	  (@value2),
	  (@value3),
	  (@value4),
	  (@value5),
	  (@value6),
	  (@value7),
	  (@value8),
	  (@value9)
*/
) value_list(v)

--select @result
return @result
end
go

select dbo.ufnMin(999,156,658,null,null,null,null,null,null,165)
select dbo.ufnMin(999,156,658,default,default,default,default,default,default,165)

--ld greatest,least fv. az SQL 2022-ben