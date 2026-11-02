namespace AllocationDeliveryDomain.Endpoint.ReleaseHeldReportedActualsEndpoint.Handlers
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using AllocationDelivery.Messages.Commands;
    using AllocationDelivery.Messages.DTOs;
    using Infrastructure;
    using NServiceBus;
    using SFA.FCT.AllocationDeliveryDomain.Common;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Dto;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ReleaseHeldReportedActualsHandler : IHandleMessages<ReleaseHeldReportedActualsCommand>
    {
        private readonly ILogger _logger;
        private readonly IHeldPartitionKeyQueryService _heldPartitionKeyQueryService;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IHeldReportedActualGroupCommandRepository _heldReportedActualGroupCommandRepository;
        private readonly IHeldReportedActualGroupQueryRepository _heldReportedActualGroupQueryRepository;

        public ReleaseHeldReportedActualsHandler(
            ILogger logger,
            IHeldPartitionKeyQueryService heldPartitionKeyQueryService,
            ISessionConnectionFactory sessionConnectionFactory,
            IHeldReportedActualGroupCommandRepository heldReportedActualGroupCommandRepository,
            IHeldReportedActualGroupQueryRepository heldReportedActualGroupQueryRepository)
        {
            _logger = logger;
            _heldPartitionKeyQueryService = heldPartitionKeyQueryService;
            _sessionConnectionFactory = sessionConnectionFactory;
            _heldReportedActualGroupCommandRepository = heldReportedActualGroupCommandRepository;
            _heldReportedActualGroupQueryRepository = heldReportedActualGroupQueryRepository;
        }

        public async Task Handle(ReleaseHeldReportedActualsCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ReleaseHeldReportedActualsStarted, "ReleaseHeldReportedActualsCommand processing started");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            IReadOnlyCollection<HeldActualsForAllocationGrpIdentifier> partitionKeyGroups = _heldPartitionKeyQueryService.GetPartitionKeyGroups(connectionInfo);

            IEnumerable<Task> sendCommandTasks = partitionKeyGroups.Select(partitionKeyGroup =>
                context.Send(new ReportedActualsLoadedCommand
                {
                    PartitionKeys = partitionKeyGroup.PartitionKeys.ToArray(),
                    FundingStreamPeriodCode = partitionKeyGroup.FundingStreamPeriodCode,
                    SummarisedActualOrgFspGroupKeys = GetSummarisedActualOrgFspGroupKeys(connectionInfo, partitionKeyGroup.PartitionKeys)
                }));

            await Task.WhenAll(sendCommandTasks).ConfigureAwait(continueOnCapturedContext: false);

            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ReleaseHeldReportedActualsCommandSent, $"Sent ReportedActualsLoadedCommands groups: {partitionKeyGroups.Count}");

            IReadOnlyCollection<string> allPartitionKeys = partitionKeyGroups.SelectMany(pkGroup => pkGroup.PartitionKeys.Select(pk => pk)).ToList();
            _heldReportedActualGroupCommandRepository.SetHeldReportedActualGroupsToProcessed(connectionInfo, allPartitionKeys);

            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ReleaseHeldReportedActualsCommandSent, $"Held Reported Actuals set to processed: {allPartitionKeys.Count}");

            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ReleaseHeldReportedActualsEnded, "ReleaseHeldReportedActualsCommand processing ended");
        }

        private SummarisedActualOrgFspGroupKey[] GetSummarisedActualOrgFspGroupKeys(ConnectionInfo connectionInfo, IReadOnlyCollection<string> partitionKeys)
        {
            return _heldReportedActualGroupQueryRepository.GetSummarisedActualOrgFspGroupKeys(connectionInfo, partitionKeys).ToArray();
        }
    }
}
