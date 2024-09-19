
drop table if exists #ProductCategory
SELECT list.* 
INTO #ProductCategory
FROM (
VALUES
-- ProductSubCategoryID  ProductSubCategoryName  ProductCategoryID  ProductCategoryName  
  (1,                    N'Mountain Bikes',      1,                 N'Bikes'           ),
  (2,                    N'Road Bikes',          1,                 N'Bikes'           ),
  (3,                    N'Touring Bikes',       1,                 N'Bikes'           ),
  (4,                    N'Handlebars',          2,                 N'Components'      ),
  (5,                    N'Bottom Brackets',     2,                 N'Components'      ),
  (6,                    N'Brakes',              2,                 N'Components'      ),
  (7,                    N'Chains',              2,                 N'Components'      ),
  (8,                    N'Cranksets',           2,                 N'Components'      ),
  (9,                    N'Derailleurs',         2,                 N'Components'      ),
  (10,                   N'Forks',               2,                 N'Components'      ),
  (11,                   N'Headsets',            2,                 N'Components'      ),
  (12,                   N'Mountain Frames',     2,                 N'Components'      ),
  (13,                   N'Pedals',              2,                 N'Components'      ),
  (14,                   N'Road Frames',         2,                 N'Components'      ),
  (15,                   N'Saddles',             2,                 N'Components'      ),
  (16,                   N'Touring Frames',      2,                 N'Components'      ),
  (17,                   N'Wheels',              2,                 N'Components'      ),
  (18,                   N'Bib-Shorts',          3,                 N'Clothing'        ),
  (19,                   N'Caps',                3,                 N'Clothing'        ),
  (20,                   N'Gloves',              3,                 N'Clothing'        ),
  (21,                   N'Jerseys',             3,                 N'Clothing'        ),
  (22,                   N'Shorts',              3,                 N'Clothing'        ),
  (23,                   N'Socks',               3,                 N'Clothing'        ),
  (24,                   N'Tights',              3,                 N'Clothing'        ),
  (25,                   N'Vests',               3,                 N'Clothing'        ),
  (26,                   N'Bike Racks',          4,                 N'Accessories'     ),
  (27,                   N'Bike Stands',         4,                 N'Accessories'     ),
  (28,                   N'Bottles and Cages',   4,                 N'Accessories'     ),
  (29,                   N'Cleaners',            4,                 N'Accessories'     ),
  (30,                   N'Fenders',             4,                 N'Accessories'     ),
  (31,                   N'Helmets',             4,                 N'Accessories'     ),
  (32,                   N'Hydration Packs',     4,                 N'Accessories'     ),
  (33,                   N'Lights',              4,                 N'Accessories'     ),
  (34,                   N'Locks',               4,                 N'Accessories'     ),
  (35,                   N'Panniers',            4,                 N'Accessories'     ),
  (36,                   N'Pumps',               4,                 N'Accessories'     ),
  (37,                   N'Tires and Tubes',     4,                 N'Accessories'     )
) AS list([ProductSubCategoryID], [ProductSubCategoryName], [ProductCategoryID], [ProductCategoryName])

--select ProductSubcategoryID from Product -- ez sokszor null

-- a temp táblába is felvittünk egy 0 ID-jű kategóriát
insert into #ProductCategory([ProductSubCategoryID], [ProductSubCategoryName], [ProductCategoryID], [ProductCategoryName])
values(0,'Other',0, 'Other')

select * from #ProductCategory

select list.ProductCategoryName, count(*)
from #ProductCategory list
inner join Product p on isnull(p.ProductSubcategoryID,0) = list.ProductSubCategoryID -- így kapcsoljuk össze a null értékűekkel
group by list.ProductCategoryName

--statikus lekérdezés

--nyers lekérdezés
select list.ProductCategoryName, month(o.OrderDate) as M, od.LineTotal
from #ProductCategory list
inner join Product p on isnull(p.ProductSubcategoryID,0) = list.ProductSubCategoryID
inner join OrderDetail od on od.ProductID = p.ProductID
inner join Orders o on o.OrderID = od.OrderID

-- statikus pivot
select ProductCategoryName, [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
from(
    select list.ProductCategoryName, month(o.OrderDate) as M, od.LineTotal
    from #ProductCategory list
    inner join Product p on isnull(p.ProductSubcategoryID,0) = list.ProductSubCategoryID
    left join OrderDetail od on od.ProductID = p.ProductID --left join hogy megjelenjen az Other kategória
    left join Orders o on o.OrderID = od.OrderID
) s
pivot(sum(LineTotal) for M in([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) p
order by ProductCategoryName


select ProductCategoryName, [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12], [999] -- ha nincs ilyen hónap ott null értékek lesznek
from(
    select list.ProductCategoryName, month(o.OrderDate) as M, od.LineTotal
    from #ProductCategory list
    inner join Product p on isnull(p.ProductSubcategoryID,0) = list.ProductSubCategoryID
    left join OrderDetail od on od.ProductID = p.ProductID --left join hogy megjelenjen az Other kategória
    left join Orders o on o.OrderID = od.OrderID and o.OrderDate > '2014-05-01'  -- plusz feltétel
) s
pivot(sum(LineTotal) for M in([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12], [999])) p


-- dinamikusan-----------------------------------

declare @RowHeaders nvarchar(max) = 'ProductCategoryName'
declare @ColumnsHeader nvarchar(255) = 'M'
declare @AggFunction nvarchar(100) = 'SUM'
declare @AggColumn nvarchar(255) = 'LineTotal'

--declare @Year int = 2014
declare @SQL nvarchar(max)


set @SQL ='
select list.ProductCategoryName, month(o.OrderDate) as M, od.LineTotal
from #ProductCategory list
inner join Product p on isnull(p.ProductSubcategoryID,0) = list.ProductSubCategoryID
left join OrderDetail od on od.ProductID = p.ProductID --left join hogy megjelenjen az Other kategória
left join Orders o on o.OrderID = od.OrderID
'

-------------------------------
declare @ColumnsSQL nvarchar(max)
declare @Columns nvarchar(max)
--declare @ColumnsTable table(ColumnName nvarchar(255))
declare @ColumnsTable table(ColumnName int) --így egész típusú lesz a ColumnName (könnyebb rá rendezni számérték szerint)

set @ColumnsSQL = '
SELECT DISTINCT ' +  @ColumnsHeader + '
FROM (
' + @SQL +'
) s
'

--print @SQL

insert into @ColumnsTable(ColumnName)
exec(@ColumnsSQL)
--exec sp_executesql @ColumnsSQL, N'@Y int', @Y = @Year --paraméter átadás

--select * from @ColumnsTable

-- vesszővel elválasztott értékek
--select @Columns = isnull(@Columns + ',','') + '[' + ColumnName + ']' from @ColumnsTable order by ColumnName --convert(int,ColumnName) --cast(ColumnName as int)
select @Columns = isnull(@Columns + ',','') + '[' + cast(ColumnName as nvarchar(2)) + ']' from @ColumnsTable order by ColumnName -- egész szám szerint rendezve jó lesz a sorrend
--select @Columns = isnull(@Columns + ',','') + '[' + ColumnName + ']' from @ColumnsTable order by convert(int,ColumnName) --cast(ColumnName as int) -- így csak egy érték kerül bele... ? (karakteres ColumnName esetén)

print @Columns

set @SQL ='
SELECT '+ @RowHeaders + ', ' + @Columns +'
FROM (
 ' +@SQL +'   
) s
PIVOT(' + @AggFunction + '(' + @AggColumn + ') FOR '+  @ColumnsHeader + ' IN ('+ @Columns +')) p
ORDER BY '+ @RowHeaders

print @SQL

exec(@SQL)
--exec sp_executesql @SQL, N'@Y int', @Y = @Year --paraméter átadás




-- véletlen szerű 50% lekérdezése
select top 50 percent *
from Orders
order by newid() --egyedi azonosítókat állít elő véletlenszerűen