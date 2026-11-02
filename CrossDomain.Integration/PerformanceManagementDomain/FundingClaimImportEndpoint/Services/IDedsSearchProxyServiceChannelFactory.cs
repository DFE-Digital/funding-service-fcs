namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Services
{
    using DedsSearchService;

    public interface IDedsSearchProxyServiceChannelFactory
    {
        IDedsSearchServiceChannel Create();
    }
}
