namespace FundingAllocation.Repositories
{
    using System.Threading.Tasks;

    public interface IProcessedMessageRepository
    {
        Task Deduplicate(string messageId, string endpoint, string messageType, string businessKey);
    }
}