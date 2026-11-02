namespace ActualsPull.Dc
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Adapters;
    using AllocationDelivery.Messages.Commands;
    using DTOs;
    using Infrastructure;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class BeginDcActualsPullHandler : IHandleMessages<BeginDcActualsPullCommand>
    {
        private readonly ILogger _logger;
        private readonly IDcAdapter _dcAdapter;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IClosedCollectionRepository _closedCollectionRepository;

        public BeginDcActualsPullHandler(
            ILogger logger,
            IDcAdapter dcAdapter,
            ISessionConnectionFactory sessionConnectionFactory,
            IClosedCollectionRepository closedCollectionRepository)
        {
            _logger = logger;
            _dcAdapter = dcAdapter;
            _sessionConnectionFactory = sessionConnectionFactory;
            _closedCollectionRepository = closedCollectionRepository;
        }

        public async Task Handle(BeginDcActualsPullCommand message, IMessageHandlerContext context)
        {
           _logger.LogInformation(1300, "BeginDcActualsPullCommand arrived");

           ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

           DateTime latestClosedCollectionDate = await _closedCollectionRepository
               .GetLatestClosedDateTime(connectionInfo.Connection, connectionInfo.Transaction);

           _logger.LogInformation(1302, $"BeginDcActualsPullCommand - latest closed date is: {latestClosedCollectionDate}");
           
           IReadOnlyCollection<ClosedCollection> closedCollections = await _dcAdapter.GetClosedCollectionsSince(latestClosedCollectionDate);

           _logger.LogInformation(1301, "BeginDcActualsPullCommand processed");
        }
    }
}
