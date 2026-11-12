
using System.ServiceModel;
using System.Configuration;
using SFA.FCT.PerformanceManagementDomain.DedsSearchService;

namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Services
{
    public class DedsSearchProxyServiceChannelFactory : IDedsSearchProxyServiceChannelFactory
    {
        public IDedsSearchServiceChannel Create()
        {
            string url = ConfigurationManager.AppSettings["DedsService.Url"];
            string bindingName = ConfigurationManager.AppSettings["DedsService.BindingName"];

            var binding = DedsBindingFactory.Create(bindingName);
            var address = new EndpointAddress(url);

            // ⭐ The CORRECT .NET 8 WCF approach
            var channelFactory = new ChannelFactory<IDedsSearchServiceChannel>(binding, address);

            return channelFactory.CreateChannel();  // returns IDedsSearchServiceChannel
        }
    }
}
