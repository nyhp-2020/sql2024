--ufnCapitalize

create or alter function ufnCapitalize(
--declare @string nvarchar(1000) = '     dR. KISS,=    JÁnos   *'
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

--közbensõ szóközök rövidítése
set @string = replace(@string,'      ',' ')
set @string = replace(@string,'     ',' ')
set @string = replace(@string,'    ',' ')
set @string = replace(@string,'   ',' ')
set @string = replace(@string,'  ',' ')

--nyitó, záró szóközök levágása
set @string = ltrim(rtrim(@string))

--select * from string_split(@string, ' ')

--nagy kezdõbetû a szavakban, többi kicsi
select @result = @result + ' ' + upper(left(value,1)) + lower(right(value,len(value)-1)) 
from string_split(@string, ' ')

set @result = stuff(@result,1,1,'') -- az elsõ helyrõl,egyet, ''-re cserél (kezdõ szóköz)

--select @string

--select @result
return @result

end
go

select dbo.ufnCapitalize('     dR. KISS,=    JÁnos   *')