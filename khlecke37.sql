
declare @EvEleje date,
        @EvVege date,
        @datum date,
        @sorszam int = 1,
        @utolsonap date,
        @szokonap date

set @EvEleje = DATEFROMPARTS(year(getdate()),1,1)
set @EvVege = DATEFROMPARTS(year(getdate()),12,31)
set @datum = @EvEleje

set @szokonap = DATEFROMPARTS(year(getdate()),3,1)
set @szokonap = dateadd(day, -1, @szokonap)

while (@datum <= @EvVege)
    begin
    
    --set @utolsonap = DATEFROMPARTS(year(@datum),month(@datum) + 1,1)

    --set @utolsonap = dateadd(month, 1, @datum)
    --set @utolsonap = dateadd(day, -1, @utolsonap)

    if day(@szokonap) = 29 and month(@datum) = 1  -- szökőévben összevonjuk a januárt és a februárt
        begin 
            set @utolsonap = eomonth(dateadd(month, 1,@datum))
            print concat(@sorszam,' - Első nap=', @datum,', Utolsó nap=', @utolsonap)
            set @datum = dateadd(month, 2, @datum)
            set @sorszam += 1
        end 
    else 
        begin
            set @utolsonap = eomonth(@datum) -- end of month
            print concat(@sorszam,' - Első nap=', @datum,', Utolsó nap=', @utolsonap)
            set @datum = dateadd(month, 1, @datum)
            set @sorszam += 1
        end 
    end 

print @EvEleje
print @EvVege