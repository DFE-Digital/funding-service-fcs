SELECT
				 ISNULL(dp.[sfa_PlannedValue], 0) AS PlannedValue,   
				 ISNULL(dp.[sfa_PlannedVolume], 0) AS PlannedVolume, 
				 ISNULL(dp.[sfa_ActualValue], 0) AS ActualValue, 
				 ISNULL(dp.[sfa_ActualVolume], 0) AS ActualVolume, 
                 dp.[sfa_BalancingPaymentAmount] AS BalancingPaymentValue,
				 dp.[sfa_CappedPaymentAmount] AS CappingPaymentValue, 
				 dp.[sfa_NetPaymentAmount] AS NetPaymentValue, 
				 dp.[sfa_ReconciliationPaymentAmount] AS ReconciliationPaymentValue, 
				 dp.[sfa_ProfilePaymentAmount] AS ProfilePaymentValue, 
                 a.sfa_contractallocationnumber + '_' + CAST(c.sfa_Version AS NVARCHAR(100)) + '_' + d.sfa_DeliverableCode + '_' + dp.sfa_PeriodName AS [Key]
                               
                 FROM [sfa_contractdeliverableperiod] dp
                 INNER JOIN [sfa_contractdeliverable] d
                 ON dp.sfa_ContractDeliverableId = d.Id
                 INNER JOIN [sfa_contractallocation] a
                 ON d.[sfa_ContractAllocationId] = a.[Id]
                 INNER JOIN [sfa_contract] c
                 ON a.sfa_contractId = c.Id
                 INNER JOIN [dbo].[sfa_fundingstreamperiod] fsp
				 ON a.sfa_fundingstreamperiodid = fsp.Id
                 WHERE fsp.sfa_fundingstreamperiodcode in @activeFsps
                 AND c.sfa_ContractStatus = @contractStatus