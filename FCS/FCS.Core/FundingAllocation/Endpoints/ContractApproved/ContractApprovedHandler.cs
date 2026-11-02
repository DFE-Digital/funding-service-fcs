namespace FundingAllocation.Endpoints.ContractApproved
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Repositories;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Linq;
    using DataStore.Model;
    using Extensions;
    using FundingAllocation.Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Messages.Dtos;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;

    public class ContractApprovedHandler : IHandleMessages<ContractApprovedEvent>
    {
        private readonly ILogger _logger;
        private readonly IContractRepository _contractRepository;
        private readonly ICrmFundingAllocationCommandRepository _crmFundingAllocationCommandRepository;
        private readonly IFundingAllocationRepository _fundingAllocationRepository;
        private readonly IPreContractControlService _preContractControlService;

        public ContractApprovedHandler(ILogger logger, IContractRepository contractRepository, 
            ICrmFundingAllocationCommandRepository crmFundingAllocationCommandRepository,
            IFundingAllocationRepository fundingAllocationRepository,
            IPreContractControlService preContractControlService)
        {
            _logger = logger;
            _contractRepository = contractRepository;
            _crmFundingAllocationCommandRepository = crmFundingAllocationCommandRepository;
            _fundingAllocationRepository = fundingAllocationRepository;
            _preContractControlService = preContractControlService;
        }

        public async Task Handle(ContractApprovedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.ContractApprovedEventReceived, $"Received ContractApprovedEvent for {message}");

            List<Task> crmUpdateTasks = new List<Task>();
            foreach (var childContract in message.CorporateContract.contracts)
            {
                var contractNumber = childContract.contractNumber;
                var contractVersion = childContract.contractVersionNumber;

                var fundingInfos =
                    await _contractRepository.GetFundingAllocationInfosInContractControl(contractNumber, contractVersion);

                var fundingIds = fundingInfos.Select(fi => fi.FundingId).ToList();

                if (fundingIds.IsEmpty())
                {
                    continue;
                }

                await _fundingAllocationRepository.SetFundingAllocationStatusSubStatus(
                    fundingIds, FundingAllocationStatus.ContractApproved, FundingAllocationSubStatus.ContractApproved);

                var crmEntityIds = fundingInfos.Select(fi => Guid.Parse(fi.CrmEntityId)).ToList();

                _logger.LogInformation(LoggingId.ContractApprovedEventCrmEntitiesFound,
                    $"Processing ContractApprovedEvent for {message}, crmEntityIds: {string.Join(',', crmEntityIds)}, contract: {contractNumber}, version: {contractVersion}");

                crmUpdateTasks.AddRange(crmEntityIds
                    .Select(cei => _crmFundingAllocationCommandRepository.SetStatusToContractApproved(cei)).ToList());

                var parkResult =
                    await _preContractControlService.GetFundingIdsToBeUnParkedOnApproval(fundingIds);

                _logger.LogInformation(LoggingId.OnApprovalParkedFundingIdsToBeUnParkedFound,
                    $"Processing ContractApprovedEvent for {message}, Parked Result: {parkResult}, contract: {contractNumber}, version: {contractVersion}");

                await SendFundingAllocationsToContractControl(parkResult.FundingAllocationsForContractControl, context);

                await _preContractControlService.SetStatuses(
                    parkResult.FundingIdsForParkingAwaitingOutcome,
                    parkResult.FundingIdsForDiscardingNonMaterialUpdate,
                    parkResult.FundingIdsAwaitingContractTypeConfig,
                    parkResult.FundingIdsAwaitingFundingAllocationConfig,
                    parkResult.FundingIdsAwaitingFundingLineConfig,
                    parkResult.FundingAllocationsForContractControl
                        .Select(fa => fa.FundingId).ToList(),
                    parkResult.MutualExclusiveForAdultFilterCheckResult);

                await fundingIds.IfAny(_fundingAllocationRepository.SetFundingAllocationsToPublished);
            }

            await Task.WhenAll(crmUpdateTasks);

            var contractIdentities = message.CorporateContract.contracts.Select(c =>
                new ContractIdentity(c.contractNumber, c.contractVersionNumber, c.contractSubVersionNumber)).ToList();

            var releaseQueuedFundingAllocationsForContractsCommand = new ReleaseQueuedFundingAllocationsForContractsCommand(contractIdentities);

            var overrideStatuses = message.CorporateContract.contracts.Select(c =>
                new ContractAndStatus(new ContractIdentity(c.contractNumber, c.contractVersionNumber, c.contractSubVersionNumber), 
                    "Approved", "Approved")).ToList();

            releaseQueuedFundingAllocationsForContractsCommand.OverrideStatuses = overrideStatuses;

            await context.Send(releaseQueuedFundingAllocationsForContractsCommand);

            _logger.LogInformation(LoggingId.ContractApprovedEventProcessed, $"Processed ContractApprovedEvent for {message}");
        }

        private static async Task SendFundingAllocationsToContractControl(IReadOnlyCollection<FundingAllocation> fundingAllocationsToBeUnParked, IMessageHandlerContext context)
        {
            await context.Send(new IgnoreItemsOfNoInterestCommand
            {
                FundingAllocationIds = fundingAllocationsToBeUnParked.Select(fa => fa.FundingId).ToList()
            });
        }
    }
}
