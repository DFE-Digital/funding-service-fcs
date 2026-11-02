UPDATE  [PaymentGeneration].[PaymentTimetable]
set CensusEndDate = '2019-12-10 22:00'
  where CensusEndDate = '2019-12-09 22:00';

UPDATE PolicyCache.PolicyFundingStreamCensusDate SET CensusDate = '2019-12-10 22:00' WHERE CensusDate = '2019-12-09 22:00';