begin try --ebben a blokkban kell utasításnak lennie

	set identity_insert dbo.Product on

	insert into dbo.Product([ProductID], [ProductName], [ListPrice], [Color], [Size], [CreatedDate], [ProductNumber], [StandardCost], [Status])
	select top 1 * from dbo.Product

	set identity_insert dbo.Product off

end try
begin catch --ez a blokk lehet üres is: elnyelem a hibát
	select @@error
	select error_number(),error_message()
	print concat('error_number:',error_number(),'error_message:',error_message(),'severity:', error_severity())
end catch
go

begin try
	select 1/0
end try
begin catch
end catch
go

begin try
	select 1/0
end try
begin catch
SELECT ERROR_NUMBER() AS ErrorNumber, 
ERROR_SEVERITY() AS ErrorSeverity, 
ERROR_STATE() AS ErrorState, 
ERROR_PROCEDURE() AS ErrorProcedure,
ERROR_LINE() AS ErrorLine,
ERROR_MESSAGE() AS ErrorMessage; 
end catch
go