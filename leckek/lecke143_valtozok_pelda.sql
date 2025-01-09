--ufnCapitalize

create or alter function ufnCapitalize(
--declare @string nvarchar(1000) = '     dR. KISS,=    J�nos   *'
@string nvarchar(1000)
)
returns nvarchar(1000)
as
begin
declare @result nvarchar(1000) = ''

--select replace(@string,'  ',' ')

set @string = translate(@string,'+/*,:;_=%!"','           ') --SQL 2017

set @string = replace(@string,',',' ')
set @string = replace(@string,':',' ')
set @string = replace(@string,';',' ')

--k�zbens� sz�k�z�k r�vid�t�se
set @string = replace(@string,'      ',' ')
set @string = replace(@string,'     ',' ')
set @string = replace(@string,'    ',' ')
set @string = replace(@string,'   ',' ')
set @string = replace(@string,'  ',' ')

--nyit�, z�r� sz�k�z�k lev�g�sa
set @string = ltrim(rtrim(@string))

--select * from string_split(@string, ' ')

--nagy kezd�bet� a szavakban, t�bbi kicsi
select @result = @result + ' ' + upper(left(value,1)) + lower(right(value,len(value)-1)) 
from string_split(@string, ' ')

set @result = stuff(@result,1,1,'') -- az els� helyr�l,egyet, ''-re cser�l (kezd� sz�k�z)

--select @string

--select @result
return @result

end
go

select dbo.ufnCapitalize('     dR. KISS,=    J�nos   *')