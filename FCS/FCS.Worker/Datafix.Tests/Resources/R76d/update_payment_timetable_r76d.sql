	DECLARE @oldCensusDate DATETIME = '2020-01-09 22:00';
	DECLARE @newCensusDate DATETIME = '2020-01-10 22:00';

	DECLARE @collectionFsps TABLE(fsp NVARCHAR(20));
	INSERT INTO @collectionFsps VALUES ('16-18NLAP2018');
	INSERT INTO @collectionFsps VALUES ('ANLAP2018');
	INSERT INTO @collectionFsps VALUES ('APPS1920');
	INSERT INTO @collectionFsps VALUES ('LEVY1799');
	INSERT INTO @collectionFsps VALUES ('NONLEVY2019');

	-- select before
	SELECT * FROM PaymentGeneration.PaymentTimetable WHERE CensusEndDate = @oldCensusDate AND FundingStreamPeriodCode IN (SELECT fsp FROM @collectionFsps);
	SELECT * FROM PolicyCache.PolicyFundingStreamCensusDate WHERE CensusDate = @oldCensusDate AND FundingStreamPeriod IN (SELECT fsp FROM @collectionFsps);

	-- update
	UPDATE PaymentGeneration.PaymentTimetable SET CensusEndDate = @newCensusDate WHERE CensusEndDate = @oldCensusDate AND FundingStreamPeriodCode IN (SELECT fsp FROM @collectionFsps);
	UPDATE PolicyCache.PolicyFundingStreamCensusDate SET CensusDate = @newCensusDate WHERE CensusDate = @oldCensusDate AND FundingStreamPeriod IN (SELECT fsp FROM @collectionFsps);

	-- select after for old and new dates
	SELECT * FROM PaymentGeneration.PaymentTimetable WHERE CensusEndDate = @oldCensusDate AND FundingStreamPeriodCode IN (SELECT fsp FROM @collectionFsps);
	SELECT * FROM PolicyCache.PolicyFundingStreamCensusDate WHERE CensusDate = @oldCensusDate AND FundingStreamPeriod IN (SELECT fsp FROM @collectionFsps);

	SELECT * FROM PaymentGeneration.PaymentTimetable WHERE CensusEndDate = @newCensusDate AND FundingStreamPeriodCode IN (SELECT fsp FROM @collectionFsps);
	SELECT * FROM PolicyCache.PolicyFundingStreamCensusDate WHERE CensusDate = @newCensusDate AND FundingStreamPeriod IN (SELECT fsp FROM @collectionFsps);