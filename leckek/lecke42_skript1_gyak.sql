--aktuális év minden hónapja
declare @EvEleje date,
        @EvVege date,
        @datum date,
        @sorszam int = 1,
        @utolsonap date,
        @szokonap date,
        --@ma date = getdate()
        @ma date = '2020-02-07'

set @EvEleje = DATEFROMPARTS(year(@ma),1,1)
set @EvVege = DATEFROMPARTS(year(@ma),12,31)
set @datum = @EvEleje

set @szokonap = DATEFROMPARTS(year(@ma),3,1)
set @szokonap = dateadd(day,-1,@szokonap)

while @datum < @EvVege
begin 

    --set @utolsonap = DATEFROMPARTS(year(@datum),month(@datum)+1,1)

    --set @utolsonap = dateadd(month,1,@datum)
    --set @utolsonap = dateadd(day,-1,@utolsonap)

    if day(@szokonap) = 29 and month(@datum) = 1
        BEGIN
        set @utolsonap = EOMONTH(dateadd(month,1,@datum))
        print concat(@sorszam,' - Első nap=', @datum, ', Utolsó nap=',@utolsonap)
        set @datum = dateadd(month, 2, @datum)
        --set @sorszam += 1
        END
    else
    BEGIN
    set @utolsonap = EOMONTH(@datum)

    print concat(@sorszam,' - Első nap=', @datum, ', Utolsó nap=',@utolsonap)
    set @datum = dateadd(month, 1, @datum)
    --set @sorszam += 1

    END

    set @sorszam += 1
end