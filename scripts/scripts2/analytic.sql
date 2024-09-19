select distinct 
    percentile_cont(0.5) within group (order by value) over(),
    avg(value) over()
from (
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
) data(value)


with data as (
    select *
    from (
        values
            (01, 1645.00),
            (02, 0.00),
            (03, 1101.00),
            (04, 1531.00),
            (05, 1965.00),
            (06, 271320.00),
            (07, 1220.00),
            (08, 1234.00),
            (09, 1312.00),
            (10, 1436.00),
            (11, 1721.00),
            (12, 1111.00),
            (13, 1005.00),
            (14, 1329.00),
            (15, 1789.00),
            (16, 1333.00),
            (17, 1687.00),
            (18, 1222.00),
            (19, 1707.00),
            (20, 0.00)
    ) data(id,value)
),
limits as (
    select distinct
        PERCENTILE_CONT(0.10) within group (order by value) over() lo_limit,
        PERCENTILE_CONT(0.90) within group (order by value) over() hi_limit
    from data
)
select data.* 
from data, limits
where data.[value] between limits.lo_limit and limits.hi_limit
