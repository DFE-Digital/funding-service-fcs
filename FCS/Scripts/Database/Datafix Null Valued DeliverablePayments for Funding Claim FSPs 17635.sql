BEGIN TRANSACTION

	UPDATE
		dp
	SET
		dp.ActualValue = ISNULL(dp.ActualValue, 0),
		dp.PlannedValue = ISNULL(dp.PlannedValue, 0),
		dp.CappedPaymentAmount = ISNULL(dp.CappedPaymentAmount, 0),
		dp.ProfilePaymentAmount = ISNULL(dp.ProfilePaymentAmount, 0),
		dp.BalancingPaymentAmount = ISNULL(dp.BalancingPaymentAmount, 0),
		dp.ReconciliationPaymentAmount = ISNULL(dp.ReconciliationPaymentAmount, 0)
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

ROLLBACK
