namespace FundingAllocation.Endpoints.UpdateFundingAllocation.Handlers
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using CreateFundingAllocationInCrm;
    using DataStore.Model;
    using Dto;
    using Extensions;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class UnHoldFundingAllocationHandler : IHandleMessages<UnHoldFundingAllocationCommand>
    {
        private readonly ILogger _logger;
        private readonly IReleaseGroupRepository _releaseGroupRepository;
        private readonly IFundingAllocationRepository _fundingAllocationRepository;
        private readonly ICfsToFcsCodeMappingService _cfsToFcsCodeMappingService;
        private readonly ICrmReleaseGroupRepository _crmReleaseGroupRepository;
        private readonly ICrmFundingAllocationRepository _crmFundingAllocationRepository;

        public UnHoldFundingAllocationHandler(
            ILogger logger,
            IReleaseGroupRepository releaseGroupRepository,
            IFundingAllocationRepository fundingAllocationRepository,
            ICfsToFcsCodeMappingService cfsToFcsCodeMappingService,
            ICrmReleaseGroupRepository crmReleaseGroupRepository,
            ICrmFundingAllocationRepository crmFundingAllocationRepository)
        {
            _logger = logger;
            _releaseGroupRepository = releaseGroupRepository;
            _fundingAllocationRepository = fundingAllocationRepository;
            _cfsToFcsCodeMappingService = cfsToFcsCodeMappingService;
            _crmReleaseGroupRepository = crmReleaseGroupRepository;
            _crmFundingAllocationRepository = crmFundingAllocationRepository;
        }

        public async Task Handle(UnHoldFundingAllocationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.UnHoldFundingAllocationCommandReceived, $"Received UnHoldFundingAllocationCommand - {message}");

            var fundingAllocation = await _fundingAllocationRepository.GetFundingAllocationIncludingProviders(fundingId: message.FundingId);

            var releaseGroupId = await GetOrCreateReleaseGroup(fundingAllocation);

            var updateInPaaSTask = context.SendLocal(new UpdateFundingAllocationWithReleaseGroupCommand
            {
                FundingId = message.FundingId,
                ReleaseGroupId = releaseGroupId.PaaSId
            });

            var updateInCrmTask = context.SendLocal(new UpdateFundingAllocationWithReleaseGrpInCrmCommand
            {
                CrmFundingId = fundingAllocation.CrmEntityId.ToString(),
                CrmReleaseGrpId = releaseGroupId.CrmId.ToString()
            });

            await Task.WhenAll(new List<Task> {updateInCrmTask, updateInPaaSTask});

            _logger.LogInformation(LoggingId.UnHoldFundingAllocationCommandProcessed, $"Processed UnHoldFundingAllocationCommand - {message}");
        }

        private async Task<ReleaseGroupId> GetOrCreateReleaseGroup(FundingAllocation fundingAllocation)
        {
            var contractItemsMapping = await _cfsToFcsCodeMappingService.GetContractItemsMappingResult(
                fundingAllocation.GetContractItemsMappingInput());

            var fundingAllocationDto = fundingAllocation.ToDto(contractItemsMapping);

            var optionReleaseGrpId = await _releaseGroupRepository.GetAwaitingReleaseGroup(fundingTypeCode: fundingAllocationDto.FundingType,
                fundingPeriod: fundingAllocationDto.Period,
                fspGroupCode: fundingAllocationDto.FSPGroup,
                contractType: fundingAllocationDto.ContractType);

            var releaseGroupId = await optionReleaseGrpId.MatchAsync(Some: Task.FromResult,
                None: async () =>
                {
                    var crmReleaseGrpId = Guid.NewGuid();
                    string releaseGroupName = await _releaseGroupRepository.GetNextReleaseGroupName();

                    var paasReleaseGrpId = await _releaseGroupRepository.CreateReleaseGroup(
                        fundingTypeCode: fundingAllocationDto.FundingType,
                        fundingPeriod: fundingAllocationDto.Period,
                        fspGroupCode: fundingAllocationDto.FSPGroup,
                        contractType: fundingAllocationDto.ContractType,
                        crmReleaseGroupEntityId: crmReleaseGrpId,
                        releaseGroupName: releaseGroupName);

                    var foreignKeys = await _crmFundingAllocationRepository.GetForeignKeys(fundingAllocationDto);

                    await _crmReleaseGroupRepository.CreateReleaseGroup(
                        releaseGroupName: releaseGroupName,
                        fundingTypeId: foreignKeys.FundingTypeId,
                        fundingPeriodId: foreignKeys.PeriodId,
                        fspGroupId: foreignKeys.FspGroupId,
                        contractTypeId: foreignKeys.ContractTypeId,
                        crmReleaseGroupEntityId: crmReleaseGrpId.ToString());

                    return new ReleaseGroupId(paasReleaseGrpId, crmReleaseGrpId);
                });

            return releaseGroupId;
        }
    }
}
