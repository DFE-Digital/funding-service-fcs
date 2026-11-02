namespace AllocationDeliveryDomain.Endpoint.ActualsPullComplete
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using AllocationDelivery.Messages.Commands;
    using AllocationDelivery.Messages.DTOs;
    using Infrastructure;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ClosedCollection = SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model.ClosedCollection;

    public class CheckForCollectionReturnCompleteHandler : IHandleMessages<CheckForCollectionReturnCompleteCommand>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IClosedCollectionCompleteRepository _closedCollectionCompleteRepository;
        private readonly ISummarisedActualsQueryRepository _summarisedActualsQueryRepository;

        public CheckForCollectionReturnCompleteHandler(
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory,
            IClosedCollectionCompleteRepository closedCollectionCompleteRepository,
            ISummarisedActualsQueryRepository summarisedActualsQueryRepository)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _closedCollectionCompleteRepository = closedCollectionCompleteRepository;
            _summarisedActualsQueryRepository = summarisedActualsQueryRepository;
        }

        public async Task Handle(CheckForCollectionReturnCompleteCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.CheckForCollectionReturnCompleteCommandArrived, $"CheckForCollectionReturnCompleteCommand arrived: {message}");

            var connectionInfo = _sessionConnectionFactory.GetConnection(context);

            ClosedCollection closedCollection = await _closedCollectionCompleteRepository.Get(
                connection: connectionInfo.Connection,
                transaction: connectionInfo.Transaction,
                collectionType: message.CollectionType, 
                collectionReturnCode: message.CollectionReturnCode);

            if (!closedCollection.IsComplete())
            {
                _logger.LogInformation(AllocationDeliverDomainEventLoggingId.CheckForCollectionReturnCompleteNotComplete, $"Collection is not complete : {message}" +
                                                                                                                          $" retrieved: {closedCollection.RetrievedRowCount}, total: {closedCollection.TotalRowCount}");
                var rowCountForCollectionReturn = await _summarisedActualsQueryRepository.GetCountForCollectionReturn(
                    message.CollectionType, message.CollectionReturnCode, connectionInfo);

                if (rowCountForCollectionReturn == closedCollection.TotalRowCount)
                {
                    _logger.LogInformation(AllocationDeliverDomainEventLoggingId.CheckForCollectionReturnCompleteIsComplete, $"Collection is complete : {message}");

                    // now try to update and check it succeeded
                    int rowsUpdated = await _closedCollectionCompleteRepository.UpdateRowToCompletedIfNoOneElseHas(
                        connectionInfo.Connection,
                        connectionInfo.Transaction,
                        message.CollectionType,
                        message.CollectionReturnCode,
                        rowCountForCollectionReturn);
                    if (rowsUpdated == 1)
                    {
                        IReadOnlyCollection<ActualOrgFspGroupKeyResult> groups = await _summarisedActualsQueryRepository.GetOrgFspGroups(
                            collectionType: message.CollectionType,
                            collectionReturnCode: message.CollectionReturnCode,
                            connectionInfo);

                        var messageSendTasks = groups.Select(g => new ReportedActualsRoutingCommand
                        {
                            SummarisedActualOrgFspGroupKey = new SummarisedActualOrgFspGroupKey
                            {
                                CollectionType = message.CollectionType,
                                CollectionReturnCode = message.CollectionReturnCode,
                                FundingStreamPeriodCode = g.FundingStreamPeriodCode,
                                OrganisationId = g.OrganisationId,
                                UopCode = g.UopCode
                            }
                        }).Select(context.Send).ToList();

                        await Task.WhenAll(messageSendTasks);
                    }
                }
            }

            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.CheckForCollectionReturnCompleteCommandProcessed, $"CheckForCollectionReturnCompleteCommand arrived: {message}");
        }
    }
}
