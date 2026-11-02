namespace FCT.Operations.Connectivity
{
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Common;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;

    public class CheckConnectivityReplyHandler : IHandleMessages<CheckConnectivityReply>
    {
        private readonly ILogger _logger;
        private readonly IConnectivityRepository _connectivityRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;


        public CheckConnectivityReplyHandler(ILogger logger, IConnectivityRepository connectivityRepository, ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _connectivityRepository = connectivityRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(CheckConnectivityReply message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingEventId.CheckConnectivityReplyReceived, $"Received CheckConnectivityReply {message}");

            var connectionInfo = _sessionConnectionFactory.GetConnection(context);

            foreach (var result in message.Results)
            {
                await _connectivityRepository.InsertOrUpdateConnectivity(result.Service,
                    result.CanConnect, result.ErrorInfo,
                    result.SupplementaryInfo, connectionInfo);
            }

            _logger.LogInformation(LoggingEventId.CheckConnectivityReplyProcessed, $"Processed CheckConnectivityReply {message}");
        }
    }
}