-- individual allocations
SELECT DISTINCT
	dp.AllocationNumber
FROM
	PaymentSchedule.DeliverablePayment dp
	INNER JOIN PaymentSchedule.Allocation a ON a.AllocationNumber = dp.AllocationNumber AND a.VersionNumber = dp.VersionNumber
WHERE
	a.FundingStreamPeriodCode IN ('ASC1516', 'CL1516', '24+ALLBC1516', 'DLS1516')
	AND (
		dp.ActualValue IS NULL OR
		dp.PlannedValue IS NULL OR
		dp.CappedPaymentAmount IS NULL OR
		dp.ProfilePaymentAmount IS NULL OR
		dp.BalancingPaymentAmount IS NULL OR
		dp.ReconciliationPaymentAmount IS NULL
		)
	AND dp.VersionNumber = (SELECT MAX(VersionNumber) FROM PaymentSchedule.DeliverablePayment WHERE AllocationNumber = dp.AllocationNumber)

-- individual deliverable payments
SELECT
	dp.*
FROM
	PaymentSchedule.DeliverablePayment dp
	INNER JOIN PaymentSchedule.Allocation a ON a.AllocationNumber = dp.AllocationNumber AND a.VersionNumber = dp.VersionNumber
WHERE
	a.FundingStreamPeriodCode IN ('ASC1516', 'CL1516', '24+ALLBC1516', 'DLS1516')
	AND (
		dp.ActualValue IS NULL OR
		dp.PlannedValue IS NULL OR
		dp.CappedPaymentAmount IS NULL OR
		dp.ProfilePaymentAmount IS NULL OR
		dp.BalancingPaymentAmount IS NULL OR
		dp.ReconciliationPaymentAmount IS NULL
		)
	AND dp.VersionNumber = (SELECT MAX(VersionNumber) FROM PaymentSchedule.DeliverablePayment WHERE AllocationNumber = dp.AllocationNumber)
