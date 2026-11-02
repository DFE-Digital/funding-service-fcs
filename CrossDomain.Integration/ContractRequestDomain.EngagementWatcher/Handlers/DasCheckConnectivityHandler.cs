namespace ContractRequestDomain.EngagementWatcher.Handlers
{
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;

    public class DasCheckConnectivityHandler : IHandleMessages<CheckConnectivityCommand>
    {
        private readonly IDasEventsApiAdapter _dasEventsApiAdapter;
        private readonly ILogger _logger;

        public DasCheckConnectivityHandler(IDasEventsApiAdapter dasEventsApiAdapter, ILogger logger)
        {
            _dasEventsApiAdapter = dasEventsApiAdapter;
            _logger = logger;
        }

        public async Task Handle(CheckConnectivityCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractRequestDomainEventLoggingId.DasCheckConnectivityCommandReceived, "CheckConnectivityCommand received");

            var canConnectResult = CanConnectToDasApi();

            CheckConnectivityReply replyMessage = new CheckConnectivityReply(new List<CheckConnectivityReply.Result>
            {
                new CheckConnectivityReply.Result("DAS", canConnectResult.canConnect, canConnectResult.errorInfo, _dasEventsApiAdapter.BaseUrl)
            });

            await context.Reply(replyMessage);

            _logger.LogInformation(ContractRequestDomainEventLoggingId.DasCheckConnectivityCommandProcessed, "CheckConnectivityCommand processed");
        }

        private (bool canConnect, string errorInfo) CanConnectToDasApi()
        {
            try
            {
                _dasEventsApiAdapter.GetEngagementEventsAfterId(1,1);

                return (true, string.Empty);
            }
            catch (Exception e)
            {
                return (false, e.Message);
            }
        }
    }
}
