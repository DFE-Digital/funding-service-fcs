select *
from FundingAllocation.AllocationFundingStreamConfig
order by 1

Select *
from FundingAllocation.CfsCodesToContractTypeConfig
order by 1,2,4

select *
from FundingAllocation.ProviderTypeConfig
order by 2

select *
from FundingAllocation.AllocationLineConfig
order by 3,4,6

select *
from DocumentsDomain.UploadedDocumentTemplate
where Templatename like '%EDSK2122%'
order by 1