namespace AllocationDeliveryDomain.Endpoint.ActualsPull.Handlers
{
    using System.Threading.Tasks;
    using Adapters;
    using AllocationDelivery.Messages.Commands;
    using Endpoint.Repositories;
    using Infrastructure;
    using NServiceBus;
    using SFA.FCT.AllocationDeliveryDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class PullClosedCollectionPageHandler : IHandleMessages<PullClosedCollectionPageCommand>
    {
        private readonly ILogger _logger;
        private readonly IDcAdapter _dcAdapter;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly ISummarisedActualsRepository _summarisedActualsRepository;

        public PullClosedCollectionPageHandler(ILogger logger, IDcAdapter dcAdapter, ISessionConnectionFactory sessionConnectionFactory, ISummarisedActualsRepository summarisedActualsRepository)
        {
            _logger = logger;
            _dcAdapter = dcAdapter;
            _sessionConnectionFactory = sessionConnectionFactory;
            _summarisedActualsRepository = summarisedActualsRepository;
        }

        public async Task Handle(PullClosedCollectionPageCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.PullClosedCollectionPageArrived, $"PullClosedCollectionPageCommand arrived: {message}");

            var summarisedActualsPage = await _dcAdapter.GetClosedCollectionsPage(message.CollectionType, message.CollectionReturnCode,
                message.PageNumber, message.PageSize);

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            await _summarisedActualsRepository.AddActuals(summarisedActualsPage, connectionInfo);

            await context.Send(new CheckForCollectionReturnCompleteCommand
            {
                CollectionType = message.CollectionType,
                CollectionReturnCode = message.CollectionReturnCode
            });

            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.PullClosedCollectionPageProcessed, $"PullClosedCollectionPageCommand arrived: {message}");
        }
    }
}
