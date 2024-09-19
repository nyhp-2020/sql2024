declare @SQL nvarchar(max)

set @SQL = 'SELECT OrderID FROM Orders' --Belső sql (dinamikus)

exec(@SQL)