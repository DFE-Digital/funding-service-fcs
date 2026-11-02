namespace OrganisationDomain.Integration.MainEndpoint.Handlers
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.ServiceModel.Configuration;
    using System.Threading.Tasks;
    using Common;
    using Implementation.BusinessLogic;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CheckConnectivityCpdsCommandHandler : IHandleMessages<CheckConnectivityCommand>
    {
        private readonly ICpdsOrganisationRetriever _cpdsOrganisationRetriever;
        private readonly ILogger _logger;

        public CheckConnectivityCpdsCommandHandler(ILogger logger, ICpdsOrganisationRetriever cpdsOrganisationRetriever)
        {
            _logger = logger;
            _cpdsOrganisationRetriever = cpdsOrganisationRetriever;
        }

        public async Task Handle(CheckConnectivityCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(OrganisationDomainEventLoggingId.CheckConnectivityCommandReceived, $"CheckConnectivityCommand message received: {_cpdsOrganisationRetriever}");
            
            var canConnectResult = CanConnectToCpds();
            var client = ConfigurationManager.GetSection("system.serviceModel/client") as ClientSection;
            var cpdsConfig = client.Endpoints.Cast<ChannelEndpointElement>()
                .SingleOrDefault(endpoint => endpoint.Contract == "GatewayServiceContract");

            var result = new CheckConnectivityReply.Result(
                service: "CPDS",
                canConnect: canConnectResult.canConnect,
                errorInfo: canConnectResult.errorInfo,
                supplementaryInfo: cpdsConfig?.Address.AbsoluteUri);

            await context.Reply(new CheckConnectivityReply(new List<CheckConnectivityReply.Result>{result}));

            _logger.LogInformation(OrganisationDomainEventLoggingId.CheckConnectivityCommandComplete, $"CheckConnectivityCommand message processed, result: {result}");
        }

        private (bool canConnect, string errorInfo) CanConnectToCpds()
        {
            try
            {
                var response = _cpdsOrganisationRetriever.GetProviderByUkprn(99990003);

                return (true, null);
            }
            catch (Exception ex)
            {
                return (false, ex.Message);
            }
        }
    }
}
