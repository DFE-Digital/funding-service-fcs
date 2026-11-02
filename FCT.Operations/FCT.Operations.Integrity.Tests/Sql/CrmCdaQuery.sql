SELECT
al.sfa_fundingstreamperiodidname AS FundingStreamPeriodCode
,con.sfa_ukprn AS UKPRN
,con.sfa_providernamename AS ProviderName
,al.sfa_contractallocationnumber AS ContractAllocationNumber
,con.sfa_number AS ContractNumber
,con.sfa_parentcontractidname AS MasterContractReference
,FORMAT(al.sfa_startdate, 'dd/MM/yyyy') AS ContractAllocationStartDate
,FORMAT(al.sfa_enddate, 'dd/MM/yyyy') AS ContractAllocationEndDate
,con.sfa_version AS ContractVersionNumber
,pl.Value AS ContractStatus
,con.sfa_substatusname AS 'ContractSub-Status'
,del.sfa_deliverabledescription AS DeliverableDescription
,del.sfa_deliverablename AS DeliverableName
,del.sfa_deliverablecode AS DeliverableCode
,del.sfa_parentdeliverableidname AS DeliverableParent
,dp.sfa_period AS DeliverablePeriod
,dp.sfa_year AS DeliverableYear
,CASE WHEN sfa_period >= 4 THEN CONCAT(sfa_year, '/', RIGHT(sfa_year + 1, 2)) ELSE CONCAT(sfa_year - 1, '/', RIGHT(sfa_year, 2)) END AS FinancialYear
,NULL AS PlanningUnit
,dp.sfa_plannedvalue AS PlannedValue
,dp.sfa_actualvalue AS ActualEarned
,NULL AS PlannedVolume
,NULL AS ActualVolume
,CASE WHEN fspd.sfa_setting_allowpayment = 1 THEN 'Yes' WHEN fspd.sfa_setting_allowpayment = 0 THEN 'No' ELSE NULL END AS PayableDeliverable
,dp.sfa_profilepaymentamount AS ProfilePayment
,dp.sfa_balancingpaymentamount AS BalancingPayment
,dp.sfa_reconciliationpaymentamount AS ReconciliationPayment
,dp.sfa_cappedpaymentamount AS CappingPayment
,dp.sfa_netpaymentamount AS TotalNetPayment
,NULL AS PaymentHeld
,CASE WHEN dp.sfa_paymentposted = 1 THEN 'Yes' WHEN dp.sfa_paymentposted = 0 THEN 'No' ELSE NULL END AS PaymentPosted
,al.sfa_unitofprocurementidname AS UnitOfProcurement
,NULL AS LEP
,dp.sfa_profilesubnominalname AS 'Subnominal-Profile'
,dp.sfa_reconciliationsubnominalname AS 'Subnominal-Reconciliation'
,dp.sfa_cappingsubnominalname AS 'Subnominal-Capping'
,FORMAT(DATEADD(month, dp.sfa_period, -1), 'MMM') AS DeliverableMonth,
con.sfa_lastapprovedversion as lastapprovedversion,
con.sfa_latestversion as latestversion
FROM
sfa_contractdeliverableperiod dp
LEFT JOIN sfa_contractdeliverable del ON dp.sfa_contractdeliverableid = del.sfa_contractdeliverableid
LEFT JOIN sfa_contractallocation al ON del.sfa_contractallocationid = al.sfa_contractallocationid
LEFT JOIN sfa_fundingstreamperioddeliverable fspd ON del.sfa_deliverablecode = fspd.sfa_deliverablecode AND al.sfa_fundingstreamperiodid = fspd.sfa_fundingstreamperiodid
LEFT JOIN sfa_contract con ON al.sfa_contractid = con.sfa_contractid AND con.sfa_hierarchytype = 229660000/* Contract */
LEFT JOIN sfa_contract mcon ON con.sfa_parentcontractid = mcon.sfa_contractid AND mcon.sfa_hierarchytype = 229660001/* Master Contract */
LEFT JOIN sfa_fundingtype ft ON mcon.sfa_fundingtype = ft.sfa_fundingtypeid
LEFT JOIN StringMap pl ON pl.AttributeName = 'sfa_contractstatus' AND pl.ObjectTypeCode = 10007 AND pl.AttributeValue = con.sfa_contractstatus
LEFT JOIN sfa_fundingstreamperiod fsp ON al.sfa_FundingStreamPeriodId = fsp.sfa_fundingstreamperiodId
WHERE
(fspd.sfa_setting_allowprofile = 1 OR fspd.sfa_setting_allowpayment = 1 OR fspd.sfa_setting_allowactuals = 1)
AND (con.sfa_lastapprovedversion = 1 or con.sfa_latestversion = 1)
AND fsp.sfa_fundingstreamperiodcode in @fsps
AND dp.[ModifiedOn] > '01-JAN-2019'


