--tárolt eljárást csak futtatni lehet,bármit meg lehet csinálni
--tárolt eljárás hívás
EXECUTE [dbo].[uspGetEmployeeManagers] 10 --egy dolgozónak ki a felettese

select * from Humanresources.Employee

select * from  Person.Person where BusinessEntityID = 10

--tárolt eljárás létrehozása
CREATE PROCEDURE [dbo].[uspGetManagerEmployees]
    @BusinessEntityID [int]
AS

GO

-- tárolt eljárás módosítása
ALTER PROCEDURE [dbo].[uspGetManagerEmployees]
    @BusinessEntityID [int]
AS

GO
--tárolt eljárás létrehozása v. módosítása
CREATE OR ALTER PROCEDURE [dbo].[uspGetManagerEmployees]
    @BusinessEntityID [int]
AS

GO