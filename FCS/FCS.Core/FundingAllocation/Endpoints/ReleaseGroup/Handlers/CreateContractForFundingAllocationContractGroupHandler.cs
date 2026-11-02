namespace FundingAllocation.Endpoints.ReleaseGroup.Handlers
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Services;
    using Infrastructure;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using FundingAllocation.Services;
    using Microsoft.Extensions.Configuration;

    public class CreateContractForFundingAllocationContractGroupHandler : IHandleMessages<CreateContractForFundingAllocationContractGroupCommand>
    {
        private readonly ILogger _logger;
        private readonly IContractStorage _contractStorage;
        private readonly IFundingAllocationsToContractTransformer _fundingAllocationsTransformer;
        private readonly IReleaseGroupFundingAllocationRepository _fundingAllocationRepository;
        private readonly IExtendedContractTypeTransformer _extendedContractTypeTransformer;
        private readonly IContractNumberQueryRepository _contractNumberQueryRepository;
        private readonly IContractCommandRepository _contractCommandRepository;
        private readonly IContractNumbersAndVersionIntentService _contractNumbersAndVersionIntentService;
        private readonly IContractDeliverableEnricher _contractDeliverableEnricher;
        private readonly IConfigurationRoot _configuration;


        private readonly IContractValueAggregator _contractValueAggregator;
        public CreateContractForFundingAllocationContractGroupHandler(
            ILogger logger,
            IContractStorage contractStorage,
            IFundingAllocationsToContractTransformer fundingAllocationsTransformer,
            IReleaseGroupFundingAllocationRepository fundingAllocationRepository,
            IExtendedContractTypeTransformer extendedContractTypeTransformer,
            IContractNumberQueryRepository contractNumberQueryRepository,
            IContractCommandRepository contractCommandRepository,
            IContractNumbersAndVersionIntentService contractNumbersAndVersionIntentService,
            IContractValueAggregator contractValueAggregator,
            IContractDeliverableEnricher contractDeliverableEnricher, IConfigurationRoot configuration)
        {
            _logger = logger;
            _contractStorage = contractStorage;
            _fundingAllocationsTransformer = fundingAllocationsTransformer;
            _fundingAllocationRepository = fundingAllocationRepository;
            _extendedContractTypeTransformer = extendedContractTypeTransformer;
            _contractNumberQueryRepository = contractNumberQueryRepository;
            _contractCommandRepository = contractCommandRepository;
            _contractValueAggregator = contractValueAggregator;
            _contractNumbersAndVersionIntentService = contractNumbersAndVersionIntentService;
            _contractDeliverableEnricher = contractDeliverableEnricher;
            _configuration = configuration;
        }

        public async Task Handle(CreateContractForFundingAllocationContractGroupCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.CreateContractForAllocationContractGroupCommandReceived, $"Processing CreateContractForFundingAllocationContractGroupCommand: {message}");

            var fundingAllocations = await _fundingAllocationRepository.GetFundingAllocationsWithOfInterestLinesForIds(message.FundingAllocationIds);
            
            var contractNumberInfo = 
                await _contractNumbersAndVersionIntentService.GetContractNumberReferencesAndVersion(
                    message.ContractIntent,
                    message.ContractInfoOption,
                    message.ContractItemsMappings.FundingTypeCode);

            ExtendedContractType contract = await _fundingAllocationsTransformer.CreateContractFrom(
                fundingAllocations,
                contractNumberInfo.contractNumber,
                contractNumberInfo.masterContractNumber,
                message.ContractItemsMappings,
                contractNumberInfo.version,
                lookupInput => _contractNumberQueryRepository.GetNextAllocationNumber(lookupInput.fundingStream));

            // aggregate the contract values from the deliverable periods up the tree to the parent nodes
            _contractValueAggregator.Aggregate(contract);

            // Enrich the contract with required deliverables
            _contractDeliverableEnricher.Enrich(contract);


            ExtendedContractType childContract = contract.contracts.First();
            var key = _contractStorage.GetKey(childContract.contractNumber, contractNumberInfo.version, childContract.contractSubVersionNumber);

            await _contractStorage.StoreContract(key, new ExtendedContractTypeAndIntent(contract, message.ContractIntent));

            await CreateContractAndRelateToFundingAllocations(contractNumberInfo.contractNumber, message.FundingAllocationIds, contractNumberInfo.version);

            await SendContractToEnrichForDocumentation(childContract, contract.contractNumber, message.ContractIntent, context);
            
            _logger.LogInformation(LoggingId.CreateContractForAllocationContractGroupCommandProcessed, $"Processed CreateContractForFundingAllocationContractGroupCommand: {message}");
        }

        private async Task CreateContractAndRelateToFundingAllocations(string contractNumber, IEnumerable<string> fundingAllocationIds, int version)
        {
            var contractId = await _contractCommandRepository.AddContract(contractNumber: contractNumber,
                version: version, subVersion: 0);

            await _fundingAllocationRepository.UpdateFundingAllocationsWithContractId(fundingAllocationIds, contractId);
        }

        private async Task SendContractToEnrichForDocumentation(
            ExtendedContractType childContract,
            string masterContractNumber,
            ContractIntent intent,
            IMessageHandlerContext context)
        {
            contract corpContract = _extendedContractTypeTransformer.TransformToCorpContract(childContract);
            corpContract.IsNewAmendment = intent == ContractIntent.NewAmendment;
            var message = new EnrichContractForDocumentationCommand
            {
                Contract = corpContract,
                MasterContractNumber = masterContractNumber,
                ReplyToEndpointName = "FundingAllocation.DocumentGenerationComplete"
            };

            await context.Send(message);
        }
    }
}

