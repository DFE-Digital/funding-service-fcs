namespace FundingAllocation.Endpoints.ReleaseGroup.Repositories
{
    using System.Threading.Tasks;

    public interface IContractNumberQueryRepository
    {
        Task<int> GetNextContractNumberForFundingType(string fundingType);
        Task<int> GetNextMasterContractNumber();
        int GetNextAllocationNumber(string fundingStreamCode);
    }
}