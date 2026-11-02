namespace FundingAllocation.Endpoints.CreateProvidersIfNecessaryReply.Services
{
    using System.Threading.Tasks;

    public interface ICreateProvidersIfNecessaryNotificationService
    {
        Task NotifySlackRegardingProviderNotFoundChangedToConfigFailure(string fundingId);
    }
}