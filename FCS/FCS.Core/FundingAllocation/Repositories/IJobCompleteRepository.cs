namespace FundingAllocation.Repositories
{
    using System.Threading.Tasks;

    public interface IJobCompleteRepository
    {
        Task<bool> IsJobComplete(int readId);
        Task SetJobComplete(int readId);
        Task SetCfsReadComplete(int readId);
    }
}