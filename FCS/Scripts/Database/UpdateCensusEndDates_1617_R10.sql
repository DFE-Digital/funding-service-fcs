-- update census end dates for 1617 R10 collection
BEGIN TRANSACTION
	DECLARE @oldCensusDate DATETIME = '2017-06-07 22:00'
	DECLARE @newCensusDate DATETIME = '2017-06-08 11:00'

	-- select before
	SELECT * FROM PaymentGeneration.PaymentTimetable WHERE CensusEndDate = @oldCensusDate
	SELECT * FROM PolicyCache.PolicyFundingStreamCensusDate WHERE CensusDate = @oldCensusDate

	-- update
	UPDATE PaymentGeneration.PaymentTimetable SET CensusEndDate = @newCensusDate WHERE CensusEndDate = @oldCensusDate
	UPDATE PolicyCache.PolicyFundingStreamCensusDate SET CensusDate = @newCensusDate WHERE CensusDate = @oldCensusDate

	-- select after for old and new dates
	SELECT * FROM PaymentGeneration.PaymentTimetable WHERE CensusEndDate = @oldCensusDate
	SELECT * FROM PolicyCache.PolicyFundingStreamCensusDate WHERE CensusDate = @oldCensusDate

	SELECT * FROM PaymentGeneration.PaymentTimetable WHERE CensusEndDate = @newCensusDate
	SELECT * FROM PolicyCache.PolicyFundingStreamCensusDate WHERE CensusDate = @newCensusDate
ROLLBACK
--COMMIT
