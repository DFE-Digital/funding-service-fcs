BEGIN TRANSACTION;

DECLARE @CreatedDate DATETIME = GETDATE();
DECLARE @ReadId int = 1286

INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId,FundingAllocationName, Status,SubStatus)
VALUES
	('1619-AS-2627-Contracting-Provider-10021684-1_0', '1_0', 'AS-2627', '1619', '10021684', 3577201.08, GETUTCDATE(), 162, 34, 1, @ReadId ,'1619-AS-2627-Contracting-Provider-10021684-1_0', 'Parked','AwaitingFundingAllocationConfig')


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
    '1619-AS-2627-10021684-1_0',
    '10021684',
    '16-19 provider',
    'Independent learning provider',
    @CreatedDate
);

-- Verify FundingId before running
INSERT INTO FundingAllocation.ProviderFundingAllocation
(
    ProviderFundingId,
    FundingId,
    CreatedDate
)
VALUES
(
    '1619-AS-2627-10021684-1_0',
    '1619-AS-2627-Contracting-Provider-10021684-1_0',
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
('1619-AS-2627-10021684-1_0','1619-001',@CreatedDate,0),
('1619-AS-2627-10021684-1_0','1619-002',@CreatedDate,0),
('1619-AS-2627-10021684-1_0','1619-005',@CreatedDate,0),
('1619-AS-2627-10021684-1_0','1619-006',@CreatedDate,0);

INSERT INTO FundingAllocation.ParkingAndDiscardedInfo
(
    FundingAllocationId,
    LastParked,
    CreatedDate
)
VALUES
(
    '1619-AS-2627-Contracting-Provider-10021684-1_0',
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
('1619-AS-2627-10021684-1_0',202608,268336.11,@CreatedDate,'1619-001'),
('1619-AS-2627-10021684-1_0',202609,268336.11,@CreatedDate,'1619-001'),
('1619-AS-2627-10021684-1_0',202610,268336.11,@CreatedDate,'1619-001'),
('1619-AS-2627-10021684-1_0',202611,268336.11,@CreatedDate,'1619-001'),
('1619-AS-2627-10021684-1_0',202612,268336.11,@CreatedDate,'1619-001'),
('1619-AS-2627-10021684-1_0',202701,268336.11,@CreatedDate,'1619-001'),
('1619-AS-2627-10021684-1_0',202702,268336.11,@CreatedDate,'1619-001'),
('1619-AS-2627-10021684-1_0',202703,268336.11,@CreatedDate,'1619-001'),
('1619-AS-2627-10021684-1_0',202704,268336.11,@CreatedDate,'1619-001'),
('1619-AS-2627-10021684-1_0',202705,268336.11,@CreatedDate,'1619-001'),
('1619-AS-2627-10021684-1_0',202706,268336.11,@CreatedDate,'1619-001'),
('1619-AS-2627-10021684-1_0',202707,268337.39,@CreatedDate,'1619-001'),

-- 1619-002
('1619-AS-2627-10021684-1_0',202608,36833.49,@CreatedDate,'1619-002'),
('1619-AS-2627-10021684-1_0',202609,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10021684-1_0',202610,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10021684-1_0',202611,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10021684-1_0',202612,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10021684-1_0',202701,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10021684-1_0',202702,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10021684-1_0',202703,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10021684-1_0',202704,18413.99,@CreatedDate,'1619-002'),
('1619-AS-2627-10021684-1_0',202705,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10021684-1_0',202706,0,@CreatedDate,'1619-002'),
('1619-AS-2627-10021684-1_0',202707,0,@CreatedDate,'1619-002'),

-- 1619-005
('1619-AS-2627-10021684-1_0',202608,21280.40,@CreatedDate,'1619-005'),
('1619-AS-2627-10021684-1_0',202609,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10021684-1_0',202610,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10021684-1_0',202611,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10021684-1_0',202612,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10021684-1_0',202701,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10021684-1_0',202702,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10021684-1_0',202703,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10021684-1_0',202704,10638.60,@CreatedDate,'1619-005'),
('1619-AS-2627-10021684-1_0',202705,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10021684-1_0',202706,0,@CreatedDate,'1619-005'),
('1619-AS-2627-10021684-1_0',202707,0,@CreatedDate,'1619-005'),

-- 1619-006
('1619-AS-2627-10021684-1_0',202608,22499.99,@CreatedDate,'1619-006'),
('1619-AS-2627-10021684-1_0',202609,22499.99,@CreatedDate,'1619-006'),
('1619-AS-2627-10021684-1_0',202610,22499.99,@CreatedDate,'1619-006'),
('1619-AS-2627-10021684-1_0',202611,22499.99,@CreatedDate,'1619-006'),
('1619-AS-2627-10021684-1_0',202612,22499.99,@CreatedDate,'1619-006'),
('1619-AS-2627-10021684-1_0',202701,22499.99,@CreatedDate,'1619-006'),
('1619-AS-2627-10021684-1_0',202702,22499.99,@CreatedDate,'1619-006'),
('1619-AS-2627-10021684-1_0',202703,22499.99,@CreatedDate,'1619-006'),
('1619-AS-2627-10021684-1_0',202704,22499.99,@CreatedDate,'1619-006'),
('1619-AS-2627-10021684-1_0',202705,22499.99,@CreatedDate,'1619-006'),
('1619-AS-2627-10021684-1_0',202706,22499.99,@CreatedDate,'1619-006'),
('1619-AS-2627-10021684-1_0',202707,22500.11,@CreatedDate,'1619-006');

COMMIT TRANSACTION;