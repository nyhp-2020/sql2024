set datefirst 1 --h�tf� a kezd�nap

declare @dayofweek int = datepart(weekday,'2025-02-23')
select @dayofweek

declare @weekofyear int = datepart(week,'2025-02-24')
select @weekofyear