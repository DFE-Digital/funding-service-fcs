namespace FundingAllocation.Services
{
    using System.Threading.Tasks;
    using System.Collections.Generic;

    public interface IFundingIdService
    {
        Task<(IReadOnlyCollection<string> lastestFundingIds, IReadOnlyCollection<string> supersededFundingIds)> GetFundingIdsForLatestVersions(int readId);

        Task<IReadOnlyCollection<string>> GetProviderNotFoundToBeSuperseded();
    }
}