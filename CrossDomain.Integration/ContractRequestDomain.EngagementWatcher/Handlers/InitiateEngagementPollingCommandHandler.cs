namespace SFA.FCT.ContractRequestDomain.EngagementWatcher.Handlers
{
    using System.Linq;
    using System.Threading.Tasks;
    using Castle.Core.Internal;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.ContractRequestDomain.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class InitiateEngagementPollingCommandHandler : IHandleMessages<InitiateEngagementPollingCommand>
    {
        private const int NumItemsToTryAndRetrieve = 100;
        private readonly ILogger _logger;
        private readonly IDasRequestService _dasRequestService;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public InitiateEngagementPollingCommandHandler(
            ILogger logger,
            IDasRequestService dasRequestService,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _dasRequestService = dasRequestService;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(InitiateEngagementPollingCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractRequestDomainEventLoggingId.InitiateEngagementPollingCommandReceived,
                "InitiateEngagementPollingCommand received.");

            var connection = _sessionConnectionFactory.GetConnection(context);

            DasRequestsResult dasRequestsResult = await _dasRequestService.GetLatestDasRequests(NumItemsToTryAndRetrieve, connection);

            var sendTasks = dasRequestsResult.InitiatedEngagementEventsReceived
                .Select(dasRequest => new NewDasContractRequestCommand{DasRequest = dasRequest, DasEngagementEventId = dasRequest.DasEngagementEventId })
                .ToList().Select(context.Send).ToArray();
            
            await Task.WhenAll(sendTasks);

            if (IsThereMoreToRetrieve(dasRequestsResult.TotalEventsReceived))
            {
                await context.Send(message);
            }
            else if (IsThereMoreThanWeAskedFor(dasRequestsResult.TotalEventsReceived))
            {
                _logger.LogInformation(ContractRequestDomainEventLoggingId.InitiateEngagementPollingError,
               $"We have received more Das Requests {dasRequestsResult.TotalEventsReceived} than we were exepecting {NumItemsToTryAndRetrieve}.");
            }

            _logger.LogInformation(ContractRequestDomainEventLoggingId.InitiateEngagementPollingCommandProcessed,
                "InitiateEngagementPollingCommand processed.");
        }

        private static bool IsThereMoreToRetrieve(int numDasRequestsRetrieved)
        {
            return numDasRequestsRetrieved == NumItemsToTryAndRetrieve;
        }

        private static bool IsThereMoreThanWeAskedFor(int numDasRequestsRetrieved)
        {
            return numDasRequestsRetrieved > NumItemsToTryAndRetrieve;
        }
    }
}
