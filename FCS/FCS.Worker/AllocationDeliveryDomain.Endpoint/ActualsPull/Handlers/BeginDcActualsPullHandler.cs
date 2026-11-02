namespace AllocationDeliveryDomain.Endpoint.ActualsPull.Handlers
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Threading.Tasks;
    using Adapters;
    using AllocationDelivery.Messages.Commands;
    using AllocationDelivery.Messages.DTOs;
    using Endpoint.Repositories;
    using Infrastructure;
    using NServiceBus;
    using SFA.FCT.AllocationDeliveryDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class BeginDcActualsPullHandler : IHandleMessages<BeginDcActualsPullCommand>
    {
        private readonly ILogger _logger;
        private readonly IDcAdapter _dcAdapter;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IClosedCollectionRepository _closedCollectionRepository;
        private readonly IMonthEndStartRepository _monthEndStartRepository;

        public BeginDcActualsPullHandler(
            ILogger logger,
            IDcAdapter dcAdapter,
            ISessionConnectionFactory sessionConnectionFactory,
            IClosedCollectionRepository closedCollectionRepository,
            IMonthEndStartRepository monthEndStartRepository)
        {
            _logger = logger;
            _dcAdapter = dcAdapter;
            _sessionConnectionFactory = sessionConnectionFactory;
            _closedCollectionRepository = closedCollectionRepository;
            _monthEndStartRepository = monthEndStartRepository;
        }

        public static int PageSize => int.Parse(ConfigurationManager.AppSettings["DCT:PageSize"]);

        public async Task Handle(BeginDcActualsPullCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.BeginDcActualsPullCommandArrived, "BeginDcActualsPullCommand arrived");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            DateTime latestClosedCollectionDate = await _closedCollectionRepository
                .GetLatestClosedDateTime(connectionInfo.Connection, connectionInfo.Transaction);

            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.BeginDcActualsPullLatestDate, $"BeginDcActualsPullCommand - latest closed date is: {latestClosedCollectionDate}");

            IReadOnlyCollection<ClosedCollection> closedCollections = await _dcAdapter.GetClosedCollectionsSince(latestClosedCollectionDate.AddSeconds(1));

            await _monthEndStartRepository.CreateNewMonthEndEntry(connectionInfo.Connection, connectionInfo.Transaction);

            await context.Send(new CheckForMonthEndCompletionCommand());

            foreach (var cc in closedCollections.ToList())
            {
                await CreateClosedCollectionInDb(cc, connectionInfo);
            }
            
            IEnumerable<Task> sendTasks = closedCollections
                .SelectMany(cc =>
                {
                    var totalPages = _dcAdapter.GetNumPages(cc.TotalRowCount, PageSize);
                    return Enumerable.Range(1, totalPages).Select(pageNumber => new PullClosedCollectionPageCommand
                    {
                        CollectionType = cc.CollectionType,
                        CollectionReturnCode = cc.CollectionReturnCode,
                        PageNumber = pageNumber,
                        PageSize = PageSize
                    });
                })
                .Select(context.Send);

            await Task.WhenAll(sendTasks);
                
            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.BeginDcActualsPullCommandProcessed, "BeginDcActualsPullCommand processed");
        }

        private async Task CreateClosedCollectionInDb(ClosedCollection closedCollection, ConnectionInfo connectionInfo)
        {
            var model = new SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model.ClosedCollection(
                collectionType:closedCollection.CollectionType,
                collectionReturnCode:closedCollection.CollectionReturnCode,
                closedTime: closedCollection.ClosedTime,
                totalRowCount:closedCollection.TotalRowCount);

            await _closedCollectionRepository.CreateClosedCollection(
                connectionInfo.Connection,
                connectionInfo.Transaction,
                model);
        }
    }
}
