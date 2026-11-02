namespace FundingAllocation.Endpoints.Operational
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Extensions;
    using Microsoft.Extensions.Configuration;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CheckCfsConnectivityHandler : IHandleMessages<CheckConnectivityCommand>
    {
        private readonly ILogger _logger;
        private readonly IFundingNotificationApi _fundingNotificationApi;
        private readonly IConfigurationRoot _configuration;

        public CheckCfsConnectivityHandler(ILogger logger, IFundingNotificationApi fundingNotificationApi, IConfigurationRoot configuration)
        {
            _logger = logger;
            _fundingNotificationApi = fundingNotificationApi;
            _configuration = configuration;
        }

        public async Task Handle(CheckConnectivityCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.CheckConnectivityCommandReceived, $"Received CheckConnectivityCommand {message}");

            var latestPageResult = await CanConnectToCfsLatestPage();
            var rootUrl = _configuration["CFS:RootUrl"];
         
            var providerResult = await CanConnectToCfsProvider(latestPageResult.providerFundingId);
             
            CheckConnectivityReply replyMessage = new CheckConnectivityReply(new List<CheckConnectivityReply.Result>
            {
                (latestPageResult.canConnect, latestPageResult.errorInfo).ToCheckConnectivityResult("CFS_API", rootUrl),
                providerResult.ToCheckConnectivityResult("CFS_PROVIDER_API", rootUrl)
            });

            await context.Reply(replyMessage);

            _logger.LogInformation(LoggingId.CheckConnectivityCommandProcessed, $"Processed CheckConnectivityCommand {message}");
        }

        private async Task<(bool canConnect, string errorInfo, string providerFundingId)> CanConnectToCfsLatestPage()
        {
            try
            {
                var latestPage = await _fundingNotificationApi.GetLatestPageData();
                string providerFundingId = null;
                if (latestPage.AtomItems.Any())
                {
                    providerFundingId = latestPage.AtomItems.First().ProviderFundingIds.FirstOrDefault();
                }

                return (true, string.Empty, providerFundingId);
            }
            catch (Exception e)
            {
                return (false, e.Message, string.Empty);
            }
        }

        private async Task<(bool canConnect, string errorInfo)> CanConnectToCfsProvider(string providerFundingId)
        {
            try
            {
                await _fundingNotificationApi.GetProviderFundingAllocation(providerFundingId);
                
                return (true, string.Empty);
            }
            catch (Exception e)
            {
                return (false, e.Message);
            }
        }
    }
}
