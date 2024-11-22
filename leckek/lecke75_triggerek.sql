--trigger (eseménykezelõ, spec. tárolt eljárás)
--létrehozás
CREATE TRIGGER [ddlDatabaseTriggerLog] ON DATABASE 
FOR DDL_DATABASE_LEVEL_EVENTS AS --kiváltó esemény

--Sequences sorszám generálók
--hívás WideWorldImporters AB-n
select next value for [Sequences].[BuyingGroupID] --egyre nagyobb számot ad