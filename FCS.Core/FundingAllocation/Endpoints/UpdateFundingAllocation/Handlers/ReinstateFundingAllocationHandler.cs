namespace FundingAllocation.Endpoints.UpdateFundingAllocation.Handlers
{
    using System.Threading.Tasks;
    using Extensions;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ReinstateFundingAllocationHandler : IHandleMessages<ReinstateFundingAllocationCommand>
    {
        private readonly ILogger _logger;
        private readonly IFundingAllocationRepository _fundingAllocationRepository;
        private readonly ICfsToFcsCodeMappingService _cfsToFcsCodeMappingService;
        private readonly IReleaseGroupService _releaseGroupService;
        private readonly ICrmFundingAllocationRepository _crmFundingAllocationRepository;

        public ReinstateFundingAllocationHandler(
            ILogger logger,
            IFundingAllocationRepository fundingAllocationRepository,
            ICfsToFcsCodeMappingService cfsToFcsCodeMappingService,
            IReleaseGroupService releaseGroupService,
            ICrmFundingAllocationRepository crmFundingAllocationRepository)
        {
            _logger = logger;
            _fundingAllocationRepository = fundingAllocationRepository;
            _cfsToFcsCodeMappingService = cfsToFcsCodeMappingService;
            _releaseGroupService = releaseGroupService;
            _crmFundingAllocationRepository = crmFundingAllocationRepository;
        }

        public async Task Handle(ReinstateFundingAllocationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.ReinstateFundingAllocationCommandReceived, $"Received ReinstateFundingAllocationCommand - {message}");
            var fundingAllocation = await _fundingAllocationRepository.GetFundingAllocationIncludingProviders(message.FundingId);

            var contractItemsMapping = await _cfsToFcsCodeMappingService.GetContractItemsMappingResult(
                fundingAllocation.GetContractItemsMappingInput());

            var fundingAllocationDto = fundingAllocation.ToDto(contractItemsMapping);

            var releaseGrpId = await _releaseGroupService.GetOrCreateReleaseGroup(
                fcsFundingType: fundingAllocationDto.FundingType,
                fcsPeriod: fundingAllocationDto.Period,
                fspGroupCode: fundingAllocationDto.FSPGroup,
                fcsContractType: fundingAllocationDto.ContractType,
                () => _crmFundingAllocationRepository.GetForeignKeys(fundingAllocationDto)
                );

            await _fundingAllocationRepository.UpdateReleaseGroupOnFundingAllocation(message.FundingId,
                releaseGrpId.PaaSId);

            await context.SendLocal(new ReinstateFundingAllocationInCrmCommand(fundingAllocation.CrmEntityId.ToString(),
                releaseGrpId.CrmId.ToString()));

            _logger.LogInformation(LoggingId.ReinstateFundingAllocationCommandProcessed, $"Processed ReinstateFundingAllocationCommand - {message}");
        }
    }
}
