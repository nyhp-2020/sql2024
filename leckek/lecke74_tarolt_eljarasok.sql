--t�rolt elj�r�st csak futtatni lehet,b�rmit meg lehet csin�lni
--t�rolt elj�r�s h�v�s
EXECUTE [dbo].[uspGetEmployeeManagers] 10 --egy dolgoz�nak ki a felettese

select * from Humanresources.Employee

select * from  Person.Person where BusinessEntityID = 10

--t�rolt elj�r�s l�trehoz�sa
CREATE PROCEDURE [dbo].[uspGetManagerEmployees]
    @BusinessEntityID [int]
AS

GO

-- t�rolt elj�r�s m�dos�t�sa
ALTER PROCEDURE [dbo].[uspGetManagerEmployees]
    @BusinessEntityID [int]
AS

GO
--t�rolt elj�r�s l�trehoz�sa v. m�dos�t�sa
CREATE OR ALTER PROCEDURE [dbo].[uspGetManagerEmployees]
    @BusinessEntityID [int]
AS

GO