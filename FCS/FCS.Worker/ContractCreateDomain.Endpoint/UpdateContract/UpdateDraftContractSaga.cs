namespace ContractCreateDomain.Endpoint.UpdateContract
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using ContractManagement.DataStore.Services;
    using Infrastructure;
    using Infrastructure.DTOs;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.DTOs;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using IContractValidationLookupDataCreator = Infrastructure.IContractValidationLookupDataCreator;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType;
    using IFundingTypeFundingPeriodQueryRepository = Infrastructure.IFundingTypeFundingPeriodQueryRepository;
    using IFundingTypePeriodService = Infrastructure.IFundingTypePeriodService;
    using IProcessedMessageRepository = Infrastructure.IProcessedMessageRepository;

    public class UpdateDraftContractSaga :
        IHandleMessages<DraftContractUpdateRequestCommand>
    {
        private readonly ContractCreateDomain.Endpoint.Infrastructure.IContractOperationRules _contractOperationRules;
        private readonly ModifyContractSaga _modifyContractSaga = null;
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;
        private readonly ILogger _logger;
        private readonly ISagaDataStorage _sagaDataStorage;
        private readonly IFundingTypeFundingPeriodContractTypeQueryRepository _fundingTypeFundingPeriodContractTypeQueryRepository;

        public UpdateDraftContractSaga(
            ILogger logger,
            ContractCreateDomain.Endpoint.Infrastructure.IContractOperationRules contractOperationRules,
            IContractValidationLookupDataCreator contractValidationLookupDataCreator,
            IValidator validator,
            IOrganisationMessageEnricher organisationMessageEnricher,
            IMasher contractMasher,
            IContractRequestTransformer contractRequestTransformer,
            IContractDeliverableEnricher contractDeliverableEnricher,
            IContractValueAggregator contractValueAggregator,
            IContractsManager contractsManager,
            INumberRequestManager numberRequestManager,
            IProcessedMessageRepository processedMessageRepository,
            IPreviousContractMerger previousContractMerger,
            ISessionConnectionFactory sessionConnectionFactory,
            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository,
            ILegalDeliverableService legalDeliverableService,
            ISagaDataStorage sagaDataStorage,
            IFundingTypeFundingPeriodContractTypeQueryRepository fundingTypeFundingPeriodContractTypeQueryRepository,
            ICheckForContractChangeService checkForContractChangeService,
            ISiblingApprovedContractService siblingApprovedContractService,
            IRelatedAllocationEnricher relatedAllocationEnricher,
            ILastApprovedContractCreationDateService lastApprovedContractCreationDate)
        {
            _modifyContractSaga = new ModifyContractSaga(
                logger,
                contractValidationLookupDataCreator,
                validator,
                organisationMessageEnricher,
                contractMasher,
                contractRequestTransformer,
                contractDeliverableEnricher,
                contractValueAggregator,
                contractsManager,
                numberRequestManager,
                processedMessageRepository,
                previousContractMerger,
                sessionConnectionFactory,
                IncrementContractVersion,
                legalDeliverableService,
                AmendRequestCommandReceivedEventLoggingId,
                checkForContractChangeService,
                siblingApprovedContractService,
                relatedAllocationEnricher,
                lastApprovedContractCreationDate);
            _contractOperationRules = contractOperationRules;
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _sagaDataStorage = sagaDataStorage;
            _fundingTypeFundingPeriodContractTypeQueryRepository = fundingTypeFundingPeriodContractTypeQueryRepository;
            _logger = logger;
        }

        private int AmendRequestCommandReceivedEventLoggingId => SFA.FCT.ContractCreateDomain.BusinessLogic.ContractCreateDomainEventLoggingId.UpdatedDraftContract;

        private void IncrementContractVersion(contractType contractType)
        {
            contractType.contractSubVersionNumber++;
        }

        public async Task Handle(DraftContractUpdateRequestCommand message, IMessageHandlerContext context)
        {
            ModifyContractSagaData data = new ModifyContractSagaData
            {
                UpdateValueVarianceRequired = false
            };

            SagaMethodResult sagaMethodResult = await _modifyContractSaga.Handle(message, context, data, GetFirstLevelValidationRules, GetSecondLevelValidationRules).ConfigureAwait(false);

            if (sagaMethodResult.IsSagaComplete)
            {
                _logger.LogInformation(
                    AmendRequestCommandReceivedEventLoggingId,
                    $"The UpdateDraftContractSaga is prematurely complete Batch: {data.BatchId}, ProcessId: {data.ProcessId}");
            }
            else
            {
                SagaStorageValue sagaStorageValue = new SagaStorageValue(sagaData: data, intent: Intent.Update);
                _sagaDataStorage.UploadSagaData(data.ProcessId, sagaStorageValue);
            }
        }

        private IEnumerable<IRule<SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractRequestType>> GetFirstLevelValidationRules(
            SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractRequestType contractRequestType,
            ContractValidationLookupData lookupData,
            ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto> GetFundingTypeFundingPeriodContractTypes()
            {
                IReadOnlyCollection<FundingTypeFundingPeriodContractType> fundingTypeFundingPeriodContractTypes = _fundingTypeFundingPeriodContractTypeQueryRepository.GetFundingTypeFundingPeriodContractTypes(connectionInfo);
                return CollectionTransformer.Transform<FundingTypeFundingPeriodContractType, FundingTypeFundingPeriodContractTypeDto>(fundingTypeFundingPeriodContractTypes);
            }

            return _contractOperationRules.GetUpdateDraftContractFirstLevelRules(
                contractRequestType,
                lookupData.FscDeliverableStructureData,
                lookupData.ProfileFundingStreamPeriodDeliverables,
                GetFundingTypeFundingPeriodContractTypes);
        }

        private IEnumerable<IRule<SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractRequestType>> GetSecondLevelValidationRules(
            SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractRequestType contractRequestType,
            ContractValidationLookupData lookupData,
            IReadOnlyCollection<SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.ContractIdentityInfo> lastApprovedContractIdentityInfos,
            ConnectionInfo connectionInfo)
        {

            bool allowUseOfDeliveryOrgs = _fundingTypeFundingPeriodQueryRepository.Get(contractRequestType.contract.fundingTypeCode,
                contractRequestType.GetFundingPeriod(), connectionInfo).AllowUseOfDeliveryOrgs;

            return _contractOperationRules.GetUpdateDraftContractSecondLevelRules(
                contractRequestType.FundingConfiguration,
                lookupData.ContractTypes,
                lookupData.LocalEnterprisePartnerships,
                lookupData.UnitsOfProcurement,
                lookupData.RegionTypes,
                lookupData.SpecificationTitles,
                lookupData.InvestmentPriorities,
                lookupData.FscDeliverableStructureData,
                lookupData.MatchingTenderAwardReferenceItems,
                lookupData.FundingTypePeriodFundingStreamPeriods,
                contractRequestType,
                allowUseOfDeliveryOrgs);
        }
    }
}
