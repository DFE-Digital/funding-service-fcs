BEGIN TRANSACTION
	SELECT * FROM PaymentGeneration.PaymentTimetable WHERE CensusEndDate BETWEEN '2016-12-08' AND '2016-12-09'
	SELECT * FROM PolicyCache.PolicyFundingStreamCensusDate WHERE CensusDate BETWEEN '2016-12-08' AND '2016-12-09'

	UPDATE PaymentGeneration.PaymentTimetable SET CensusEndDate = '2016-12-09 14:00' WHERE CensusEndDate BETWEEN '2016-12-08' AND '2016-12-09'
	UPDATE PolicyCache.PolicyFundingStreamCensusDate SET CensusDate = '2016-12-09 14:00' WHERE CensusDate BETWEEN '2016-12-08' AND '2016-12-09'

	SELECT * FROM PaymentGeneration.PaymentTimetable WHERE CensusEndDate BETWEEN '2016-12-09' AND '2016-12-10'
	SELECT * FROM PolicyCache.PolicyFundingStreamCensusDate WHERE CensusDate BETWEEN '2016-12-09' AND '2016-12-10'
ROLLBACK
--COMMIT