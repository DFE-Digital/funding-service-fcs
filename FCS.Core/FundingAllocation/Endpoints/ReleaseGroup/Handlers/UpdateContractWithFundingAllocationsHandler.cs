namespace FundingAllocation.Endpoints.ReleaseGroup.Handlers
{
    using System.Linq;
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using System.Threading.Tasks;
    using Dto;
    using Extensions;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public class UpdateContractWithFundingAllocationsHandler : IHandleMessages<UpdateContractWithFundingAllocationsCommand>
    {
        private readonly ILogger _logger;
        private readonly IReleaseGroupFundingAllocationRepository _fundingAllocationRepository;
        private readonly IContractNumberQueryRepository _contractNumberQueryRepository;
        private readonly IFundingAllocationsToContractTransformer _fundingAllocationsToContractTransformer;
        private readonly IContractCommandRepository _contractCommandRepository;
        private readonly IAmendmentTypeService _amendmentTypeService;

        public UpdateContractWithFundingAllocationsHandler(
            ILogger logger,
            IReleaseGroupFundingAllocationRepository fundingAllocationRepository,
            IContractNumberQueryRepository contractNumberQueryRepository,
            IFundingAllocationsToContractTransformer fundingAllocationsToContractTransformer,
            IContractCommandRepository contractCommandRepository, IAmendmentTypeService amendmentTypeService)
        {
            _logger = logger;
            _fundingAllocationRepository = fundingAllocationRepository;
            _contractNumberQueryRepository = contractNumberQueryRepository;
            _fundingAllocationsToContractTransformer = fundingAllocationsToContractTransformer;
            _contractCommandRepository = contractCommandRepository;
            _amendmentTypeService = amendmentTypeService;
        }

        public async Task Handle(UpdateContractWithFundingAllocationsCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.UpdateContractWithFundingAllocationsCommandReceived, 
                $"UpdateContractWithFundingAllocationsCommand received - {message}");

            var existingContractInfo = message.CrmContractInfo;

            var fundingAllocations = await _fundingAllocationRepository.GetFundingAllocationsWithOfInterestLinesForIds(message.FundingIds);
            
            IReadOnlyCollection<ExtendedContractAllocation> updateContractAllocations = await _fundingAllocationsToContractTransformer.CreateAllocationsFrom(
                message.ContractingUkprn,
                fundingAllocations,
                message.ContractItemsMappings,
                lookUpInput => GetAllocationNumber(lookUpInput, message.CrmContractInfo));
            var fundingNames = message.FundingIds.Select(fId => fId.RemoveVersionFromId()).ToList();
            var contractApprovedFundingIds = await _fundingAllocationRepository.GetMatchingLastApprovedFundingIds(fundingNames);
            var contractApprovedFundingAllocations = await _fundingAllocationRepository.GetFundingAllocationsWithOfInterestLinesForIds(contractApprovedFundingIds);
            
            var amendmentType = await _amendmentTypeService.GetAmendmentType(
                new GetAmendmentTypeInput(message.ContractingUkprn, message.ContractItemsMappings.FundingTypeCode,
                    message.ContractItemsMappings.FundingPeriodCode, message.FundingIds, fundingAllocations,
                    contractApprovedFundingAllocations,
                    message.ContractIntent,
                    message.CrmContractInfo.AmendmentType));

            _logger.LogInformation(LoggingId.UpdateContractWithFundingAllocationsCommandReceived,
                $"amendmentType received - {amendmentType}");

            var command = new UpdateContractFromFundingCommand(
                existingContractInfo.ToCrmContractIdentity(),
                updateContractAllocations,
                replyFromDocumentationTo: "FundingAllocation.DocumentGenerationComplete",
                contractIntent:message.ContractIntent,
                amendmentType,
                latestOverallVersionNumber: existingContractInfo.LatestOverallVersionNumber,
                message.ContractIntent.IsAmendment());

            var contractId = await _contractCommandRepository.AddContract(
                existingContractInfo.Number, command.VersionToCreate, command.SubVersionToCreate);

            await _fundingAllocationRepository.UpdateFundingAllocationsWithContractId(fundingAllocations.Select(fa => fa.FundingId), contractId);

            await context.Send(command);

            _logger.LogInformation(LoggingId.UpdateContractWithFundingAllocationsCommandProcessed,
                $"UpdateContractWithFundingAllocationsCommand processed - {message}");
        }

        private int GetAllocationNumber((string fundingStream, int deliveryUkprn) lookupInput, CrmContractInfo contractInfo)
        {
            var allocationNumberOption =
                contractInfo.GetExistingAllocationNumber(lookupInput.fundingStream, lookupInput.deliveryUkprn);

            return allocationNumberOption.Match(Some: num => num,
                None: () => _contractNumberQueryRepository.GetNextAllocationNumber(lookupInput.fundingStream));
        }
    }
}
