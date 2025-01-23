use MyDB
go
create or alter procedure uspLogError
as
if @@error <> 0 and error_procedure() is not null
	insert into dbo.ErrorLog([Date],ErrorNumber,[Procedure],ErrorLine,ErrorMessage,UserName)
	select
	getdate() as [Date],
	error_number() as ErrorNumber,
	error_procedure() as ErrorProcedure,
	error_line() as ErrorLine,
	error_message() as ErrorMessage,
	suser_name() as UserName
go

uspLogError
go

BEGIN TRY  
    -- Generate a divide-by-zero error.  
    SELECT 1/0;  
END TRY  
BEGIN CATCH  
	exec uspLogError
END CATCH;
go