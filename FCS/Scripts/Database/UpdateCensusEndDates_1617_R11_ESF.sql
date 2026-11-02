-- update census end dates for 1617 R11 ESF
BEGIN TRANSACTION
	DECLARE @oldCensusDate DATETIME = '2017-07-13 22:00'
	DECLARE @newCensusDate DATETIME = '2017-07-09 22:00'
	DECLARE @fundingStreamPeriod nvarchar(20) = 'ESF1420'

	-- select before
	SELECT * FROM PaymentGeneration.PaymentTimetable WHERE CensusEndDate = @oldCensusDate AND FundingStreamPeriodCode = @fundingStreamPeriod
	SELECT * FROM PolicyCache.PolicyFundingStreamCensusDate WHERE CensusDate = @oldCensusDate AND FundingStreamPeriod = @fundingStreamPeriod

	-- update
	UPDATE PaymentGeneration.PaymentTimetable SET CensusEndDate = @newCensusDate WHERE CensusEndDate = @oldCensusDate AND FundingStreamPeriodCode = @fundingStreamPeriod
	UPDATE PolicyCache.PolicyFundingStreamCensusDate SET CensusDate = @newCensusDate WHERE CensusDate = @oldCensusDate AND FundingStreamPeriod = @fundingStreamPeriod

	-- select after for old and new dates
	SELECT * FROM PaymentGeneration.PaymentTimetable WHERE CensusEndDate = @oldCensusDate AND FundingStreamPeriodCode = @fundingStreamPeriod
	SELECT * FROM PolicyCache.PolicyFundingStreamCensusDate WHERE CensusDate = @oldCensusDate AND FundingStreamPeriod = @fundingStreamPeriod

	SELECT * FROM PaymentGeneration.PaymentTimetable WHERE CensusEndDate = @newCensusDate AND FundingStreamPeriodCode = @fundingStreamPeriod
	SELECT * FROM PolicyCache.PolicyFundingStreamCensusDate WHERE CensusDate = @newCensusDate AND FundingStreamPeriod = @fundingStreamPeriod
ROLLBACK
--COMMIT
