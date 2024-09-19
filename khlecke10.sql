select *
from (
    values(1645.00),
    (1200.00),
    (1101.00),
    (1531.00),
    (1965.00),
    (271320.00),
    (1220.00),
    (1234.00),
    (1312.00),
    (1436.00)
) data(value)


select avg(value) --számtani átlag
from (
    values(1645.00),
    (1200.00),
    (1101.00),
    (1531.00),
    (1965.00),
    (271320.00), --túl nagy szám a többihez képest
    (1220.00),
    (1234.00),
    (1312.00),
    (1436.00)
) data(value)

--mértani átlag (rendezett értékek közepéből vett számtani átlag...)
select value,percentile_cont(0.5) within group (order by value) over() -- minden sorra lefut
from (
    values(1645.00),
    (1200.00),
    (1101.00),
    (1531.00),
    (1965.00),
    (271320.00),
    (1220.00),
    (1234.00),
    (1312.00),
    (1436.00)
) data(value)


select value,percentile_cont(0.1) within group (order by value) over() -- ez 10 %-nál (0.1) szúr be
from (
    values(1645.00),
    (1200.00),
    (1101.00),
    (1531.00),
    (1965.00),
    (271320.00),
    (1220.00),
    (1234.00),
    (1312.00),
    (1436.00)
) data(value)

-- egy szám distinct-el
select distinct percentile_cont(0.5) within group (order by value) over()
from (
    values(1645.00),
    (1200.00),
    (1101.00),
    (1531.00),
    (1965.00),
    (271320.00),
    (1220.00),
    (1234.00),
    (1312.00),
    (1436.00)
) data(value)


-- egymás mellett a mértani és a számtani átlag
select distinct
    percentile_cont(0.5) within group (order by value) over(),
    avg(value) over()
from (
    values(1645.00),
    (1200.00),
    (1101.00),
    (1531.00),
    (1965.00),
    (271320.00),
    (1220.00),
    (1234.00),
    (1312.00),
    (1436.00)
) data(value)


--zajszűrés (hibás értékek kiszűrése) (0,túl nagy értékek)

with data as (
    select *
    from(
        values
        (01,1645.00),
        (02,0.00),
        (03,1101.00),
        (04,1531.00),
        (05,1965.00),
        (06,271320.00),
        (07,1220.00),
        (08,1234.00),
        (09,1312.00),
        (010,1436.00),
        (011,1721.00),
        (012,1111.00),
        (013,1005.00),
        (014,1329.00),
        (015,1789.00),
        (016,1333.00),
        (017,1687.00),
        (018,1222.00),
        (019,1707.00),
        (020,0.00)
    ) date(id,value)
),
limits as(
    select distinct
        percentile_cont(0.10) within group (order by value) over() lo_limit,
        percentile_cont(0.90) within group (order by value) over() hi_limit
    from data
)
select data.*
from data, limits
where data.[value] between limits.lo_limit and limits.hi_limit