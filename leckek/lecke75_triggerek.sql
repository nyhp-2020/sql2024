--trigger (esem�nykezel�, spec. t�rolt elj�r�s)
--l�trehoz�s
CREATE TRIGGER [ddlDatabaseTriggerLog] ON DATABASE 
FOR DDL_DATABASE_LEVEL_EVENTS AS --kiv�lt� esem�ny

--Sequences sorsz�m gener�l�k
--h�v�s WideWorldImporters AB-n
select next value for [Sequences].[BuyingGroupID] --egyre nagyobb sz�mot ad