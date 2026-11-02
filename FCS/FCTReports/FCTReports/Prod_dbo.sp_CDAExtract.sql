USE [CRMProxy]
GO

/****** Object:  StoredProcedure [dbo].[sp_CDAExtract]    Script Date: 10/19/2015 2:57:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
USE master;
GO
ALTER DATABASE CRMProxy
COLLATE Latin1_General_CI_AI ;

GO
*/
--DECLARE @FundingStreamPeriod varchar(200) = '16-18APPS1516'
--DECLARE @IsLatestVersion bit = 1
-------
/*
exec sp_CDAExtract '16-18APPS1516',1

exec sp_CDAExtract '[MAIN],ASC1516,CL1516,ASTO1516,DLS1516,16-18APPS1516,OLASS1516,24+ALLB1516,24+ALLBC1516,24+ALLF1516',1

*/

CREATE PROCEDURE [dbo].[sp_CDAExtract]
(@FundingStreamPeriod varchar(200), @IsLatestVersion BIT)
AS
BEGIN
DECLARE @str VARCHAR(20)

DECLARE @fundingStreams TABLE(Value VARCHAR(20))


DECLARE @ind Int
DECLARE @input varchar(200) = @FundingStreamPeriod

SET @ind = CharIndex(',', @input)
WHILE @ind > 0
BEGIN
        SET @str = SUBSTRING(@input, 1, @ind - 1)
        SET @input = SUBSTRING(@input, @ind + 1, LEN(@input) - @ind)
        INSERT INTO @fundingStreams values (@str)
        SET @ind = CharIndex(',', @input)
END
SET @str = @input

INSERT INTO @fundingStreams values (@str)

IF @IsLatestVersion = 1
BEGIN

--DECLARE #lastApproved TABLE
CREATE TABLE #lastApproved
(
[FundingStreamPeriodCode] nvarchar(200)  COLLATE DATABASE_DEFAULT
,[UKPRN] nvarchar(100)  COLLATE DATABASE_DEFAULT
,[ProviderName] nvarchar(320)  COLLATE DATABASE_DEFAULT
,[ContractAllocationNumber] nvarchar(40)  COLLATE DATABASE_DEFAULT
,[ContractNumber] nvarchar(40)  COLLATE DATABASE_DEFAULT
,[MasterContractReference] nvarchar(40)  COLLATE DATABASE_DEFAULT
,[ContractAllocationStartDate] nvarchar(10)  COLLATE DATABASE_DEFAULT
,[ContractAllocationEndDate] nvarchar(10)  COLLATE DATABASE_DEFAULT
,[ContractVersionNumber] int
,[ContractStatus] nvarchar(200)  COLLATE DATABASE_DEFAULT
,[ContractSub-Status] nvarchar(200)  COLLATE DATABASE_DEFAULT
,[DeliverableDescription] nvarchar(510)  COLLATE DATABASE_DEFAULT
,[DeliverableName] nvarchar(200)  COLLATE DATABASE_DEFAULT
,[DeliverableCode] nvarchar(200)  COLLATE DATABASE_DEFAULT
,[DeliverableParent] nvarchar(200)  COLLATE DATABASE_DEFAULT
,[DeliverablePeriod] int
,[DeliverableYear] int
,[FinancialYear] varchar(15)  COLLATE DATABASE_DEFAULT
,[PlanningUnit] int
,[PlannedValue] [decimal](23, 10)
,[ActualEarned] [decimal](23, 10)
,[PlannedVolume] int
,[ActualVolume] int
,[PayableDeliverable] varchar(3)  COLLATE DATABASE_DEFAULT
,[ProfilePayment] [decimal](23, 10)
,[BalancingPayment] [decimal](23, 10)
,[ReconciliationPayment] [decimal](23, 10)
,[CappingPayment] [decimal](23, 10)
,[TotalNetPayment] [decimal](23, 10)
,[PaymentHeld] int
,[PaymentPosted] varchar(3)  COLLATE DATABASE_DEFAULT
,[UnitOfProcurement] nvarchar(200)  COLLATE DATABASE_DEFAULT
,[LEP] int
,[Subnominal-Profile] nvarchar(7)  COLLATE DATABASE_DEFAULT
,[Subnominal-Reconciliation] nvarchar(7)  COLLATE DATABASE_DEFAULT
,[Subnominal-Capping] nvarchar(7)  COLLATE DATABASE_DEFAULT
,[DeliverableMonth] nvarchar(3)  COLLATE DATABASE_DEFAULT
)


CREATE INDEX IX_2 on #lastApproved (DeliverablePeriod,
ContractAllocationNumber,
DeliverableCode) 

--DECLARE #latestVersion TABLE
CREATE TABLE  #latestVersion 
(
[FundingStreamPeriodCode] nvarchar(200) COLLATE DATABASE_DEFAULT
,[UKPRN] nvarchar(100) COLLATE DATABASE_DEFAULT
,[ProviderName] nvarchar(320) COLLATE DATABASE_DEFAULT
,[ContractAllocationNumber] nvarchar(40) COLLATE DATABASE_DEFAULT
,[ContractNumber] nvarchar(40) COLLATE DATABASE_DEFAULT
,[MasterContractReference] nvarchar(40) COLLATE DATABASE_DEFAULT
,[ContractAllocationStartDate] nvarchar(10) COLLATE DATABASE_DEFAULT
,[ContractAllocationEndDate] nvarchar(10) COLLATE DATABASE_DEFAULT
,[ContractVersionNumber] int 
,[ContractStatus] nvarchar(200) COLLATE DATABASE_DEFAULT
,[ContractSub-Status] nvarchar(200) COLLATE DATABASE_DEFAULT
,[DeliverableDescription] nvarchar(510) COLLATE DATABASE_DEFAULT
,[DeliverableName] nvarchar(200) COLLATE DATABASE_DEFAULT
,[DeliverableCode] nvarchar(200) COLLATE DATABASE_DEFAULT
,[DeliverableParent] nvarchar(200) COLLATE DATABASE_DEFAULT
,[DeliverablePeriod] int 
,[DeliverableYear] int
,[FinancialYear] varchar(15) COLLATE DATABASE_DEFAULT
,[PlanningUnit] int
,[PlannedValue] [decimal](23, 10) 
,[ActualEarned] [decimal](23, 10)
,[PlannedVolume] int
,[ActualVolume] int
,[PayableDeliverable] varchar(3) COLLATE DATABASE_DEFAULT
,[ProfilePayment] [decimal](23, 10)
,[BalancingPayment] [decimal](23, 10)
,[ReconciliationPayment] [decimal](23, 10)
,[CappingPayment] [decimal](23, 10)
,[TotalNetPayment] [decimal](23, 10)
,[PaymentHeld] int
,[PaymentPosted] varchar(3) COLLATE DATABASE_DEFAULT
,[UnitOfProcurement] nvarchar(200) COLLATE DATABASE_DEFAULT
,[LEP] int
,[Subnominal-Profile] nvarchar(7) COLLATE DATABASE_DEFAULT
,[Subnominal-Reconciliation] nvarchar(7) COLLATE DATABASE_DEFAULT
,[Subnominal-Capping] nvarchar(7) COLLATE DATABASE_DEFAULT
,[DeliverableMonth] nvarchar(3) COLLATE DATABASE_DEFAULT
)

CREATE INDEX IX_3 on #latestVersion (DeliverablePeriod,
ContractAllocationNumber,
DeliverableCode) 


INSERT INTO #lastApproved
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
,FORMAT(DATEADD(month, dp.sfa_period, -1), 'MMM') AS DeliverableMonth
FROM
[SkillsFundingAgency_MSCRM].dbo.sfa_contractdeliverableperiod dp
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_contractdeliverable del ON dp.sfa_contractdeliverableid = del.sfa_contractdeliverableid
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_contractallocation al ON del.sfa_contractallocationid = al.sfa_contractallocationid
JOIN @fundingStreams r ON r.Value= al.sfa_fundingstreamperiodidname
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_fundingstreamperioddeliverable fspd ON del.sfa_deliverablecode = fspd.sfa_deliverablecode AND al.sfa_fundingstreamperiodid = fspd.sfa_fundingstreamperiodid
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_contract con ON al.sfa_contractid = con.sfa_contractid AND con.sfa_hierarchytype = 229660000/* Contract */
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_contract mcon ON con.sfa_parentcontractid = mcon.sfa_contractid AND mcon.sfa_hierarchytype = 229660001/* Master Contract */
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_fundingtype ft ON mcon.sfa_fundingtype = ft.sfa_fundingtypeid
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.StringMap pl ON pl.AttributeName = 'sfa_contractstatus' AND pl.ObjectTypeCode = 10007 AND pl.AttributeValue = con.sfa_contractstatus

WHERE
(fspd.sfa_setting_allowprofile = 1 OR fspd.sfa_setting_allowpayment = 1 OR fspd.sfa_setting_allowactuals = 1)
AND con.sfa_lastapprovedversion = 1


INSERT INTO #latestVersion
SELECT
al.sfa_fundingstreamperiodidname AS FundingStreamPeriodCode
,con.sfa_ukprn AS UKPRN
,con.sfa_providernamename AS  ProviderName
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
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.ActualEarned ELSE dp.sfa_actualvalue END AS ActualEarned --from last approved
,NULL AS PlannedVolume
,NULL AS ActualVolume
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.PayableDeliverable ELSE (CASE WHEN fspd.sfa_setting_allowpayment = 1 THEN 'Yes' WHEN fspd.sfa_setting_allowpayment = 0 THEN 'No' ELSE NULL END) END AS PayableDeliverable --from last approved
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.ProfilePayment ELSE dp.sfa_profilepaymentamount END AS ProfilePayment --from last approved
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.BalancingPayment ELSE dp.sfa_balancingpaymentamount END AS BalancingPayment --from last approved
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.ReconciliationPayment ELSE dp.sfa_reconciliationpaymentamount END AS ReconciliationPayment --from last approved
,la.CappingPayment AS CappingPayment
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.TotalNetPayment ELSE dp.sfa_netpaymentamount END AS TotalNetPayment --from last approved
,NULL AS PaymentHeld
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.PaymentPosted ELSE (CASE WHEN dp.sfa_paymentposted = 1 THEN 'Yes' WHEN dp.sfa_paymentposted = 0 THEN 'No' ELSE NULL END) END AS PaymentPosted --from last approved
,al.sfa_unitofprocurementidname AS UnitOfProcurement
,NULL AS LEP
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.[Subnominal-Profile] ELSE dp.sfa_profilesubnominalname END AS 'Subnominal-Profile' --from last approved
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.[Subnominal-Reconciliation] ELSE dp.sfa_reconciliationsubnominalname END AS 'Subnominal-Reconciliation' --from last approved
,dp.sfa_cappingsubnominalname AS 'Subnominal-Capping'
,FORMAT(DATEADD(month, dp.sfa_period, -1), 'MMM') AS DeliverableMonth
FROM [SkillsFundingAgency_MSCRM].dbo.sfa_contractdeliverableperiod dp
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_contractdeliverable del ON dp.sfa_contractdeliverableid = del.sfa_contractdeliverableid
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_contractallocation al ON del.sfa_contractallocationid = al.sfa_contractallocationid
JOIN @fundingStreams r ON r.Value= al.sfa_fundingstreamperiodidname 
LEFT JOIN #lastApproved la ON la.ContractAllocationNumber = al.sfa_contractallocationnumber AND la.DeliverableCode = del.sfa_deliverablecode AND la.DeliverablePeriod = dp.sfa_period AND la.DeliverableYear = dp.sfa_Year
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_fundingstreamperioddeliverable fspd ON del.sfa_deliverablecode = fspd.sfa_deliverablecode AND al.sfa_fundingstreamperiodid = fspd.sfa_fundingstreamperiodid
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_contract con ON al.sfa_contractid = con.sfa_contractid AND con.sfa_hierarchytype = 229660000/* Contract */
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_contract mcon ON con.sfa_parentcontractid = mcon.sfa_contractid AND mcon.sfa_hierarchytype = 229660001/* Master Contract */
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_fundingtype ft ON mcon.sfa_fundingtype = ft.sfa_fundingtypeid
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.StringMap pl ON pl.AttributeName = 'sfa_contractstatus' AND pl.ObjectTypeCode = 10007 AND pl.AttributeValue = con.sfa_contractstatus


WHERE
(fspd.sfa_setting_allowprofile = 1 OR fspd.sfa_setting_allowpayment = 1 OR fspd.sfa_setting_allowactuals = 1)
AND con.sfa_latestversion = 1

UPDATE la
SET la.FundingStreamPeriodCode = lv.FundingStreamPeriodCode
,la.UKPRN = lv.UKPRN
,la.ProviderName = lv.ProviderName
,la.ContractAllocationNumber = lv.ContractAllocationNumber
,la.ContractNumber = lv.ContractNumber
,la.MasterContractReference = lv.MasterContractReference
,la.ContractAllocationStartDate = lv.ContractAllocationStartDate
,la.ContractAllocationEndDate = lv.ContractAllocationEndDate
,la.ContractVersionNumber = lv.ContractVersionNumber
,la.ContractStatus = lv.ContractStatus
,la.[ContractSub-Status] = lv.[ContractSub-Status]
FROM #lastApproved la
JOIN (
SELECT 
FundingStreamPeriodCode
,UKPRN
,ProviderName
,ContractAllocationNumber
,ContractNumber
,MasterContractReference
,ContractAllocationStartDate
,ContractAllocationEndDate
,ContractVersionNumber
,ContractStatus
,[ContractSub-Status]
FROM #latestVersion) lv ON lv.ContractAllocationNumber = la.ContractAllocationNumber

SELECT
la.FundingStreamPeriodCode
,la.UKPRN
,la.ProviderName
,la.ContractAllocationNumber
,la.ContractNumber
,la.MasterContractReference
,la.ContractAllocationStartDate
,la.ContractAllocationEndDate
,la.ContractVersionNumber
,la.ContractStatus
,la.[ContractSub-Status]
,la.DeliverableDescription
,la.DeliverableName
,la.DeliverableCode
,la.DeliverableParent
,la.DeliverablePeriod
,la.DeliverableYear
,la.FinancialYear
,la.PlanningUnit
,la.PlannedValue
,la.ActualEarned
,la.PlannedVolume
,la.ActualVolume
,la.PayableDeliverable
,la.ProfilePayment
,la.BalancingPayment
,la.ReconciliationPayment
,la.CappingPayment
,la.TotalNetPayment
,la.PaymentHeld
,la.PaymentPosted
,la.UnitOfProcurement
,la.LEP
,la.[Subnominal-Profile]
,la.[Subnominal-Reconciliation]
,la.[Subnominal-Capping]
,la.DeliverableMonth
FROM #lastApproved la
LEFT JOIN #latestVersion lv ON lv.ContractAllocationNumber = la.ContractAllocationNumber 
AND lv.DeliverableCode = la.DeliverableCode 
AND lv.DeliverablePeriod = la.DeliverablePeriod
AND lv.DeliverableYear = la.DeliverableYear
WHERE lv.ContractAllocationNumber IS NULL
UNION
SELECT * FROM #latestVersion

END
ELSE
BEGIN
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
,FORMAT(DATEADD(month, dp.sfa_period, -1), 'MMM') AS DeliverableMonth
FROM
[SkillsFundingAgency_MSCRM].dbo.sfa_contractdeliverableperiod dp
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_contractdeliverable del ON dp.sfa_contractdeliverableid = del.sfa_contractdeliverableid
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_contractallocation al ON del.sfa_contractallocationid = al.sfa_contractallocationid
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_fundingstreamperioddeliverable fspd ON del.sfa_deliverablecode = fspd.sfa_deliverablecode AND al.sfa_fundingstreamperiodid = fspd.sfa_fundingstreamperiodid
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_contract con ON al.sfa_contractid = con.sfa_contractid AND con.sfa_hierarchytype = 229660000/* Contract */
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_contract mcon ON con.sfa_parentcontractid = mcon.sfa_contractid AND mcon.sfa_hierarchytype = 229660001/* Master Contract */
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.sfa_fundingtype ft ON mcon.sfa_fundingtype = ft.sfa_fundingtypeid
LEFT JOIN [SkillsFundingAgency_MSCRM].dbo.StringMap pl ON pl.AttributeName = 'sfa_contractstatus' AND pl.ObjectTypeCode = 10007 AND pl.AttributeValue = con.sfa_contractstatus
JOIN @fundingStreams r ON r.Value= al.sfa_fundingstreamperiodidname
WHERE
(fspd.sfa_setting_allowprofile = 1 OR fspd.sfa_setting_allowpayment = 1 OR fspd.sfa_setting_allowactuals = 1)
AND con.sfa_lastapprovedversion = 1
END


END
GO


