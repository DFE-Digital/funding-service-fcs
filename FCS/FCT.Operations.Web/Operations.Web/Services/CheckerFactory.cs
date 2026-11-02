namespace Operations.Web.Services
{
    using System.Configuration;
    using System;
    using System.Collections.Generic;
    using System.ServiceModel;
    using System.Threading.Tasks;
    using Checkers;
    using DedsSearchService;
    using Dtos;
    using Enums;
    using Factory;
    using GatewayServiceContract;
    using Repositories;
    using SFA.FCT.Framework.Logging;

    public class CheckerFactory : ICheckerFactory
    {
        public Dictionary<string, Func<Task<AvailabilityCheckResult>>>  GetAvailabilityCheckerDictionary()
        {
            return new Dictionary<string, Func<Task<AvailabilityCheckResult>>>
            {
                {"Das", GetDasCheckAvailability },
                {"Dct", GetDctCheckAvailability},
                {"Crm", GetCrmCheckAvailability},
                {"Sharepoint", GetSharepointCheckAvailability},
                {"OrgSvc", GetOrgSvcAvailability},
                {"FeedSetting", GetFeedSettingAvailability},
                {"ContractFeed", GetContractFeedAvailability},
                {"AdpFeed", GetAdpFeedCheckAvailability },
                {"Cpds", GetCpdsCheckAvailabilityFunction},
                {"UkrlpService", GetUkrlpCheckAvailability },
                {"CfsNotificationFeed", GetCfsNotificationFeedCheckAvailability },
                {"CfsProviderApi", GetCfsProviderApiCheckAvailability },
            };
        }

        private async Task<AvailabilityCheckResult> GetDasCheckAvailability()
        {
            var dasCheckAvailability = new DasCheckAvailability(new ConnectivityRepository());

            return await dasCheckAvailability.GetCheckResult();
        }

        private async Task<AvailabilityCheckResult> GetDctCheckAvailability()
        {
            using (var http = new HttpUtility())
            {
                return await new DctCheckAvailability(http, new OAuthAccessTokenFactoryDct()).GetCheckResult().ConfigureAwait(false);
            }
        }


        private async Task<AvailabilityCheckResult> GetContractFeedAvailability()
        {
            using (var http = new HttpUtility())
            {
                return
                    await
                        new FeedReadCheckAvailability(http, new AuthenticationHelper(),
                            CheckerHttpRequestInformationFactory.GetAuthenticationForService(ServiceInterface.ContractFeed))
                            .GetCheckResult().ConfigureAwait(false);
            }
        }

        private async Task<AvailabilityCheckResult> GetSharepointCheckAvailability()
        {
            return await new SharepointCheckAvailability(SharepointAuthHelper.GetOAuthContext, "Sharepoint").GetCheckResult();
        }

        private async Task<AvailabilityCheckResult> GetOrgSvcAvailability()
        {
            using (var http = new HttpUtility())
            {
                return await new OrgServiceCheckAvailability(
                    http,
                    new AuthenticationHelper(),
                    CheckerHttpRequestInformationFactory.GetAuthenticationForService(ServiceInterface.OrgService))
                    .GetCheckResult()
                    .ConfigureAwait(false);
            }
        }

        private async Task<AvailabilityCheckResult> GetCrmCheckAvailability()
        {
            return await new CrmCheckAvailability().GetCheckResult().ConfigureAwait(false);
        }

        private async Task<AvailabilityCheckResult> GetFeedSettingAvailability()
        {
            using (var http = new HttpUtility())
            {
                return await new FeedReadCheckAvailability(http, new AuthenticationHelper(),
                            CheckerHttpRequestInformationFactory.GetAuthenticationForService(ServiceInterface.DeliverableSettingFeed))
                            .GetCheckResult().ConfigureAwait(false);
            }
        }

        private async Task<AvailabilityCheckResult> GetCpdsCheckAvailabilityFunction()
        {
            var checkAvailabilityService = new CpdsCheckAvailability(new ConnectivityRepository());

            return await checkAvailabilityService.GetCheckResult();
        }

        private async Task<AvailabilityCheckResult> GetAdpFeedCheckAvailability()
        {
            using (var http = new HttpUtility())
            {
                return await new FeedReadCheckAvailability(http, new AuthenticationHelper(),
                            CheckerHttpRequestInformationFactory.GetAuthenticationForService(ServiceInterface.AdpFeed))
                            .GetCheckResult().ConfigureAwait(false);
            }
        }

        private async Task<AvailabilityCheckResult> GetUkrlpCheckAvailability()
        {
            UkrlpServiceQuerier ukrlpServiceQuerier = new UkrlpServiceQuerier();
            return await new UkrlpCheckAvailability(ukrlpServiceQuerier).GetCheckResult().ConfigureAwait(false);
        }

        private async Task<AvailabilityCheckResult> GetCfsNotificationFeedCheckAvailability()
        {
            var cfsNotificationFeedCheckAvailability = new CfsNotificationFeedCheckAvailability(new ConnectivityRepository());

            return await cfsNotificationFeedCheckAvailability.GetCheckResult();
        }

        private async Task<AvailabilityCheckResult> GetCfsProviderApiCheckAvailability()
        {
            var cfsProviderApiCheckAvailability = new CfsProviderApiCheckAvailability(new ConnectivityRepository());

            return await cfsProviderApiCheckAvailability.GetCheckResult();
        }

        private static IDedsSearchServiceChannel CreateDedsChannel()
        {
            ChannelFactory<IDedsSearchServiceChannel> channelFactory = new ChannelFactory<IDedsSearchServiceChannel>("BasicHttpBinding_IDedsSearchService");
            return channelFactory.CreateChannel();
        }

        private static GatewayServiceContractChannel CreateGatewayChannel()
        {
            ChannelFactory<GatewayServiceContractChannel> channelFactory = new ChannelFactory<GatewayServiceContractChannel>("BasicHttpBinding_GatewayServiceContract");
            return channelFactory.CreateChannel();
        }

        private async Task<AvailabilityCheckResult> CallServiceAndHandleException(Func<Task<AvailabilityCheckResult>> callService, string serviceName)
        {
            try
            {
                return await callService();
            }
            catch (Exception e)
            {
                return new AvailabilityCheckResult(serviceName, false)
                {
                    Details = e.Message
                };
            }
        }
    }
}