namespace FundingAllocation.Endpoints.ReleaseGroup.Repositories
{
    using System.Threading.Tasks;

    public interface IFundingTypeRepository
    {
        Task<string> GetContractNumberPrefix(string fundingTypeCode);
    }
}
