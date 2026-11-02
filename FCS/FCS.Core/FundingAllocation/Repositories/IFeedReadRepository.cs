namespace FundingAllocation.Repositories
{
    using System.Threading.Tasks;
    using Dto;

    public interface IFeedReadRepository
    {
        Task<int> CreateRead();
        Task<bool> HasLastJobCompleted();
        Task<CheckForReadCompleteResult> IsReadComplete(string fundingId);
        Task<bool> SetToCompleteIfNotAlready(int readId);
    }
}