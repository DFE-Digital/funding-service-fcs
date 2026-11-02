select *
from FundingAllocation.FundingAllocation
where Status = 'Parked'

select AllocationFundingStream, SubStatus, count(*) as ct
from FundingAllocation.FundingAllocation
where Status = 'Parked'
group by AllocationFundingStream, SubStatus
order by 1,2



Select top 22*
from ContractManagement.AtomFeedItem
order by 6 desc

select *
from Operations.DeployedConfigVersion
order by 4 desc