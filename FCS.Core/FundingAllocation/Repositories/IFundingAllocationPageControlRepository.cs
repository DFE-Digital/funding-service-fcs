namespace FundingAllocation.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using DataStore.Model;

    public interface IFundingAllocationPageControlRepository
    {
        Task<FundingAllocationPageControl> GetLatest();

        Task InsertPage(int readId, int pageNumber);

        Task SetLatestBookmark(int readId, int pageNumber, string latestBookmarkOnPage);

        Task<bool> IsThereAnyNewDataToConsume(IReadOnlyCollection<string> fundingIdsOnFeed, int pageNumber);
    }
}