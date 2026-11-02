UPDATE
	ContractManagement.MonthEndHistory
SET
	EndTime = GETUTCDATE()
WHERE
	EndTime IS NULL
