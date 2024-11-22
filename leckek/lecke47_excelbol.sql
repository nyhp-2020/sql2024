--Excel-ből egy SQL kód -> futtatás SQL szerveren
--ExcelTools.xlam ehhez nyújt segítséget
--Letöltés: gitgub.com/farkas-mate/Excel  --itt elérhetők lesznek a frissítések is
--ProductCategory.xlsx  példafile
--Hely C:\Users\<Felhasználó>\AppData\Roaming\Microsoft\Excel\XLStart
--A makrókat engedélyezni kell az excelben rákérdezéses módon

drop table if exists #list

SELECT list.* 
into #list
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


--
select * from #list  --létrejött


--egyes fő kategóriákban hány termék van
select list.ProductCategoryName, count(*)  --sorokat számol
from #list list 
inner join Product p on p.ProductSubcategoryID = list.ProductSubCategoryID
group by list.ProductCategoryName