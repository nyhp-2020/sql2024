--string_agg sztringeket fűz össze
select Country, string_agg(cast(City as nvarchar(max)),';')
from Customer
group by Country