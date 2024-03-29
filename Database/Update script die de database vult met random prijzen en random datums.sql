Create View dbo.v_Rand
As
	Select Rand() [rand]
GO

Create Function dbo.f_test
(
	@DateStart	Date
	,@DateEnd	Date
)
Returns Date
As Begin

	Declare @Result Date

	Select	@Result = DateAdd(Day, [Rand] * DateDiff(Day, @DateStart, @DateEnd), @DateStart)
	From	dbo.v_Rand

	Return 	@Result

	
End
Go

DECLARE @StartDate Date ='2019-06-12',
@EndDate Date = '2019-07-01'

UPDATE Voorwerp
SET veiling_gesloten = 0,
startprijs = ABS(CHECKSUM(NEWID()))%10 + 1,
verkoopprijs = NULL,
looptijd_start_datum = CONVERT(date,CURRENT_TIMESTAMP),
looptijd_start_tijd = CONVERT(time,CURRENT_TIMESTAMP), 
looptijd_einde_datum = dbo.f_test(@StartDate,@EndDate),
looptijd_einde_tijd = CONVERT(time,CURRENT_TIMESTAMP),
verzendkosten = 5
WHERE source = 1