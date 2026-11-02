namespace FundingAllocation.Endpoints.CheckForReadComplete
{
    using System.Threading.Tasks;

    public interface ICheckForReadCompleteNotificationService
    {
        Task NotifySlackRegardingParkedFundingAllocations(int readId);
    }
}