CREATE PROCEDURE [dbo].[uspSearchCandidateResumes]
    @searchString [nvarchar](1000),   
    @useInflectional [bit]=0,
    @useThesaurus [bit]=0,
    @language[int]=0


WITH EXECUTE AS CALLER
AS
--...
/*
Ennek az elj�r�snak egy k�telez� �s h�rom elhagyhat� (alap�rtelmezett) param�tere van.
*/