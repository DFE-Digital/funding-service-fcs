/*--------Integrity-check-Migration-Scripts---------------*/
BEGIN TRANSACTION;
GO

IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_GetDuplicatedContracts')
  BEGIN
     DROP PROCEDURE [dbo].[sp_GetDuplicatedContracts]
  END

GO
CREATE PROCEDURE [dbo].[sp_GetDuplicatedContracts]  
AS
BEGIN
select distinct * from
                      (select
                            sfa_number ContractNumber
                           ,sfa_version Version
                                                ,sfa_subversion SubVersion
	                                            ,(select count(1) from (select count(1) as numAllocs, a.sfa_contractallocationnumber 
	                                              from [dbo].[sfa_contractallocation] a where a.sfa_contractid = c.Id group by a.sfa_contractallocationnumber
	                                              having count(1) > 1)as da) NumDuplicateAllocations
	                                            ,isnull((select count(1) 
	                                                     from [dbo].sfa_contract c2 
	                                                     where c2.sfa_number = c.sfa_number
	                                                     and c2.sfa_version = c.sfa_version
	                                                     and c2.sfa_subversion = c.sfa_subversion
	                                                     group by c2.sfa_number, c2.sfa_version, c2.sfa_subversion
	                                                     having count(1) > 1), 0) NumDuplicateContracts
                                            from  dbo.sfa_contract c) t
                                            where t.NumDuplicateAllocations > 0
                                            or t.NumDuplicateContracts > 0		   

END
GO


GRANT EXECUTE ON OBJECT::dbo.sp_GetDuplicatedContracts
    TO [fcs-integritychecker] 


COMMIT;
GO

BEGIN TRANSACTION;
GO

IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_GetByAllocationNumberAndVersion')
  BEGIN
     DROP PROCEDURE [dbo].[sp_GetByAllocationNumberAndVersion]
  END
GO
CREATE PROCEDURE [dbo].[sp_GetByAllocationNumberAndVersion]  
@allocationNumber nvarchar(20),
@contractVersionNumber int,
@contractStatus int
AS
Begin
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
                 WHERE a.[sfa_contractallocationnumber] = @allocationNumber
                 AND c.[sfa_Version] = @contractVersionNumber
                 AND c.sfa_ContractStatus = @contractStatus				 

END
GO

GRANT EXECUTE ON OBJECT::dbo.sp_GetByAllocationNumberAndVersion
    TO [fcs-integritychecker] 

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_CDAExtract')
  BEGIN
     DROP PROCEDURE [dbo].[sp_CDAExtract]
  END
GO

CREATE   PROCEDURE [dbo].[sp_CDAExtract]
(@FundingStreamPeriod varchar(4000), @IsLatestVersion BIT)
AS
BEGIN
DECLARE @str VARCHAR(20)

DECLARE @fundingStreams TABLE(Value VARCHAR(20))


DECLARE @ind Int
DECLARE @input varchar(4000) = @FundingStreamPeriod

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
,[DeliveryUKPRN] NVARCHAR(100) COLLATE DATABASE_DEFAULT
,[DeliveryProviderName] NVARCHAR(320) COLLATE DATABASE_DEFAULT
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
,[Subnominal-Profile] nvarchar(10)  COLLATE DATABASE_DEFAULT
,[Subnominal-Reconciliation] nvarchar(10)  COLLATE DATABASE_DEFAULT
,[Subnominal-Capping] nvarchar(10)  COLLATE DATABASE_DEFAULT
,[DeliverableMonth] nvarchar(3)  COLLATE DATABASE_DEFAULT

,[LotReference] nvarchar(100)  COLLATE DATABASE_DEFAULT  
,[AllocationDescription] nvarchar(255)  COLLATE DATABASE_DEFAULT  
,[UnitCost] [decimal](38, 2)  
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
,[DeliveryUKPRN] NVARCHAR(100) COLLATE DATABASE_DEFAULT
,[DeliveryProviderName] NVARCHAR(320) COLLATE DATABASE_DEFAULT
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
,[Subnominal-Profile] nvarchar(10) COLLATE DATABASE_DEFAULT
,[Subnominal-Reconciliation] nvarchar(10) COLLATE DATABASE_DEFAULT
,[Subnominal-Capping] nvarchar(10) COLLATE DATABASE_DEFAULT
,[DeliverableMonth] nvarchar(3) COLLATE DATABASE_DEFAULT

,[LotReference] nvarchar(100)  COLLATE DATABASE_DEFAULT  
,[AllocationDescription] nvarchar(255)  COLLATE DATABASE_DEFAULT  
,[UnitCost] [decimal](38, 2)
)

CREATE INDEX IX_3 on #latestVersion (DeliverablePeriod,
ContractAllocationNumber,
DeliverableCode) 


INSERT INTO #lastApproved
SELECT
fsp.sfa_fundingstreamperiodcode  AS FundingStreamPeriodCode
,con.sfa_ukprn AS UKPRN
,org.name AS ProviderName
,dlyorg.sfa_ukprn AS DeliveryUKPRN
,dlyorg.name AS DeliveryProviderName
,al.sfa_contractallocationnumber AS ContractAllocationNumber
,con.sfa_number AS ContractNumber
,mcon.sfa_number  AS MasterContractReference
,FORMAT(al.sfa_startdate, 'dd/MM/yyyy') AS ContractAllocationStartDate
,FORMAT(al.sfa_enddate, 'dd/MM/yyyy') AS ContractAllocationEndDate
,con.sfa_version AS ContractVersionNumber
,pl.LocalizedLabel AS ContractStatus
,substat.sfa_name AS 'ContractSub-Status'
,del.sfa_deliverabledescription AS DeliverableDescription
,del.sfa_deliverablename AS DeliverableName
,del.sfa_deliverablecode AS DeliverableCode
,parentdel.sfa_deliverablename AS DeliverableParent
,dp.sfa_period AS DeliverablePeriod
,dp.sfa_year AS DeliverableYear
,CASE WHEN dp.sfa_period >= 4 THEN CONCAT(sfa_year, '/', RIGHT(sfa_year + 1, 2)) ELSE CONCAT(sfa_year - 1, '/', RIGHT(sfa_year, 2)) END AS FinancialYear
,NULL AS PlanningUnit
,dp.sfa_plannedvalue AS PlannedValue
,dp.sfa_actualvalue AS ActualEarned
,dp.sfa_plannedvolume AS PlannedVolume
,NULL AS ActualVolume
,CASE WHEN fspd.sfa_setting_allowpayment = 1 THEN 'Yes' WHEN fspd.sfa_setting_allowpayment = 0 THEN 'No' ELSE NULL END AS PayableDeliverable
,dp.sfa_profilepaymentamount AS ProfilePayment
,dp.sfa_balancingpaymentamount AS BalancingPayment
,dp.sfa_reconciliationpaymentamount AS ReconciliationPayment
,dp.sfa_cappedpaymentamount AS CappingPayment
,dp.sfa_netpaymentamount AS TotalNetPayment
,NULL AS PaymentHeld
,CASE WHEN dp.sfa_paymentposted = 1 THEN 'Yes' WHEN dp.sfa_paymentposted = 0 THEN 'No' ELSE NULL END AS PaymentPosted
,aluop.sfa_name AS UnitOfProcurement
,NULL AS LEP
,psub.sfa_name AS 'Subnominal-Profile'
,rsub.sfa_name AS 'Subnominal-Reconciliation'
,csub.sfa_name AS 'Subnominal-Capping'
,FORMAT(DATEADD(month, dp.sfa_period, -1), 'MMM') AS DeliverableMonth

,al.sfa_lotreference AS LotReference
,al.sfa_description AS AllocationDescription
,del.sfa_unitcost AS UnitCost  
FROM
dbo.sfa_contractdeliverableperiod dp
LEFT JOIN dbo.sfa_contractdeliverable del ON dp.sfa_contractdeliverableid = del.id
LEFT JOIN dbo.sfa_contractdeliverable parentdel ON parentdel.id = del.sfa_parentdeliverableid /*Parent Deliverable*/
LEFT JOIN dbo.sfa_contractallocation al ON del.sfa_contractallocationid = al.Id
join [dbo].[sfa_fundingstreamperiod] fsp on fsp.Id = al.sfa_fundingstreamperiodid
JOIN @fundingStreams r ON r.Value= fsp.sfa_fundingstreamperiodcode
LEFT JOIN dbo.sfa_fundingstreamperioddeliverable fspd ON del.sfa_deliverablecode = fspd.sfa_deliverablecode AND al.sfa_fundingstreamperiodid = fspd.sfa_fundingstreamperiodid
LEFT JOIN dbo.sfa_contract con ON al.sfa_contractid = con.id AND con.sfa_hierarchytype = 229660000/* Contract */
LEFT JOIN dbo.sfa_contract mcon ON con.sfa_parentcontractid = mcon.Id AND mcon.sfa_hierarchytype = 229660001/* Master Contract */
LEFT JOIN dbo.sfa_status substat ON substat.Id = con.sfa_substatus /* Contract SubStatus*/
LEFT JOIN dbo.account org ON org.Id = con.sfa_providername /* Contract Provider*/
LEFT JOIN dbo.account dlyorg ON dlyorg.Id = al.sfa_deliveryorganisationprovider /* Allocation Provider*/
LEFT JOIN dbo.sfa_unitofprocurement aluop ON aluop.id = al.sfa_unitofprocurementid /* Allocation UoP*/
LEFT JOIN dbo.sfa_fundingtype ft ON mcon.sfa_fundingtype = ft.Id
LEFT JOIN dbo.sfa_subnominalaggregation psub ON psub.Id = dp.sfa_profilesubnominal /*Subnominal-Profile*/
LEFT JOIN dbo.sfa_subnominalaggregation rsub ON rsub.Id = dp.sfa_reconciliationsubnominal /*Subnominal-Reconciliation*/
LEFT JOIN dbo.sfa_subnominalaggregation csub ON csub.Id = dp.sfa_cappingsubnominal /*Subnominal-Capping*/
LEFT JOIN dbo.GlobalOptionSetMetadata pl ON pl.[OptionSetName] = 'sfa_contractstatus' AND pl.[Option] = con.sfa_contractstatus AND pl.[LocalizedLabelLanguageCode] = 1033
WHERE
(fspd.sfa_setting_allowprofile = 1 OR fspd.sfa_setting_allowpayment = 1 OR fspd.sfa_setting_allowactuals = 1)
AND con.sfa_lastapprovedversion = 1


INSERT INTO #latestVersion
SELECT
fsp.sfa_fundingstreamperiodcode AS FundingStreamPeriodCode
,con.sfa_ukprn AS UKPRN
,org.name AS ProviderName
,dlyorg.sfa_ukprn AS DeliveryUKPRN
,dlyorg.name AS DeliveryProviderName
,al.sfa_contractallocationnumber AS ContractAllocationNumber
,con.sfa_number AS ContractNumber
,mcon.sfa_number  AS MasterContractReference
,FORMAT(al.sfa_startdate, 'dd/MM/yyyy') AS ContractAllocationStartDate
,FORMAT(al.sfa_enddate, 'dd/MM/yyyy') AS ContractAllocationEndDate
,con.sfa_version AS ContractVersionNumber
,pl.LocalizedLabel AS ContractStatus
,substat.sfa_name AS 'ContractSub-Status'
,del.sfa_deliverabledescription AS DeliverableDescription
,del.sfa_deliverablename AS DeliverableName
,del.sfa_deliverablecode AS DeliverableCode
,parentdel.sfa_deliverablename AS DeliverableParent
,dp.sfa_period AS DeliverablePeriod
,dp.sfa_year AS DeliverableYear
,CASE WHEN dp.sfa_period >= 4 THEN CONCAT(sfa_year, '/', RIGHT(sfa_year + 1, 2)) ELSE CONCAT(sfa_year - 1, '/', RIGHT(sfa_year, 2)) END AS FinancialYear
,NULL AS PlanningUnit
,dp.sfa_plannedvalue AS PlannedValue
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.ActualEarned ELSE dp.sfa_actualvalue END AS ActualEarned --from last approved
,dp.sfa_plannedvolume AS PlannedVolume
,NULL AS ActualVolume
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.PayableDeliverable ELSE (CASE WHEN fspd.sfa_setting_allowpayment = 1 THEN 'Yes' WHEN fspd.sfa_setting_allowpayment = 0 THEN 'No' ELSE NULL END) END AS PayableDeliverable --from last approved
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.ProfilePayment ELSE dp.sfa_profilepaymentamount END AS ProfilePayment --from last approved
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.BalancingPayment ELSE dp.sfa_balancingpaymentamount END AS BalancingPayment --from last approved
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.ReconciliationPayment ELSE dp.sfa_reconciliationpaymentamount END AS ReconciliationPayment --from last approved
,la.CappingPayment AS CappingPayment
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.TotalNetPayment ELSE dp.sfa_netpaymentamount END AS TotalNetPayment --from last approved
,NULL AS PaymentHeld
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.PaymentPosted ELSE (CASE WHEN dp.sfa_paymentposted = 1 THEN 'Yes' WHEN dp.sfa_paymentposted = 0 THEN 'No' ELSE NULL END) END AS PaymentPosted --from last approved
,aluop.sfa_name AS UnitOfProcurement
,NULL AS LEP
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.[Subnominal-Profile] ELSE psub.sfa_name END AS 'Subnominal-Profile' --from last approved
,CASE WHEN con.sfa_contractstatus = 229660000/* Draft */ THEN la.[Subnominal-Reconciliation] ELSE rsub.sfa_name END AS 'Subnominal-Reconciliation' --from last approved
,csub.sfa_name AS 'Subnominal-Capping'
,FORMAT(DATEADD(month, dp.sfa_period, -1), 'MMM') AS DeliverableMonth

,al.sfa_lotreference AS LotReference
,al.sfa_description AS AllocationDescription
,del.sfa_unitcost AS UnitCost  
FROM dbo.sfa_contractdeliverableperiod dp
LEFT JOIN dbo.sfa_contractdeliverable del ON dp.sfa_contractdeliverableid = del.Id
LEFT JOIN dbo.sfa_contractdeliverable parentdel ON parentdel.Id = del.sfa_parentdeliverableid /*Parent Deliverable*/
LEFT JOIN dbo.sfa_contractallocation al ON del.sfa_contractallocationid = al.Id
join [dbo].[sfa_fundingstreamperiod] fsp on fsp.Id = al.sfa_fundingstreamperiodid
JOIN @fundingStreams r ON r.Value= fsp.sfa_fundingstreamperiodcode
LEFT JOIN #lastApproved la ON la.ContractAllocationNumber = al.sfa_contractallocationnumber AND la.DeliverableCode = del.sfa_deliverablecode AND la.DeliverablePeriod = dp.sfa_period AND la.DeliverableYear = dp.sfa_Year
LEFT JOIN dbo.sfa_fundingstreamperioddeliverable fspd ON del.sfa_deliverablecode = fspd.sfa_deliverablecode AND al.sfa_fundingstreamperiodid = fspd.sfa_fundingstreamperiodid
LEFT JOIN dbo.sfa_contract con ON al.sfa_contractid = con.Id AND con.sfa_hierarchytype = 229660000/* Contract */
LEFT JOIN dbo.sfa_contract mcon ON con.sfa_parentcontractid = mcon.Id AND mcon.sfa_hierarchytype = 229660001/* Master Contract */
LEFT JOIN dbo.sfa_status substat ON substat.Id = con.sfa_substatus /* Contract SubStatus*/
LEFT JOIN dbo.account org ON org.Id = con.sfa_providername /* Contract Provider*/
LEFT JOIN dbo.account dlyorg ON dlyorg.Id = al.sfa_deliveryorganisationprovider /* Allocation Provider*/
LEFT JOIN dbo.sfa_unitofprocurement aluop ON aluop.Id = al.sfa_unitofprocurementid /* Allocation UoP*/
LEFT JOIN dbo.sfa_fundingtype ft ON mcon.sfa_fundingtype = ft.Id
LEFT JOIN dbo.sfa_subnominalaggregation psub ON psub.Id = dp.sfa_profilesubnominal /*Subnominal-Profile*/
LEFT JOIN dbo.sfa_subnominalaggregation rsub ON rsub.Id = dp.sfa_reconciliationsubnominal /*Subnominal-Reconciliation*/
LEFT JOIN dbo.sfa_subnominalaggregation csub ON csub.Id = dp.sfa_cappingsubnominal /*Subnominal-Capping*/
LEFT JOIN dbo.GlobalOptionSetMetadata pl ON pl.[OptionSetName] = 'sfa_contractstatus' AND pl.[Option] = con.sfa_contractstatus AND pl.[LocalizedLabelLanguageCode] = 1033
WHERE
(fspd.sfa_setting_allowprofile = 1 OR fspd.sfa_setting_allowpayment = 1 OR fspd.sfa_setting_allowactuals = 1)
AND con.sfa_latestversion = 1

UPDATE la
SET la.FundingStreamPeriodCode = lv.FundingStreamPeriodCode
,la.UKPRN = lv.UKPRN
,la.ProviderName = lv.ProviderName
,la.DeliveryUKPRN = lv.DeliveryUKPRN
,la.DeliveryProviderName = lv.DeliveryProviderName
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
,DeliveryUKPRN
,DeliveryProviderName
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
,la.DeliveryUKPRN
,la.DeliveryProviderName
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

,la.LotReference
,la.AllocationDescription
,la.UnitCost  
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
fsp.sfa_fundingstreamperiodcode AS FundingStreamPeriodCode
,con.sfa_ukprn AS UKPRN
,org.name AS ProviderName
,dlyorg.sfa_ukprn AS DeliveryUKPRN
,dlyorg.name AS DeliveryProviderName
,al.sfa_contractallocationnumber AS ContractAllocationNumber
,con.sfa_number AS ContractNumber
,mcon.sfa_number  AS MasterContractReference
,FORMAT(al.sfa_startdate, 'dd/MM/yyyy') AS ContractAllocationStartDate
,FORMAT(al.sfa_enddate, 'dd/MM/yyyy') AS ContractAllocationEndDate
,con.sfa_version AS ContractVersionNumber
,pl.LocalizedLabel AS ContractStatus
,substat.sfa_name AS 'ContractSub-Status'
,del.sfa_deliverabledescription AS DeliverableDescription
,del.sfa_deliverablename AS DeliverableName
,del.sfa_deliverablecode AS DeliverableCode
,parentdel.sfa_deliverablename AS DeliverableParent
,dp.sfa_period AS DeliverablePeriod
,dp.sfa_year AS DeliverableYear
,CASE WHEN dp.sfa_period >= 4 THEN CONCAT(sfa_year, '/', RIGHT(sfa_year + 1, 2)) ELSE CONCAT(sfa_year - 1, '/', RIGHT(sfa_year, 2)) END AS FinancialYear
,NULL AS PlanningUnit
,dp.sfa_plannedvalue AS PlannedValue
,dp.sfa_actualvalue AS ActualEarned
,dp.sfa_plannedvolume AS PlannedVolume
,NULL AS ActualVolume
,CASE WHEN fspd.sfa_setting_allowpayment = 1 THEN 'Yes' WHEN fspd.sfa_setting_allowpayment = 0 THEN 'No' ELSE NULL END AS PayableDeliverable
,dp.sfa_profilepaymentamount AS ProfilePayment
,dp.sfa_balancingpaymentamount AS BalancingPayment
,dp.sfa_reconciliationpaymentamount AS ReconciliationPayment
,dp.sfa_cappedpaymentamount AS CappingPayment
,dp.sfa_netpaymentamount AS TotalNetPayment
,NULL AS PaymentHeld
,CASE WHEN dp.sfa_paymentposted = 1 THEN 'Yes' WHEN dp.sfa_paymentposted = 0 THEN 'No' ELSE NULL END AS PaymentPosted
,aluop.sfa_name AS UnitOfProcurement
,NULL AS LEP
,psub.sfa_name AS 'Subnominal-Profile'
,rsub.sfa_name AS 'Subnominal-Reconciliation'
,csub.sfa_name AS 'Subnominal-Capping'
,FORMAT(DATEADD(month, dp.sfa_period, -1), 'MMM') AS DeliverableMonth

,al.sfa_lotreference AS LotReference
,al.sfa_description AS AllocationDescription
,del.sfa_unitcost AS UnitCost
FROM
dbo.sfa_contractdeliverableperiod dp
LEFT JOIN dbo.sfa_contractdeliverable del ON dp.sfa_contractdeliverableid = del.Id
LEFT JOIN dbo.sfa_contractdeliverable parentdel ON parentdel.Id = del.sfa_parentdeliverableid /*Parent Deliverable*/
LEFT JOIN dbo.sfa_contractallocation al ON del.sfa_contractallocationid = al.Id
LEFT JOIN dbo.sfa_fundingstreamperioddeliverable fspd ON del.sfa_deliverablecode = fspd.sfa_deliverablecode AND al.sfa_fundingstreamperiodid = fspd.sfa_fundingstreamperiodid
LEFT JOIN dbo.sfa_contract con ON al.sfa_contractid = con.Id AND con.sfa_hierarchytype = 229660000/* Contract */
LEFT JOIN dbo.sfa_contract mcon ON con.sfa_parentcontractid = mcon.Id AND mcon.sfa_hierarchytype = 229660001/* Master Contract */
LEFT JOIN dbo.sfa_status substat ON substat.Id = con.sfa_substatus /* Contract SubStatus*/
LEFT JOIN dbo.account org ON org.Id = con.sfa_providername /* Contract Provider*/
LEFT JOIN dbo.account dlyorg ON dlyorg.Id = al.sfa_deliveryorganisationprovider /* Allocation Provider*/
LEFT JOIN dbo.sfa_unitofprocurement aluop ON aluop.Id = al.sfa_unitofprocurementid /* Allocation UoP*/
LEFT JOIN dbo.sfa_fundingtype ft ON mcon.sfa_fundingtype = ft.Id
LEFT JOIN dbo.GlobalOptionSetMetadata pl ON pl.[OptionSetName] = 'sfa_contractstatus' AND pl.[Option] = con.sfa_contractstatus AND pl.[LocalizedLabelLanguageCode] = 1033
join [dbo].[sfa_fundingstreamperiod] fsp on fsp.Id = al.sfa_fundingstreamperiodid
LEFT JOIN dbo.sfa_subnominalaggregation psub ON psub.Id = dp.sfa_profilesubnominal /*Subnominal-Profile*/
LEFT JOIN dbo.sfa_subnominalaggregation rsub ON rsub.Id = dp.sfa_reconciliationsubnominal /*Subnominal-Reconciliation*/
LEFT JOIN dbo.sfa_subnominalaggregation csub ON csub.Id = dp.sfa_cappingsubnominal /*Subnominal-Capping*/
JOIN @fundingStreams r ON r.Value= fsp.sfa_fundingstreamperiodcode
WHERE
(fspd.sfa_setting_allowprofile = 1 OR fspd.sfa_setting_allowpayment = 1 OR fspd.sfa_setting_allowactuals = 1)
AND con.sfa_lastapprovedversion = 1
END

END
GO

GRANT EXECUTE ON OBJECT::dbo.sp_CDAExtract
    TO [fcs-integritychecker] 

COMMIT;
GO



/*--------Operation Maintenance Job---------------*/

BEGIN TRANSACTION;
GO

IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetContractReplicationFailures')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_GetContractReplicationFailures]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operations_GetContractReplicationFailures]  
AS
BEGIN

SELECT c.[sfa_number] ContractNumber, c.[sfa_version] ContractVersion, c.[sfa_subversion] ContractSubVersion, c.Id RecordId, dl.VersionNumber DeleteLogVersionNumber
                    FROM [dbo].[sfa_contract] c 
                    INNER JOIN [dbo].[DeleteLog] dl 
                    ON c.ID =  CONVERT(uniqueidentifier, dl.recordid)  
                    AND dl.VersionNumber > c.VersionNumber	   

END
GO


GRANT EXECUTE ON OBJECT::dbo.sp_Operations_GetContractReplicationFailures
    TO [fcs-integritychecker] 


COMMIT;
GO
/*---------------------------------------------*End Procedure*---------------------------------------------*/

BEGIN TRANSACTION;
GO

IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_DeleteContactDeliverablePeriodsForContractId')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_DeleteContactDeliverablePeriodsForContractId]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operations_DeleteContactDeliverablePeriodsForContractId]  
@contractId nvarchar(40)
AS
BEGIN

delete from [dbo].[sfa_contractdeliverableperiod] 
                                where Id in (
                                select cdp.id
                                from [dbo].[sfa_contractdeliverableperiod] cdp, 
                                [dbo].[sfa_contractdeliverable] cd,
                                [dbo].[sfa_contractallocation] a
                                where cdp.[sfa_contractdeliverableid] = cd.id
                                and cd.sfa_contractallocationid = a.id
                                and a.sfa_contractid = @contractId)
END
GO


GRANT EXECUTE ON OBJECT::dbo.sp_Operations_DeleteContactDeliverablePeriodsForContractId
    TO [fcs-integritychecker] 


COMMIT;
GO

/*---------------------------------------------*End Procedure*---------------------------------------------*/

BEGIN TRANSACTION;
GO

IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_DeleteContactDeliverablesForContractId')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_DeleteContactDeliverablesForContractId]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operations_DeleteContactDeliverablesForContractId]  
@contractId nvarchar(40)
AS
BEGIN

delete from [dbo].[sfa_contractdeliverable] 
                                where Id in (
                                select cd.id 
                                from [dbo].[sfa_contractdeliverable] cd,
                                [dbo].[sfa_contractallocation] a
                                where cd.sfa_contractallocationid = a.id
                                and a.sfa_contractid = @contractId)
END
GO


GRANT EXECUTE ON OBJECT::dbo.sp_Operations_DeleteContactDeliverablesForContractId
    TO [fcs-integritychecker] 


COMMIT;
GO

/*---------------------------------------------*End Procedure*---------------------------------------------*/

BEGIN TRANSACTION;
GO

IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_DeleteContactAllocationsForContractId')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_DeleteContactAllocationsForContractId]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operations_DeleteContactAllocationsForContractId]  
@contractId nvarchar(40)
AS
BEGIN

delete from [dbo].[sfa_contractallocation] 
                                where Id in (
                                select a.id 
                                from [dbo].[sfa_contractallocation] a
                                where a.sfa_contractid = @contractId)
END
GO


GRANT EXECUTE ON OBJECT::dbo.sp_Operations_DeleteContactAllocationsForContractId
    TO [fcs-integritychecker] 


COMMIT;



/*---------------------------------------------*End Procedure*---------------------------------------------*/

BEGIN TRANSACTION;
GO

IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetContractReplicationFailures')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_GetContractReplicationFailures]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operations_GetContractReplicationFailures]
AS
BEGIN

SELECT c.[sfa_number] ContractNumber, c.[sfa_version] ContractVersion, c.[sfa_subversion] ContractSubVersion, c.Id RecordId, dl.VersionNumber DeleteLogVersionNumber
                    FROM [dbo].[sfa_contract] c 
                    INNER JOIN [dbo].[DeleteLog] dl 
                    ON c.ID =  CONVERT(uniqueidentifier, dl.recordid)  
                    AND dl.VersionNumber > c.VersionNumber
END
GO


GRANT EXECUTE ON OBJECT::dbo.sp_Operations_GetContractReplicationFailures
    TO [fcs-integritychecker] 


COMMIT;

/*---------------------------------------------*End Procedure*---------------------------------------------*/

