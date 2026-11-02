select *
from PaymentGeneration.PaymentTimetable
where FundingStreamPeriodCode in ('DADA2122','AEBC-19TRN2122','AEBC-ASCL2122','AEBC-NSF2122','ALLBC2122')
and CalendarPeriod = '202201'

-- NotStarted

Select *
from OverrideDate.OverrideDate
