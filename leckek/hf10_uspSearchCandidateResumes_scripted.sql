CREATE PROCEDURE [dbo].[uspSearchCandidateResumes]
    @searchString [nvarchar](1000),   
    @useInflectional [bit]=0,
    @useThesaurus [bit]=0,
    @language[int]=0


WITH EXECUTE AS CALLER
AS
--...
/*
Ennek az eljárásnak egy kötelező és három elhagyható (alapértelmezett) paramétere van.
*/