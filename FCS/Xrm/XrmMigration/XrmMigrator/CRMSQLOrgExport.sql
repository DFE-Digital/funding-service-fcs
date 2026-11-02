-- This needs to be run against the CRM Organization Database (i.e. ORGNAME_MSCRM) as a SQL Administrator
-- This will create a number of update statements with all the current OrgIds that CRM knows about into it.

SELECT 
'UPDATE PaymentGeneration.SubnominalAggregation SET OrganisationId = ''' +  sfa_organisationid +''' WHERE  Ukprn='''+ sfa_ukprn + ''''
FROM Account 
WHERE sfa_ukprn is not null
AND sfa_organisationid is not null
UNION ALL
SELECT
'UPDATE PaymentSchedule.OrganisationIdentifer SET MainOrganisationIdentifier = ''' +  sfa_organisationid +''' WHERE OrganisationId='''+ sfa_ukprn + ''''
FROM Account 
WHERE sfa_ukprn is not null
AND sfa_organisationid is not null