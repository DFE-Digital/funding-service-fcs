namespace FundingAllocation.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dto;

    public interface IAllocationLineConfigRepository
    {
        Task<IReadOnlyCollection<AllocationLineDeliverableInfo>> GetAllocationLineConfigs(
            string allocationFundingStreamCode,
            string allocationPeriodId,
            string fundingLineCode);
    }
}