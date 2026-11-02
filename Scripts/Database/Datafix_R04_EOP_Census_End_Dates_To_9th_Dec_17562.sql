BEGIN TRAN

UPDATE PaymentGeneration.PaymentTimetable
SET 
Status = 'NotStarted', 
CensusEndDate = '2016-12-09 22:00:00.000'
WHERE FundingStreamPeriodCode = 'EOP1517' AND CalendarPeriod = '201611'

SELECT * FROM PaymentGeneration.PaymentTimetable
WHERE FundingStreamPeriodCode = 'EOP1517' AND CalendarPeriod = '201611'

UPDATE PolicyCache.PolicyFundingStreamCensusDate
SET CensusDate = '2016-12-09 22:00:00.000'
WHERE FundingStreamPeriod = 'EOP1517' AND CalendarYear = 2016 AND CalendarPeriod = 11

SELECT * FROM PolicyCache.PolicyFundingStreamCensusDate
WHERE FundingStreamPeriod = 'EOP1517' AND CalendarYear = 2016 AND CalendarPeriod = 11

ROLLBACK TRAN