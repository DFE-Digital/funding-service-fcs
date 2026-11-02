
INSERT INTO FundingAllocation.FeedRead
    (CfsReadCompletedDate, JobCompletedDate)
VALUES
    (GETUTCDATE(), GETUTCDATE())

DECLARE @readId int = SCOPE_IDENTITY()

INSERT INTO FundingAllocation.FundingAllocationPageControl
    (ReadId, PageNumber, LatestBookmarkOnPage)
VALUES
    (@readId, 2, '1619-AS-2122-Contracting-LocalAuthority-10024294-1_0')

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10037945-1_0', '1_0', 'AS-2122', '1619', '10037945', 3136285.16, GETUTCDATE(), 1, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10038020-1_0', '1_0', 'AS-2122', '1619', '10038020', 456951.45, GETUTCDATE(), 2, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10042190-1_0', '1_0', 'AS-2122', '1619', '10042190', 1156592.19, GETUTCDATE(), 3, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10042505-1_0', '1_0', 'AS-2122', '1619', '10042505', 201887.22, GETUTCDATE(), 4, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10043208-1_0', '1_0', 'AS-2122', '1619', '10043208', 15432190.69, GETUTCDATE(), 5, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10043571-1_0', '1_0', 'AS-2122', '1619', '10043571', 498840.42, GETUTCDATE(), 6, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10047306-1_0', '1_0', 'AS-2122', '1619', '10047306', 403104.29, GETUTCDATE(), 7, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10048409-1_0', '1_0', 'AS-2122', '1619', '10048409', 714326.96, GETUTCDATE(), 8, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10067528-1_0', '1_0', 'AS-2122', '1619', '10067528', 588294.56, GETUTCDATE(), 9, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10080825-1_0', '1_0', 'AS-2122', '1619', '10080825', 58252.94, GETUTCDATE(), 10, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10082722-1_0', '1_0', 'AS-2122', '1619', '10082722', 528794.1, GETUTCDATE(), 11, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10000350-1_0', '1_0', 'AS-2122', '1619', '10000350', 335187.81, GETUTCDATE(), 12, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10000599-1_0', '1_0', 'AS-2122', '1619', '10000599', 1391205.24, GETUTCDATE(), 13, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10000872-1_0', '1_0', 'AS-2122', '1619', '10000872', 866539.11, GETUTCDATE(), 14, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10000948-2_0', '2_0', 'AS-2122', '1619', '10000948', 27300139.73, GETUTCDATE(), 15, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10001476-2_0', '2_0', 'AS-2122', '1619', '10001476', 24329967.33, GETUTCDATE(), 16, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10001538-1_0', '1_0', 'AS-2122', '1619', '10001538', 58346.26, GETUTCDATE(), 17, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10001867-1_0', '1_0', 'AS-2122', '1619', '10001867', 408959.78, GETUTCDATE(), 18, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10001929-1_0', '1_0', 'AS-2122', '1619', '10001929', 1105366.05, GETUTCDATE(), 19, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10002006-1_0', '1_0', 'AS-2122', '1619', '10002006', 1084928.69, GETUTCDATE(), 20, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10002345-1_0', '1_0', 'AS-2122', '1619', '10002345', 962300.53, GETUTCDATE(), 21, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10002396-1_0', '1_0', 'AS-2122', '1619', '10002396', 1277436.88, GETUTCDATE(), 22, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10002409-1_0', '1_0', 'AS-2122', '1619', '10002409', 1070858.43, GETUTCDATE(), 23, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10002546-1_0', '1_0', 'AS-2122', '1619', '10002546', 269178.58, GETUTCDATE(), 24, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10002560-1_0', '1_0', 'AS-2122', '1619', '10002560', 949868.38, GETUTCDATE(), 25, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10003136-1_0', '1_0', 'AS-2122', '1619', '10003136', 1222241.51, GETUTCDATE(), 26, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10003774-1_0', '1_0', 'AS-2122', '1619', '10003774', 1064854.81, GETUTCDATE(), 27, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10003775-1_0', '1_0', 'AS-2122', '1619', '10003775', 397108.75, GETUTCDATE(), 28, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10003940-1_0', '1_0', 'AS-2122', '1619', '10003940', 1796927.71, GETUTCDATE(), 29, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10004444-1_0', '1_0', 'AS-2122', '1619', '10004444', 233676.87, GETUTCDATE(), 30, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10004502-1_0', '1_0', 'AS-2122', '1619', '10004502', 1139232.9, GETUTCDATE(), 31, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10004527-1_0', '1_0', 'AS-2122', '1619', '10004527', 2416292.08, GETUTCDATE(), 32, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10004665-1_0', '1_0', 'AS-2122', '1619', '10004665', 723290.5, GETUTCDATE(), 33, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10004841-1_0', '1_0', 'AS-2122', '1619', '10004841', 889876.19, GETUTCDATE(), 34, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10005036-1_0', '1_0', 'AS-2122', '1619', '10005036', 563175.1, GETUTCDATE(), 35, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10005151-1_0', '1_0', 'AS-2122', '1619', '10005151', 2363952.12, GETUTCDATE(), 36, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10005320-1_0', '1_0', 'AS-2122', '1619', '10005320', 3557855.1, GETUTCDATE(), 37, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10005557-1_0', '1_0', 'AS-2122', '1619', '10005557', 1899672.67, GETUTCDATE(), 38, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10005558-1_0', '1_0', 'AS-2122', '1619', '10005558', 888494.63, GETUTCDATE(), 39, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10005748-1_0', '1_0', 'AS-2122', '1619', '10005748', 659368.67, GETUTCDATE(), 40, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10006159-1_0', '1_0', 'AS-2122', '1619', '10006159', 315653.92, GETUTCDATE(), 41, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10006199-1_0', '1_0', 'AS-2122', '1619', '10006199', 1102264.63, GETUTCDATE(), 42, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10006226-2_0', '2_0', 'AS-2122', '1619', '10006226', 1641109.93, GETUTCDATE(), 43, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10006374-1_0', '1_0', 'AS-2122', '1619', '10006374', 482083.73, GETUTCDATE(), 44, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10006570-1_0', '1_0', 'AS-2122', '1619', '10006570', 39813300.06, GETUTCDATE(), 45, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10007031-1_0', '1_0', 'AS-2122', '1619', '10007031', 1145861.45, GETUTCDATE(), 46, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10007872-1_0', '1_0', 'AS-2122', '1619', '10007872', 676589.9, GETUTCDATE(), 47, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10008456-1_0', '1_0', 'AS-2122', '1619', '10008456', 379614.37, GETUTCDATE(), 48, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10008986-1_0', '1_0', 'AS-2122', '1619', '10008986', 428926.03, GETUTCDATE(), 49, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10009031-1_0', '1_0', 'AS-2122', '1619', '10009031', 791281.27, GETUTCDATE(), 50, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10009069-1_0', '1_0', 'AS-2122', '1619', '10009069', 171123.77, GETUTCDATE(), 51, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10009111-1_0', '1_0', 'AS-2122', '1619', '10009111', 587537.64, GETUTCDATE(), 52, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10009120-1_0', '1_0', 'AS-2122', '1619', '10009120', 176199.05, GETUTCDATE(), 53, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10009777-1_0', '1_0', 'AS-2122', '1619', '10009777', 162672.92, GETUTCDATE(), 54, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10010025-1_0', '1_0', 'AS-2122', '1619', '10010025', 782287.47, GETUTCDATE(), 55, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10012804-1_0', '1_0', 'AS-2122', '1619', '10012804', 523215.14, GETUTCDATE(), 56, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10012810-1_0', '1_0', 'AS-2122', '1619', '10012810', 550016.33, GETUTCDATE(), 57, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10012814-1_0', '1_0', 'AS-2122', '1619', '10012814', 930376.79, GETUTCDATE(), 58, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10012822-1_0', '1_0', 'AS-2122', '1619', '10012822', 214710.6, GETUTCDATE(), 59, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10012825-1_0', '1_0', 'AS-2122', '1619', '10012825', 349121.09, GETUTCDATE(), 60, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10019237-1_0', '1_0', 'AS-2122', '1619', '10019237', 732661.47, GETUTCDATE(), 61, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10021185-1_0', '1_0', 'AS-2122', '1619', '10021185', 240679.33, GETUTCDATE(), 62, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10024163-1_0', '1_0', 'AS-2122', '1619', '10024163', 324759.27, GETUTCDATE(), 63, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10024771-1_0', '1_0', 'AS-2122', '1619', '10024771', 128574.41, GETUTCDATE(), 64, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10024772-1_0', '1_0', 'AS-2122', '1619', '10024772', 719768.47, GETUTCDATE(), 65, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10025914-1_0', '1_0', 'AS-2122', '1619', '10025914', 907702.64, GETUTCDATE(), 66, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10025915-1_0', '1_0', 'AS-2122', '1619', '10025915', 359418.22, GETUTCDATE(), 67, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10027379-1_0', '1_0', 'AS-2122', '1619', '10027379', 511105.14, GETUTCDATE(), 68, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10027384-1_0', '1_0', 'AS-2122', '1619', '10027384', 883482.36, GETUTCDATE(), 69, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10028480-1_0', '1_0', 'AS-2122', '1619', '10028480', 249262.33, GETUTCDATE(), 70, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10028500-1_0', '1_0', 'AS-2122', '1619', '10028500', 596597.32, GETUTCDATE(), 71, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10032448-1_0', '1_0', 'AS-2122', '1619', '10032448', 943939.92, GETUTCDATE(), 72, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10032898-1_0', '1_0', 'AS-2122', '1619', '10032898', 401336.84, GETUTCDATE(), 73, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10038981-1_0', '1_0', 'AS-2122', '1619', '10038981', 476158.27, GETUTCDATE(), 74, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10040374-1_0', '1_0', 'AS-2122', '1619', '10040374', 150723.78, GETUTCDATE(), 75, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10040375-1_0', '1_0', 'AS-2122', '1619', '10040375', 162317.92, GETUTCDATE(), 76, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10041170-1_0', '1_0', 'AS-2122', '1619', '10041170', 875708.69, GETUTCDATE(), 77, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10041272-1_0', '1_0', 'AS-2122', '1619', '10041272', 719015.33, GETUTCDATE(), 78, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10043186-1_0', '1_0', 'AS-2122', '1619', '10043186', 423530.15, GETUTCDATE(), 79, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10044946-1_0', '1_0', 'AS-2122', '1619', '10044946', 239198.73, GETUTCDATE(), 80, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10045935-1_0', '1_0', 'AS-2122', '1619', '10045935', 1143986.54, GETUTCDATE(), 81, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10046840-1_0', '1_0', 'AS-2122', '1619', '10046840', 996838.63, GETUTCDATE(), 82, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10046853-1_0', '1_0', 'AS-2122', '1619', '10046853', 229853.15, GETUTCDATE(), 83, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10048022-1_0', '1_0', 'AS-2122', '1619', '10048022', 615738.24, GETUTCDATE(), 84, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10048265-1_0', '1_0', 'AS-2122', '1619', '10048265', 1109864.33, GETUTCDATE(), 85, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10049051-1_0', '1_0', 'AS-2122', '1619', '10049051', 277549.75, GETUTCDATE(), 86, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10054747-1_0', '1_0', 'AS-2122', '1619', '10054747', 3664058.78, GETUTCDATE(), 87, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10055015-1_0', '1_0', 'AS-2122', '1619', '10055015', 394200.64, GETUTCDATE(), 88, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10055479-1_0', '1_0', 'AS-2122', '1619', '10055479', 568112.69, GETUTCDATE(), 89, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10055517-1_0', '1_0', 'AS-2122', '1619', '10055517', 278712.29, GETUTCDATE(), 90, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10056251-1_0', '1_0', 'AS-2122', '1619', '10056251', 200869.33, GETUTCDATE(), 91, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10056799-1_0', '1_0', 'AS-2122', '1619', '10056799', 106533.93, GETUTCDATE(), 92, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10056854-1_0', '1_0', 'AS-2122', '1619', '10056854', 1096481.18, GETUTCDATE(), 93, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10057205-1_0', '1_0', 'AS-2122', '1619', '10057205', 394078.25, GETUTCDATE(), 94, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10057307-1_0', '1_0', 'AS-2122', '1619', '10057307', 481493.14, GETUTCDATE(), 95, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10063538-1_0', '1_0', 'AS-2122', '1619', '10063538', 89382.24, GETUTCDATE(), 96, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10064084-1_0', '1_0', 'AS-2122', '1619', '10064084', 1554476.29, GETUTCDATE(), 97, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10064516-1_0', '1_0', 'AS-2122', '1619', '10064516', 386212.74, GETUTCDATE(), 98, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10067032-1_0', '1_0', 'AS-2122', '1619', '10067032', 228817.15, GETUTCDATE(), 99, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10067033-1_0', '1_0', 'AS-2122', '1619', '10067033', 382606.5, GETUTCDATE(), 100, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10067343-1_0', '1_0', 'AS-2122', '1619', '10067343', 275779.25, GETUTCDATE(), 101, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10067359-1_0', '1_0', 'AS-2122', '1619', '10067359', 273871.31, GETUTCDATE(), 102, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10067674-1_0', '1_0', 'AS-2122', '1619', '10067674', 337591.01, GETUTCDATE(), 103, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10067684-1_0', '1_0', 'AS-2122', '1619', '10067684', 61498.89, GETUTCDATE(), 104, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10067746-1_0', '1_0', 'AS-2122', '1619', '10067746', 781466.87, GETUTCDATE(), 105, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10067747-1_0', '1_0', 'AS-2122', '1619', '10067747', 115941.36, GETUTCDATE(), 106, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10067866-1_0', '1_0', 'AS-2122', '1619', '10067866', 599775.27, GETUTCDATE(), 107, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10068038-1_0', '1_0', 'AS-2122', '1619', '10068038', 208246.89, GETUTCDATE(), 108, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10068178-1_0', '1_0', 'AS-2122', '1619', '10068178', 404780.16, GETUTCDATE(), 109, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10068204-1_0', '1_0', 'AS-2122', '1619', '10068204', 2030877.61, GETUTCDATE(), 110, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10068234-1_0', '1_0', 'AS-2122', '1619', '10068234', 870402.91, GETUTCDATE(), 111, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10068348-1_0', '1_0', 'AS-2122', '1619', '10068348', 857964.74, GETUTCDATE(), 112, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10081018-1_0', '1_0', 'AS-2122', '1619', '10081018', 139952.64, GETUTCDATE(), 113, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10083399-1_0', '1_0', 'AS-2122', '1619', '10083399', 499068.9, GETUTCDATE(), 114, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10083456-1_0', '1_0', 'AS-2122', '1619', '10083456', 197161.17, GETUTCDATE(), 115, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10083475-1_0', '1_0', 'AS-2122', '1619', '10083475', 166658.16, GETUTCDATE(), 116, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10083544-1_0', '1_0', 'AS-2122', '1619', '10083544', 174700.16, GETUTCDATE(), 117, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10084353-1_0', '1_0', 'AS-2122', '1619', '10084353', 174127.16, GETUTCDATE(), 118, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-Provider-10084430-1_0', '1_0', 'AS-2122', '1619', '10084430', 846371.97, GETUTCDATE(), 119, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-LocalAuthoritySsf-10003990-2_0', '2_0', 'AS-2122', '1619', '10003990', 7099764.77, GETUTCDATE(), 120, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10001232-1_0', '1_0', 'AY-2122', 'NMSS', '10001232', 351326.37, GETUTCDATE(), 121, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10006283-1_0', '1_0', 'AY-2122', 'NMSS', '10006283', 541830.85, GETUTCDATE(), 122, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10007428-1_0', '1_0', 'AY-2122', 'NMSS', '10007428', 70000, GETUTCDATE(), 123, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10010767-1_0', '1_0', 'AY-2122', 'NMSS', '10010767', 1033417.88, GETUTCDATE(), 124, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10013987-1_0', '1_0', 'AY-2122', 'NMSS', '10013987', 2103165.94, GETUTCDATE(), 125, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10015031-1_0', '1_0', 'AY-2122', 'NMSS', '10015031', 491709.77, GETUTCDATE(), 126, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10015047-1_0', '1_0', 'AY-2122', 'NMSS', '10015047', 672097.48, GETUTCDATE(), 127, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10015061-1_0', '1_0', 'AY-2122', 'NMSS', '10015061', 400000, GETUTCDATE(), 128, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10015087-1_0', '1_0', 'AY-2122', 'NMSS', '10015087', 360000, GETUTCDATE(), 129, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10015222-1_0', '1_0', 'AY-2122', 'NMSS', '10015222', 911684.63, GETUTCDATE(), 130, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10015363-1_0', '1_0', 'AY-2122', 'NMSS', '10015363', 290500, GETUTCDATE(), 131, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10015673-1_0', '1_0', 'AY-2122', 'NMSS', '10015673', 593010.9, GETUTCDATE(), 132, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10015703-1_0', '1_0', 'AY-2122', 'NMSS', '10015703', 401672.96, GETUTCDATE(), 133, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10015753-1_0', '1_0', 'AY-2122', 'NMSS', '10015753', 670852.64, GETUTCDATE(), 134, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10015778-1_0', '1_0', 'AY-2122', 'NMSS', '10015778', 590952.38, GETUTCDATE(), 135, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10015800-1_0', '1_0', 'AY-2122', 'NMSS', '10015800', 310564.1, GETUTCDATE(), 136, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10015866-1_0', '1_0', 'AY-2122', 'NMSS', '10015866', 730506.41, GETUTCDATE(), 137, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10016012-1_0', '1_0', 'AY-2122', 'NMSS', '10016012', 1074183.92, GETUTCDATE(), 138, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10016047-1_0', '1_0', 'AY-2122', 'NMSS', '10016047', 782327.81, GETUTCDATE(), 139, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10016076-1_0', '1_0', 'AY-2122', 'NMSS', '10016076', 964013.31, GETUTCDATE(), 140, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10016306-1_0', '1_0', 'AY-2122', 'NMSS', '10016306', 260500, GETUTCDATE(), 141, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10016441-1_0', '1_0', 'AY-2122', 'NMSS', '10016441', 971118.86, GETUTCDATE(), 142, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10016541-1_0', '1_0', 'AY-2122', 'NMSS', '10016541', 1752968.08, GETUTCDATE(), 143, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10016637-1_0', '1_0', 'AY-2122', 'NMSS', '10016637', 1023245.81, GETUTCDATE(), 144, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10016733-1_0', '1_0', 'AY-2122', 'NMSS', '10016733', 430800.56, GETUTCDATE(), 145, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10016972-1_0', '1_0', 'AY-2122', 'NMSS', '10016972', 671514.03, GETUTCDATE(), 146, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10017065-1_0', '1_0', 'AY-2122', 'NMSS', '10017065', 651416.1, GETUTCDATE(), 147, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10017071-1_0', '1_0', 'AY-2122', 'NMSS', '10017071', 870731.5, GETUTCDATE(), 148, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10017088-1_0', '1_0', 'AY-2122', 'NMSS', '10017088', 460500, GETUTCDATE(), 149, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10017150-1_0', '1_0', 'AY-2122', 'NMSS', '10017150', 631823.6, GETUTCDATE(), 150, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10017187-1_0', '1_0', 'AY-2122', 'NMSS', '10017187', 1011861.9, GETUTCDATE(), 151, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10017455-1_0', '1_0', 'AY-2122', 'NMSS', '10017455', 881134.71, GETUTCDATE(), 152, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10017680-1_0', '1_0', 'AY-2122', 'NMSS', '10017680', 411616.05, GETUTCDATE(), 153, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10017687-1_0', '1_0', 'AY-2122', 'NMSS', '10017687', 811370.8, GETUTCDATE(), 154, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10017703-1_0', '1_0', 'AY-2122', 'NMSS', '10017703', 380772.42, GETUTCDATE(), 155, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10017742-1_0', '1_0', 'AY-2122', 'NMSS', '10017742', 993151.13, GETUTCDATE(), 156, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10017770-1_0', '1_0', 'AY-2122', 'NMSS', '10017770', 1171803.21, GETUTCDATE(), 157, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10017793-1_0', '1_0', 'AY-2122', 'NMSS', '10017793', 681447.86, GETUTCDATE(), 158, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10017850-1_0', '1_0', 'AY-2122', 'NMSS', '10017850', 750500, GETUTCDATE(), 159, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10017907-1_0', '1_0', 'AY-2122', 'NMSS', '10017907', 822780.9, GETUTCDATE(), 160, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10017915-1_0', '1_0', 'AY-2122', 'NMSS', '10017915', 360000, GETUTCDATE(), 161, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10017949-1_0', '1_0', 'AY-2122', 'NMSS', '10017949', 622596.54, GETUTCDATE(), 162, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10018021-1_0', '1_0', 'AY-2122', 'NMSS', '10018021', 1777612.75, GETUTCDATE(), 163, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10018086-1_0', '1_0', 'AY-2122', 'NMSS', '10018086', 764402.53, GETUTCDATE(), 164, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10023008-1_0', '1_0', 'AY-2122', 'NMSS', '10023008', 530000, GETUTCDATE(), 165, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10027310-1_0', '1_0', 'AY-2122', 'NMSS', '10027310', 340000, GETUTCDATE(), 166, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10029323-1_0', '1_0', 'AY-2122', 'NMSS', '10029323', 671638.46, GETUTCDATE(), 167, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10030237-1_0', '1_0', 'AY-2122', 'NMSS', '10030237', 500500, GETUTCDATE(), 168, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10030284-1_0', '1_0', 'AY-2122', 'NMSS', '10030284', 440992.94, GETUTCDATE(), 169, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10032279-1_0', '1_0', 'AY-2122', 'NMSS', '10032279', 170000, GETUTCDATE(), 170, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10039933-1_0', '1_0', 'AY-2122', 'NMSS', '10039933', 30500, GETUTCDATE(), 171, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10039934-1_0', '1_0', 'AY-2122', 'NMSS', '10039934', 291387.47, GETUTCDATE(), 172, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10039935-1_0', '1_0', 'AY-2122', 'NMSS', '10039935', 761169.76, GETUTCDATE(), 173, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10039936-1_0', '1_0', 'AY-2122', 'NMSS', '10039936', 240913.7, GETUTCDATE(), 174, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10040382-1_0', '1_0', 'AY-2122', 'NMSS', '10040382', 611551.16, GETUTCDATE(), 175, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10040604-1_0', '1_0', 'AY-2122', 'NMSS', '10040604', 610000, GETUTCDATE(), 176, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('NMSS-AY-2122-Contracting-Provider-10040605-1_0', '1_0', 'AY-2122', 'NMSS', '10040605', 440000, GETUTCDATE(), 177, 2, 0, @readId)

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('1619-AS-2122-Contracting-LocalAuthority-10024294-1_0', '1_0', 'AS-2122', '1619', '10024294', 173948.91, GETUTCDATE(), 178, 2, 0, @readId)
