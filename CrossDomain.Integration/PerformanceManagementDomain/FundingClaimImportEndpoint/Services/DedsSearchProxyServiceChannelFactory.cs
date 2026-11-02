namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Services
{
    using System.ServiceModel;
    using DedsSearchService;

    public class DedsSearchProxyServiceChannelFactory : IDedsSearchProxyServiceChannelFactory
    {
        private readonly ChannelFactory<IDedsSearchServiceChannel> _channelFactory;

        public DedsSearchProxyServiceChannelFactory()
        {
            _channelFactory = new ChannelFactory<IDedsSearchServiceChannel>("BasicHttpBinding_IDedsSearchService");
        }

        public IDedsSearchServiceChannel Create()
        {
            return _channelFactory.CreateChannel();
        }
    }
}
