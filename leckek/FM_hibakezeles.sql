--by Mate Farkas
create or alter function dbo.fn_get_error_info()
returns nvarchar(max)
begin


return (
    select cast(sign(error_number()) as bit) as [ERROR],
           error_message()                   as [ERROR_MESSAGE], 
           error_number()                    as [ERROR_NUMBER],
           error_severity()                  as [ERROR_SEVERITY],
           error_state()                     as [ERROR_STATE],
           error_line()                      as [ERROR_LINE],
           error_procedure()                 as [ERROR_PROCEDURE],
           xact_state()                      as [XACT_STATE],
           @@trancount                       as [TRANCOUNT],
           getdate()                         as [GETDATE]
    for json path, without_array_wrapper
)


end
go

--Let's use it

begin catch

--save error information before rollback
declare @E nvarchar(max) = dbo.fn_get_error_info();

--rollback current transaction
if @@TRANCOUNT > 1 rollback transaction;

--log error into a table
insert ErrorLog([error_num],[error_proc],[error_message])
values(JSON_VALUE(@E,'$.ERROR_NUMBER'),JSON_VALUE(@E,'$.ERROR_PROCEDURE'),JSON_VALUE(@E,'$.ERROR_MESSAGE'));

end catch

/*
 This way you can pack all error related information into a simple variable which can be saved directly into a log table or you can extract each information one by one if you want.

This function can be placed into master database and can be used globally in every database. 
*/