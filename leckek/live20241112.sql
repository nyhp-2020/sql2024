select *
from OrderDetail
where OrderID = 43662
and ProductID = 766
and OrderQty = 1


select *
from OrderDetail with (index = PK_OrderDetail)
where OrderID = 43662
and ProductID = 766
and OrderQty = 1

--subquery-kkel
select *
from(
    SELECT *
    from(
        select *
        from OrderDetail --with (index = PK_OrderDetail)
        where OrderID = 43662
    ) a
    where ProductID = 766
) b
where  OrderQty = 1

--index létrehozás
/*
alter table OrderDetail
    add constraint PK_OrderDetail primary KEY(OrderDetailID, OrderID)
*/

-- create index ix_OrderDetail_OrderID on OrderDetail(OrderID)


declare @File varchar(2000)
set @File = format(getdate() - 100, 'yyyy_MM_dd')

set @File = format(getdate() - 100, 'yyyy_M_d')


select @File

-- dinamikus sql paraméterek
declare @SQL nvarchar(max) ='
select @a, @b
set @c = getdate()
'

declare @output datetime
exec sp_executesql
    -- első rész
    @stmt = @SQL,
    -- második rész    
    @params = N'@a int, @b varchar(100), @c datetime output', --belül is jelöljük az output változót
    --harmadik rész
    @a = 10,
    @b = 'ABC',
    @c = @output output  -- itt definiáljuk, hogy output változó

    select @output
