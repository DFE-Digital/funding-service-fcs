SELECT
	adp.FundingStreamPeriodCode,
	adp.Ukprn,
	adp.ContractAllocationNumber,
	adp.ContractNumber,
	adp.AllocationStartDate,
	adp.AllocationEndDate,
	adp.ContractVersionNumber,
	'Approved' ContractStatus,
	dp.DeliverableCode,
	pd.ParentDeliverableCode,
	dp.PlannedValue,
	dp.ActualVolumne ActualVolume,
	dp.ActualValue,
	dp.ProfilePaymentAmount,
	dp.BalancingPaymentAmount,
	dp.ReconciliationPaymentAmount,
	dp.CappedPaymentAmount,
	dp.NetPaymentAmount,
	SUBSTRING(adp.Period, 1, 4) DeliverableYear,
	SUBSTRING(adp.Period, 5, 2) DeliverablePeriod,
	CASE
		WHEN CONVERT(INT, SUBSTRING(adp.Period, 5, 2)) > 3 THEN
			SUBSTRING(adp.Period, 1, 4) + '/' + CONVERT(VARCHAR(2), CONVERT(INT, SUBSTRING(adp.Period, 3, 2)) + 1)
		WHEN CONVERT(INT, SUBSTRING(adp.Period, 5, 2)) < 4 THEN
			CONVERT(VARCHAR(4), CONVERT(INT, SUBSTRING(adp.Period, 1, 4)) - 1) + '/' + SUBSTRING(adp.Period, 3, 2)
	END FinancialYear, 
	(
		SELECT
			pds.SubnominalCode
		FROM
			PolicyCache.PolicyDeliverableToSubnominals pds,
			PolicyCache.PolicyFundingStreamPeriod pfsp
		WHERE
			pds.DeliverableCode = adp.DeliverableCode
			AND pds.FundingStreamPeriod = adp.FundingStreamPeriodCode
			AND pds.PaymentType = 0 /* 0 - Profile */
			AND pds.FundingStreamPeriod = pfsp.FundingStreamPeriod
	) SubNominalProfile,
	(
		SELECT
			pds.SubnominalCode
		FROM
			PolicyCache.PolicyDeliverableToSubnominals pds,
			PolicyCache.PolicyFundingStreamPeriod pfsp
		WHERE
			pds.DeliverableCode = adp.DeliverableCode
			AND pds.FundingStreamPeriod = adp.FundingStreamPeriodCode
			AND pds.PaymentType = 1 /* 1 - Reconciliation */
			AND pds.FundingStreamPeriod = pfsp.FundingStreamPeriod
	) SubNominalReconcilliation,
	(
		SELECT
			pds.SubnominalCode
		FROM
			PolicyCache.PolicyDeliverableToSubnominals pds,
			PolicyCache.PolicyFundingStreamPeriod pfsp
		WHERE
			pds.DeliverableCode = adp.DeliverableCode
			AND pds.FundingStreamPeriod = adp.FundingStreamPeriodCode
			AND pds.PaymentType = 2 /* 2 - Capping */
			AND pds.FundingStreamPeriod = pfsp.FundingStreamPeriod
	) SubNominalCapping,
	GETUTCDATE() ExecutionTimeUtc
FROM
	PaymentSchedule.DeliverablePayment dp,
	MonitoringDeliverables.AllocationDeliverablePeriod adp,
	PolicyCache.PolicyDeliverable pd
WHERE
	dp.AllocationNumber = adp.ContractAllocationNumber
	AND dp.VersionNumber = adp.ContractVersionNumber
	AND dp.DeliverableCode = adp.DeliverableCode
	AND dp.Period = adp.Period
	AND adp.DeliverableCode = pd.DeliverableCode
	AND adp.FundingStreamPeriodCode = pd.FundingStreamPeriod
