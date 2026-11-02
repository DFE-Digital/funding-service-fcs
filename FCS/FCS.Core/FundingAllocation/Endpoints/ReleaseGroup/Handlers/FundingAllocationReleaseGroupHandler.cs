namespace FundingAllocation.Endpoints.ReleaseGroup.Handlers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore.Model;
    using Dto;
    using Extensions;
    using FundingAllocation.Repositories;
    using LanguageExt;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class FundingAllocationReleaseGroupHandler : IHandleMessages<FundingAllocationReleaseGroupCommand>
    {
        private readonly ILogger _logger;
        private readonly IFundingAllocationGroupingService _fundingAllocationGroupingService;
        private readonly Repositories.IReleaseGroupRepository _releaseGroupRepository;
        private readonly IIntentService _intentService;
        private readonly Repositories.IReleaseGroupFundingAllocationRepository _fundingAllocationRepository;
        private readonly ICrmFundingAllocationRepository _crmFundingAllocationRepository;

        private static readonly Dictionary<ContractIntent, Func<Option<CrmContractInfo>, FundingAllocationContractGroup, ContractIntent, object>>
            IntentCommandFactory =
                new Dictionary<ContractIntent, Func<Option<CrmContractInfo>, FundingAllocationContractGroup, ContractIntent, object>>
                {
                    {ContractIntent.UpdateDraft, CreateUpdateCommand},
                    {ContractIntent.UpdateDraftAmendment, CreateUpdateCommand},
                    {ContractIntent.Amendment, CreateUpdateCommand},
                    {ContractIntent.New, CreateCreateContractCommand},
                    {ContractIntent.RevisedNew, CreateCreateContractCommand},
                    {ContractIntent.NewAmendment, CreateCreateContractCommand},
                    {ContractIntent.Queue, CreateQueueFundingAllocationsGroupCommand}
                };

        public FundingAllocationReleaseGroupHandler(
            ILogger logger,
            IFundingAllocationGroupingService fundingAllocationGroupingService,
            Repositories.IReleaseGroupRepository releaseGroupRepository,
            IIntentService intentService,
            Repositories.IReleaseGroupFundingAllocationRepository fundingAllocationRepository,
            ICrmFundingAllocationRepository crmFundingAllocationRepository)
        {
            _logger = logger;
            _fundingAllocationGroupingService = fundingAllocationGroupingService;
            _releaseGroupRepository = releaseGroupRepository;
            _intentService = intentService;
            _fundingAllocationRepository = fundingAllocationRepository;
            _crmFundingAllocationRepository = crmFundingAllocationRepository;
        }

        public async Task Handle(FundingAllocationReleaseGroupCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.FundingAllocationReleaseGroupCommandReceived, $"Processing FundingAllocationReleaseGroupCommand: {message}");

            var releaseGroupNamesValidationResult = await _releaseGroupRepository.GetReleaseGroupNameValidationResult(message.ReleaseGroupNames.ToList());

            var fundingIds = await GetFundingIdsToReleaseAndUpdateStatusAndQueueInfoIfNecessary(
                message.OnlyQueuedFundingAllocations,
                releaseGroupNamesValidationResult.ValidReleaseGroupNames,
                context,
                message.EventSourceContractIdentities.Select(c => c.ContractNumber).ToList());

            FundingAllocationContractGroup[] logicalContractGroups =
                await _fundingAllocationGroupingService.GetFundingAllocationContractGroups(fundingIds);

            var commands = new List<object>();

            foreach (var logicalContractGroup in logicalContractGroups)
            {
                var intentResult = await _intentService.GetIntent(
                    logicalContractGroup.ContractingUkprn,
                    logicalContractGroup.FundingType,
                    logicalContractGroup.FundingPeriod,
                    message.IgnoreContractIdentitiesWhenConsideringIntent ? message.EventSourceContractIdentities : new List<ContractIdentity>(),
                    message.OverrideStatuses,
                    message.OnlyQueuedFundingAllocations);

                _logger.LogInformation(LoggingId.IntentDetermined, $"Determined Intent of {intentResult.Intent} for Contract Group: {logicalContractGroup}");

                commands.Add(IntentCommandFactory[intentResult.Intent](intentResult.ExistingCrmContract, logicalContractGroup, intentResult.Intent));
            }

            var sendOptions = new SendOptions();
            sendOptions.RouteToThisEndpoint();
            var sendTasks = commands.Select(cmd => context.Send(cmd, sendOptions));

            await Task.WhenAll(sendTasks);

            if (releaseGroupNamesValidationResult.ReleaseGroupNamesWithFundingInfoBulkUploadedInProgress.Any())
            {
                await context.SendLocal(new ResetReleaseGroupsBackToAwaitingReleaseCommand(
                    releaseGroupNamesValidationResult.ReleaseGroupNamesWithFundingInfoBulkUploadedInProgress));
            }
            
            _logger.LogInformation(LoggingId.FundingAllocationReleaseGroupCommandProcessed, $"Processed FundingAllocationReleaseGroupCommand: {message}, releaseGroupNamesValidationResult: {releaseGroupNamesValidationResult}");
        }

        private async Task<IReadOnlyCollection<string>> GetFundingIdsToReleaseAndUpdateStatusAndQueueInfoIfNecessary(
            bool onlyReleaseQueued, IReadOnlyCollection<string> releaseGroupNames, IMessageHandlerContext context,
            IReadOnlyCollection<string> contractNumbersRelated)
        {
            if (onlyReleaseQueued == false)
            {
                await _releaseGroupRepository.UpdateStatus(releaseGroupNames, ReleaseGroupStatus.ReleaseInProgress);
                await SendFundingAllocationReleaseInProgressEvents(releaseGroupNames, context);

                return await _releaseGroupRepository.GetFundingIds(releaseGroupNames);
            }

            var queuedFundingIds = await _releaseGroupRepository.GetQueuedFundingIds(releaseGroupNames, contractNumbersRelated);
            await _fundingAllocationRepository.RemoveQueuedInfoFromQueuedFundingAllocations(queuedFundingIds, contractNumbersRelated);
            await _fundingAllocationRepository.RemoveAnyOrphanedQueuedContracts();

            var fundingAllocationCrmIds = await _fundingAllocationRepository.GetFundingAllocationCrmIds(queuedFundingIds);
            fundingAllocationCrmIds.ToList().ForEach(async fundingAllocationCrmId =>
                await _crmFundingAllocationRepository.ClearQueued(fundingAllocationCrmId.ToString()));

            return queuedFundingIds;
        }

        private static UpdateContractWithFundingAllocationsCommand CreateUpdateCommand(Option<CrmContractInfo> crmContractInfo, 
            FundingAllocationContractGroup fundingAllocationContractGroup, ContractIntent contractIntent)
        {
            return  crmContractInfo.Match(Some:cci => new UpdateContractWithFundingAllocationsCommand(cci,
                fundingAllocationContractGroup.ContractingUkprn,
                contractIntent,
                fundingAllocationContractGroup.ContractItemsMappings,
                fundingAllocationContractGroup.FundingAllocationIds),
                None: () => throw new InvalidOperationException("The CrmContractInfo is required for update"));
        }

        private static CreateContractForFundingAllocationContractGroupCommand CreateCreateContractCommand(
            Option<CrmContractInfo> crmContractInfo,
            FundingAllocationContractGroup fundingAllocationContractGroup,
            ContractIntent contractIntent)
        {
            return new CreateContractForFundingAllocationContractGroupCommand
            {
                ContractItemsMappings = fundingAllocationContractGroup.ContractItemsMappings,
                FundingAllocationIds = fundingAllocationContractGroup.FundingAllocationIds,
                ContractIntent = contractIntent,
                ContractInfoOption = crmContractInfo
            };
        }

        private static QueueFundingAllocationsGroupCommand CreateQueueFundingAllocationsGroupCommand(Option<CrmContractInfo> crmContractInfo,
            FundingAllocationContractGroup fundingAllocationContractGroup, ContractIntent contractIntent)
        {
            return new QueueFundingAllocationsGroupCommand
            {
                CrmContractInfo = crmContractInfo.Match(Some:ci => ci, None:() => throw new InvalidOperationException("We need a CrmContractInfo for Queue Intent")),
                FundingAllocationIds = fundingAllocationContractGroup.FundingAllocationIds
            };
        }

        private async Task SendFundingAllocationReleaseInProgressEvents(IReadOnlyCollection<string> releaseGroupNames, IMessageHandlerContext context)
        {
            var releaseGroupInfos = await _releaseGroupRepository.GetReleaseGroupInfos(releaseGroupNames);
            var distinctFundingTypeFundingPeriods = releaseGroupInfos
                .Select(rgi => new {rgi.FundingTypeCode, rgi.FundingPeriodCode})
                .Distinct()
                .ToList();

            var releaseGroupGroupId = await _releaseGroupRepository.GetNextReleaseGroupGroupId();

            var events = distinctFundingTypeFundingPeriods.Select(i =>
                    new FundingAllocationReleaseInProgressEvent(i.FundingTypeCode, i.FundingPeriodCode, releaseGroupGroupId)).ToList();

            var publishTasks = events.Select(context.Publish).ToList();

            await Task.WhenAll(publishTasks);
            var releaseGroupGroups = releaseGroupInfos.Select(i => new ReleaseGroupGroup(releaseGroupGroupId, i.ReleaseGroupId))
                .ToList();

            await _releaseGroupRepository.InsertReleaseGroupGroups(releaseGroupGroups);

            _logger.LogInformation(LoggingId.FundingAllocationReleaseGroupCommandSendingReleaseInProgressEvents, 
                "FundingAllocationReleaseGroupCommand - Sending FundingAllocationReleaseInProgressEvents. " +
                $"FundingTypeFundingPeriods or count: {distinctFundingTypeFundingPeriods.ToCsvOrCountIfTooMany()}");
        }
    }
}
