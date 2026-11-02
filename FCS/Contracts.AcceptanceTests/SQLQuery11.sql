select *
from PaymentGeneration.PaymentTimetable
where FundingStreamPeriodCode in ('DADA2122','AEBC-19TRN2122','AEBC-ASCL2122','AEBC-NSF2122','ALLBC2122')
and CalendarPeriod = '202203'

-- NotStarted

Select *
from OverrideDate.OverrideDate

--Update OverrideDate.OverrideDate
--set SystemOverrideDate = '2022-03-05'
