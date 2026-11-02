namespace AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Extensions;
    using Infrastructure;
    using NServiceBus;
    using Services;
    using SFA.FCT.AllocationDeliveryDomain.Common;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractTermination;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ContractPlacedUnderTerminationHandler : 
        IHandleMessages<ContractPlacedUnderTerminationForApproveInitiationEvent>,
        IHandleMessages<ContractPlacedUnderTerminationForUpdatedDetailsEvent>
    {
        private readonly ILogger _logger;
        private readonly IAllocationUnderTerminationRepository _allocationUnderTerminationRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IZeroiseActualsService _zeroiseActualsService;

        public ContractPlacedUnderTerminationHandler(
            ILogger logger,
            IAllocationUnderTerminationRepository allocationUnderTerminationRepository,
            ISessionConnectionFactory sessionConnectionFactory,
            IZeroiseActualsService zeroiseActualsService)
        {
            _logger = logger;
            _allocationUnderTerminationRepository = allocationUnderTerminationRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
            _zeroiseActualsService = zeroiseActualsService;
        }

        public async Task Handle(ContractPlacedUnderTerminationForApproveInitiationEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ContractPlacedUnderTerminationForApproveInitiationHandlerStarted, $"ContractPlacedUnderTerminationForApproveInitiationHandler processing started - {message}");

            await PlaceContractUnderTermination(message, context).ConfigureAwait(false);

            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ContractPlacedUnderTerminationForApproveInitiationHandlerEnded, $"ContractPlacedUnderTerminationForApproveInitiationHandler processing complete - {message}");
        }

        public async Task Handle(ContractPlacedUnderTerminationForUpdatedDetailsEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ContractPlacedUnderTerminationForUpdatedDetailsHandlerStarted, $"ContractPlacedUnderTerminationForUpdatedDetailsHandler processing started - {message}");

            await PlaceContractUnderTermination(message, context).ConfigureAwait(false);

            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ContractPlacedUnderTerminationForUpdatedDetailsHandlerEnded, $"ContractPlacedUnderTerminationForUpdatedDetailsHandler processing complete - {message}");
        }

        private async Task PlaceContractUnderTermination(ContractPlacedUnderTerminationEvent message, IMessageHandlerContext context)
        {
            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            await AddTerminationAllocationsToAllocationUnderTerminations(message.ContractNumber, message.TerminationAllocations, connectionInfo)
                .ConfigureAwait(false);

            async Task PublishAllocationActualsUpdatedEvent(ContractAllocationActualsType a)
            {
                // always use the version of the terminated contract and not the one from the audit table
                a.ContractReference.ContractVersionNumber = message.VersionNumber;
                await context.Publish(new AllocationActualsUpdated { AllocationActuals = a })
                    .ConfigureAwait(false);
            }

            await message.TerminationAllocations
                .WhenAllOneByOne(terminationAllocation =>
                    _zeroiseActualsService.ConditionallyZeroiseActuals(connectionInfo, terminationAllocation, PublishAllocationActualsUpdatedEvent))
                .ConfigureAwait(continueOnCapturedContext: false);
        }

        private async Task AddTerminationAllocationsToAllocationUnderTerminations(string contractNumber,
            IReadOnlyCollection<TerminationAllocation> terminationAllocations, ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<AllocationUnderTermination> allocationUnderTerminations
                = TerminationAllocationMapper.ToAllocationsUnderTermination(contractNumber, terminationAllocations);

            await _allocationUnderTerminationRepository.RemoveAllocationUnderTerminationsForContract(contractNumber, connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);

            await _allocationUnderTerminationRepository.AddRange(allocationUnderTerminations, connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);
        }
   }
}