

BEGIN TRANSACTION;

DECLARE @CreatedDate DATETIME = GETDATE();
DECLARE @ReadId int = 1286

	
INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId,FundingAllocationName, Status,SubStatus)
VALUES
	('1619-AS-2627-Contracting-Provider-10009063-1_0', '1_0', 'AS-2627', '1619', '10009063', 1187128.49, GETUTCDATE(), 354, 34, 1, @ReadId ,'1619-AS-2627-Contracting-Provider-10009063','Parked','AwaitingFundingAllocationConfig')
	 
 
INSERT INTO FundingAllocation.ProviderFunding
(
    ProviderFundingId,
    DeliveryUkprn,
    ProviderType,
    ProviderSubType,
    CreatedDate
)
VALUES
(
    '1619-AS-2627-10009063-1_0',
    '10009063',
    '16-19 provider',
    'Independent learning provider',
    @CreatedDate
);

INSERT INTO FundingAllocation.ProviderFundingAllocation
(
    ProviderFundingId,
    FundingId,
    CreatedDate
)
VALUES
(
    '1619-AS-2627-10009063-1_0',
    '1619-AS-2627-Contracting-Provider-10009063-1_0',
    @CreatedDate
);

INSERT INTO FundingAllocation.FundingAllocationLine
(
    ProviderFundingId,
    FundingLineCode,
    CreatedDate,
    IsOfNoInterest
)
VALUES
('1619-AS-2627-10009063-1_0','1619-001',@CreatedDate,0),
('1619-AS-2627-10009063-1_0','1619-002',@CreatedDate,0),
('1619-AS-2627-10009063-1_0','1619-005',@CreatedDate,0),
('1619-AS-2627-10009063-1_0','1619-009',@CreatedDate,0);

INSERT INTO FundingAllocation.ParkingAndDiscardedInfo
(
    FundingAllocationId,
    LastParked,
    CreatedDate
)
VALUES
(
    '1619-AS-2627-Contracting-Provider-10009063-1_0',
    @CreatedDate,
    @CreatedDate
);


INSERT INTO FundingAllocation.FundingAllocationProfilePeriod
(
    ProviderFundingId,
    Period,
    PlannedValue,
    CreatedDate,
    FundingLineCode
)
VALUES

-- 1619-001
('1619-AS-2627-10009063-1_0',202608,90408.37,@CreatedDate,'1619-001'),
('1619-AS-2627-10009063-1_0',202609,90408.37,@CreatedDate,'1619-001'),
('1619-AS-2627-10009063-1_0',202610,90408.37,@CreatedDate,'1619-001'),
('1619-AS-2627-10009063-1_0',202611,90408.37,@CreatedDate,'1619-001'),
('1619-AS-2627-10009063-1_0',202612,90408.37,@CreatedDate,'1619-001'),
('1619-AS-2627-10009063-1_0',202701,90408.37,@CreatedDate,'1619-001'),
('1619-AS-2627-10009063-1_0',202702,90408.37,@CreatedDate,'1619-001'),
('1619-AS-2627-10009063-1_0',202703,90408.37,@CreatedDate,'1619-001'),
('1619-AS-2627-10009063-1_0',202704,90408.37,@CreatedDate,'1619-001'),
('1619-AS-2627-10009063-1_0',202705,90408.37,@CreatedDate,'1619-001'),
('1619-AS-2627-10009063-1_0',202706,90408.37,@CreatedDate,'1619-001'),
('1619-AS-2627-10009063-1_0',202707,90408.78,@CreatedDate,'1619-001'),

-- 1619-002
('1619-AS-2627-10009063-1_0',202608,8867.54,@CreatedDate,'1619-002'),
('1619-AS-2627-10009063-1_0',202609,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10009063-1_0',202610,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10009063-1_0',202611,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10009063-1_0',202612,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10009063-1_0',202701,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10009063-1_0',202702,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10009063-1_0',202703,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10009063-1_0',202704,4433.11,@CreatedDate,'1619-002'),
('1619-AS-2627-10009063-1_0',202705,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10009063-1_0',202706,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10009063-1_0',202707,0,@CreatedDate,'1619-002'),

-- 1619-005
('1619-AS-2627-10009063-1_0',202608,4851.57,@CreatedDate,'1619-005'),
('1619-AS-2627-10009063-1_0',202609,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10009063-1_0',202610,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10009063-1_0',202611,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10009063-1_0',202612,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10009063-1_0',202701,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10009063-1_0',202702,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10009063-1_0',202703,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10009063-1_0',202704,2425.42,@CreatedDate,'1619-005'),
('1619-AS-2627-10009063-1_0',202705,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10009063-1_0',202706,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10009063-1_0',202707,0,@CreatedDate,'1619-005'),

-- 1619-009
('1619-AS-2627-10009063-1_0',202608,6804.16,@CreatedDate,'1619-009'),
('1619-AS-2627-10009063-1_0',202609,6804.16,@CreatedDate,'1619-009'),
('1619-AS-2627-10009063-1_0',202610,6804.16,@CreatedDate,'1619-009'),
('1619-AS-2627-10009063-1_0',202611,6804.16,@CreatedDate,'1619-009'),
('1619-AS-2627-10009063-1_0',202612,6804.16,@CreatedDate,'1619-009'),
('1619-AS-2627-10009063-1_0',202701,6804.16,@CreatedDate,'1619-009'),
('1619-AS-2627-10009063-1_0',202702,6804.16,@CreatedDate,'1619-009'),
('1619-AS-2627-10009063-1_0',202703,6804.16,@CreatedDate,'1619-009'),
('1619-AS-2627-10009063-1_0',202704,6804.16,@CreatedDate,'1619-009'),
('1619-AS-2627-10009063-1_0',202705,6804.16,@CreatedDate,'1619-009'),
('1619-AS-2627-10009063-1_0',202706,6804.16,@CreatedDate,'1619-009'),
('1619-AS-2627-10009063-1_0',202707,6804.24,@CreatedDate,'1619-009');

COMMIT TRANSACTION;
