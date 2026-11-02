namespace ContractCreateDomain.Endpoint.UpdateContract
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Infrastructure;
    using ContractManagement.DataStore.Model;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ContractCreateDomainEventLoggingId = ContractCreateDomainEventLoggingId;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractType;

    public class UpdateContractFromFundingHandler : IHandleMessages<UpdateContractFromFundingCommand>
    {
        private static readonly IReadOnlyCollection<ContractIntent> AmendmentIntents = new List<ContractIntent> { ContractIntent.UpdateDraftAmendment, ContractIntent.Amendment };
        private readonly ILogger _logger;
        private readonly IContractsManager _contractsManager;
        private readonly IContractStorage _contractStorage;
        private readonly IContractTypeTransformer _contractTypeTransformer;
        private readonly IContractDeliverableEnricher _contractDeliverableEnricher;
        private readonly IContractValueAggregator _contractValueAggregator;
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IFundingTypePeriodService _fundingTypePeriodService;
        private readonly IValueVariationService _valueVariationService;
        private readonly ILastApprovedContractCreationDateService _lastApprovedContractCreationDateService;
        private readonly ICheckForContractChangeService _checkForContractChangeService;

        public UpdateContractFromFundingHandler(
            ILogger logger,
            IContractsManager contractsManager,
            IContractStorage contractStorage,
            IContractTypeTransformer contractTypeTransformer,
            IContractDeliverableEnricher contractDeliverableEnricher,
            IContractValueAggregator contractValueAggregator,
            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository,
            ISessionConnectionFactory sessionConnectionFactory,
            IFundingTypePeriodService fundingTypePeriodService,
            IValueVariationService valueVariationService,
            ILastApprovedContractCreationDateService lastApprovedContractCreationDateService,
            ICheckForContractChangeService checkForContractChangeService)
        {
            _logger = logger;
            _contractsManager = contractsManager;
            _contractStorage = contractStorage;
            _contractTypeTransformer = contractTypeTransformer;
            _contractDeliverableEnricher = contractDeliverableEnricher;
            _contractValueAggregator = contractValueAggregator;
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
            _fundingTypePeriodService = fundingTypePeriodService;
            _valueVariationService = valueVariationService;
            _lastApprovedContractCreationDateService = lastApprovedContractCreationDateService;
            _checkForContractChangeService = checkForContractChangeService;
        }

        public async Task Handle(UpdateContractFromFundingCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.UpdateDraftContractFromFundingCommandReceived, $"Received UpdateDraftContractFromFundingCommand, message: {message}");

            var masterContract = _contractsManager.GetCorporateContractForSpecificVersion(
                contractNumber: message.CrmExistingContractIdentity.Number,
                version: message.CrmExistingContractIdentity.Version,
                subVersion: message.CrmExistingContractIdentity.SubVersion);

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);
            var childContract = masterContract.contracts.First();
            childContract.FlattenDeliverablesOnAllocations();
            childContract.MergeAllocationsOnToContract(message.Allocations, message.ContractIntent);
            childContract.AlignDeliveryOrgs();

            childContract.contractVersionNumber = message.VersionToCreate;
            childContract.contractSubVersionNumber = message.SubVersionToCreate;
            childContract.PreviousVersionId = childContract.CrmContractId;
            childContract.RemoveTimeComponentsFromDate();
            
            childContract.amendmentType = message.AmendmentType;
            childContract.IsAmendment = message.IsAmendment;

            _contractDeliverableEnricher.Enrich(masterContract);
            _contractValueAggregator.Aggregate(masterContract);

            var keyForStorage = _contractStorage.GetKey(childContract.contractNumber,
                childContract.contractVersionNumber,
                childContract.contractSubVersionNumber);

            StoreContractForSendingToCrmLater(masterContract, keyForStorage, message.ContractIntent, connectionInfo);

            var corpChildContract = _contractTypeTransformer.TransformContractTypeToContract(childContract);

            await SendContractForDocumentation(corpChildContract, masterContract.contractNumber, message.ReplyFromDocumentationTo, context, connectionInfo, message.ContractIntent);

            _logger.LogInformation(ContractCreateDomainEventLoggingId.UpdateDraftContractFromFundingCommandProcessed, $"Processed UpdateDraftContractFromFundingCommand, message: {message}");
        }

        private void StoreContractForSendingToCrmLater(contractType masterContract, string key, ContractIntent intent, ConnectionInfo connectionInfo)
        {
            var extendedContractType = _contractTypeTransformer.TransformContractTypeToExtendedContractType(masterContract);
            var childContract = masterContract.contracts.First();
            var fundingTypeCode = childContract.fundingType.fundingTypeCode;
            var fundingPeriod = childContract.period.GetFundingPeriodName();
            
            FundingTypeFundingPeriod fundingTypeFundingPeriod = _fundingTypeFundingPeriodQueryRepository.Get(fundingTypeCode, fundingPeriod, connectionInfo);
            _fundingTypePeriodService.EnrichContract(extendedContractType, fundingTypeFundingPeriod);
            if (childContract.IsAmendment)
            {
                _valueVariationService.UpdateValueVariation(extendedContractType);
            }

            _contractStorage.UploadContract(key, new ExtendedContractTypeAndIntent(extendedContractType, intent));
        }

        private async Task SendContractForDocumentation(
            contract corpChildContract,
            string masterContractNumber,
            string replyTo,
            IMessageHandlerContext context,
            ConnectionInfo connectionInfo,
            ContractIntent intent)
        {
            corpChildContract.DocumentationRequired = true;
            corpChildContract.IsNewRevisedNewOrUpdateDraft = intent == ContractIntent.New || intent == ContractIntent.UpdateDraft;
            corpChildContract.LatestCreatedDateForNonNotificationApprovedContract =
                await _lastApprovedContractCreationDateService.GetLatestCreatedDateForNonNotificationApprovedContract(corpChildContract.contractNumber, connectionInfo);
            corpChildContract.IsVariation = corpChildContract.amendmentType == SFA.FCT.ContractManagementService.Common.AmendmentType.Variation.ToString();

            if (AmendmentIntents.Contains(intent))
            {
                var contractRequestChildContract = _contractTypeTransformer.TransformCorpContractToContractRequest(corpChildContract);
                ContractRequest.contractType contractRequestMaster = new ContractRequest.contractType
                {
                    contracts = new List<ContractRequest.contractType>
                    {
                        contractRequestChildContract
                    }
                };

                _checkForContractChangeService.UpdateAllocationsThatHaveBeenAddedOrChangedService(contractRequestMaster);
                _checkForContractChangeService.UpdateCorpContractAllocations(corpChildContract, contractRequestChildContract);
            }

            var message = new EnrichContractForDocumentationCommand
            {
                Contract = corpChildContract,
                MasterContractNumber = masterContractNumber,
                ReplyToEndpointName = replyTo
            };

            await context.Send(message);
        }
    }
}
