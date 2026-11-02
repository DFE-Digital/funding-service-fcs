SELECT
		                            a.FundingStreamPeriodCode,
		                            dp.AllocationNumber,
		                            dp.DeliverableCode,
		                            SUBSTRING(dp.Period, 5, 6) Period,
		                            SUBSTRING(dp.Period, 1,4) Year,
		                            ISNULL(dp.PlannedValue, 0) PlannedValue,
		                            ISNULL(dp.PlannedVolume, 0) PlannedVolume,
		                            ISNULL(dp.ActualValue, 0) ActualValue,
		                            ISNULL(dp.ActualVolume, 0) ActualVolume,
		                            ISNULL(dp.ProfilePaymentAmount,0) ProfilePaymentAmount,
		                            ISNULL(dp.BalancingPaymentAmount,0) BalancingPaymentAmount,
		                            ISNULL(dp.ReconciliationPaymentAmount, 0) ReconciliationPaymentAmount,
		                            ISNULL(dp.CappedPaymentAmount, 0) CappedPaymentAmount,
		                            ISNULL(dp.NetPaymentAmount, 0) NetPaymentAmount,
		                            dp.VersionNumber,
		                            GETUTCDATE() ExecutionTimeUtc
	                            FROM
		                            PaymentSchedule.DeliverablePayment dp
		                            INNER JOIN PaymentSchedule.Allocation a ON a.AllocationNumber = dp.AllocationNumber AND a.VersionNumber = dp.VersionNumber
		                            LEFT JOIN MonitoringDeliverables.InactiveAllocation ia ON ia.ContractAllocationNumber = dp.AllocationNumber -- we do not want invalid allocations
	                            WHERE dp.VersionNumber = (SELECT MAX(VersionNumber) FROM PaymentSchedule.Allocation WHERE AllocationNumber = dp.AllocationNumber)
		                            AND ia.ContractAllocationNumber IS NULL
		                            AND a.FundingStreamPeriodCode in @fspCodes
	                            ORDER BY
		                            a.FundingStreamPeriodCode,
		                            dp.AllocationNumber,
		                            dp.DeliverableCode,
		                            Period,
		                            Year