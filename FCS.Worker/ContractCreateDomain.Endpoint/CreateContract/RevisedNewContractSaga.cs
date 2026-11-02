namespace ContractCreateDomain.Endpoint.CreateContract
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Infrastructure;
    using Infrastructure.DTOs;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.DTOs;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ContractCreateDomainEventLoggingId = Endpoint.ContractCreateDomainEventLoggingId;
    using IContractOperationRules = Infrastructure.IContractOperationRules;
    using IContractValidationLookupDataCreator = Infrastructure.IContractValidationLookupDataCreator;
    using IFundingTypeFundingPeriodQueryRepository = Infrastructure.IFundingTypeFundingPeriodQueryRepository;
    using IProcessedMessageRepository = Infrastructure.IProcessedMessageRepository;

    public class RevisedNewContractSaga : IHandleMessages<RevisedNewContractRequestCommand>
    {
        private readonly ILookupManager _crmLookupManager;
        private readonly CreateContractSaga _createContractSaga;
        private readonly Infrastructure.IContractOperationRules _contractOperationRules;
        private readonly ILogger _logger;
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;
        private readonly ISagaDataStorage _sagaDataStorage;
        private readonly IFundingTypeFundingPeriodContractTypeQueryRepository _fundingTypeFundingPeriodContractTypeQueryRepository;

        public RevisedNewContractSaga(IContractDeliverableEnricher contractDeliverableEnricher,
            IContractRequestTransformer contractRequestTransformer,
            IContractValueAggregator contractValueAggregator,
            ILogger logger,
            INumberRequestManager numberRequestManager,
            IOrganisationMessageEnricher organisationMessageEnricher,
            IValidator validator,
            IProcessedMessageRepository processedMessageRepository,
            ISessionConnectionFactory sessionConnectionFactory,
            IContractOperationRules contractOperationRules,
            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository,
            ISagaDataStorage sagaDataStorage,
            IContractValidationLookupDataCreator contractValidationLookupDataCreator,
            ILookupManager crmLookupManager,
            IFundingTypeFundingPeriodContractTypeQueryRepository fundingTypeFundingPeriodContractTypeQueryRepository,
            ISiblingApprovedContractService siblingApprovedContractService,
            IRelatedAllocationEnricher relatedAllocationEnricher)
        {
            _crmLookupManager = crmLookupManager;
            _fundingTypeFundingPeriodContractTypeQueryRepository = fundingTypeFundingPeriodContractTypeQueryRepository;
            _contractOperationRules = contractOperationRules;
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _sagaDataStorage = sagaDataStorage;
            _logger = logger;

            _createContractSaga = new CreateContractSaga(
                contractDeliverableEnricher,
                contractRequestTransformer,
                contractValueAggregator,
                logger,
                numberRequestManager,
                organisationMessageEnricher,
                validator,
                processedMessageRepository,
                sessionConnectionFactory,
                ContractCreateDomainEventLoggingId.NewContractWithExistingNumberRequestCommandReceived,
                contractValidationLookupDataCreator,
                siblingApprovedContractService,
                relatedAllocationEnricher);
        }

        public async Task Handle(RevisedNewContractRequestCommand message, IMessageHandlerContext context)
        {
            contractType contract = message.ContractRequest.contract.contracts.First();
            contract.contractVersionNumber = GetContractVersionNumberForContract(contract.contractNumber);

            CreateContractSagaData data = new CreateContractSagaData
            {
                AddContractAllocationNumbersOnly = true
            };

            SagaMethodResult sagaMethodResult = await _createContractSaga.Handle(message, context, data, GetValidationRules)
                .ConfigureAwait(false);

            if (sagaMethodResult.IsSagaComplete)
            {
                _logger.LogInformation(
                    ContractCreateDomainEventLoggingId.RevisedNewContractRequestCommandReceived,
                    $"The RevisedNewContractSaga is prematurely complete ProcessId: {data.ProcessId}");
            }
            else
            {
                SagaStorageValue sagaStorageValue = new SagaStorageValue(sagaData: data, intent: Intent.RevisedNew);
                _sagaDataStorage.UploadSagaData(data.ProcessId, sagaStorageValue);
            }
        }

        private int GetContractVersionNumberForContract(string contractNumber)
        {
            return _crmLookupManager.GetLatestContractVersionNumberForContract(contractNumber) + 1 ?? 1;
        }

        private IEnumerable<IRule<contractRequestType>> GetValidationRules(contractRequestType contractRequest, ContractValidationLookupData lookupData, ConnectionInfo connectionInfo)
        {
            bool allowUseOfDeliveryOrgs = _fundingTypeFundingPeriodQueryRepository.Get(contractRequest.contract.fundingTypeCode,
                contractRequest.GetFundingPeriod(), connectionInfo).AllowUseOfDeliveryOrgs;

            IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto> GetFundingTypeFundingPeriodContractTypes()
            {
                IReadOnlyCollection<FundingTypeFundingPeriodContractType> fundingTypeFundingPeriodContractTypes = _fundingTypeFundingPeriodContractTypeQueryRepository.GetFundingTypeFundingPeriodContractTypes(connectionInfo);
                return CollectionTransformer.Transform<FundingTypeFundingPeriodContractType, FundingTypeFundingPeriodContractTypeDto>(fundingTypeFundingPeriodContractTypes);
            }

            return _contractOperationRules.GetCreateContractRevisedNewRules(
                contractRequest.FundingConfiguration,
                lookupData.ContractTypes,
                lookupData.LocalEnterprisePartnerships,
                lookupData.UnitsOfProcurement,
                lookupData.InvestmentPriorities,
                lookupData.RegionTypes,
                lookupData.SpecificationTitles,
                lookupData.FscDeliverableStructureData,
                lookupData.MatchingTenderAwardReferenceItems,
                lookupData.MultipleOverlappingContractsAllowedForFundingType,
                lookupData.FundingTypePeriodFundingStreamPeriods,
                lookupData.ProfileFundingStreamPeriodDeliverables,
                contractRequest,
                allowUseOfDeliveryOrgs,
                GetFundingTypeFundingPeriodContractTypes,
                lookupData.HasSiblingContractWithDraftStatus);
        }
    }
}
