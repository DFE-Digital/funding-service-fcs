namespace ContractCreateDomain.Endpoint.AmendContract
{
    using AutoMapper;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using ContractManagement.DataStore.Services;
    using Infrastructure;
    using Infrastructure.DTOs;
    using Infrastructure.Extensions;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.DTOs;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;    
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Threading.Tasks;
    using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using IContractValidationLookupDataCreator = Infrastructure.IContractValidationLookupDataCreator;
    using IFundingTypeFundingPeriodQueryRepository = Infrastructure.IFundingTypeFundingPeriodQueryRepository;
    using IFundingTypePeriodService = Infrastructure.IFundingTypePeriodService;
    using IProcessedMessageRepository = Infrastructure.IProcessedMessageRepository;
    
    public class ContractAmendmentSaga :
        IHandleMessages<ContractAmendmentRequestCommand>
    {
        private readonly ContractCreateDomain.Endpoint.Infrastructure.IContractOperationRules _contractOperationRules;
        private readonly ModifyContractSaga _modifyContractSaga = null;
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;
        private readonly TimeSpan _timeoutInterval = TimeSpan.FromMinutes(int.Parse(ConfigurationManager.AppSettings["ContractOperationSagaTimeoutInMinutes"]));
        private readonly ILogger _logger;
        private readonly ISagaDataStorage _sagaDataStorage;
        private readonly IMapper _mapper;

        private readonly IFundingTypeFundingPeriodContractTypeQueryRepository
            _fundingTypeFundingPeriodContractTypeQueryRepository;

        public ContractAmendmentSaga(
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
            IFundingTypePeriodService fundingTypePeriodService,
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
            ILastApprovedContractCreationDateService lastApprovedContractCreationDate,
            IMapper mapper)
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
            _mapper= mapper;
        }

        private int AmendRequestCommandReceivedEventLoggingId => ContractCreateDomainEventLoggingId.ContractAmendmentRequestCommandReceived;

        public async Task Handle(ContractAmendmentRequestCommand message, IMessageHandlerContext context)
        {
            ModifyContractSagaData data = new ModifyContractSagaData();

            SagaMethodResult sagaMethodResult = await _modifyContractSaga.Handle(message, context, data, GetFirstLevelValidationRules, GetSecondLevelValidationRules).ConfigureAwait(false);

           if (sagaMethodResult.IsSagaComplete)
           {
               _logger.LogInformation(
                   AmendRequestCommandReceivedEventLoggingId,
                   $"The ContractAmendmentSaga is prematurely complete Batch: {data.BatchId}, ProcessId: {data.ProcessId}");
           }
           else
           {
               SagaStorageValue sagaStorageValue = new SagaStorageValue(sagaData: data, intent: Intent.Amendment);
                _sagaDataStorage.UploadSagaData(data.ProcessId, sagaStorageValue);
           }
        }

        protected IEnumerable<IRule<ContractRequest.contractRequestType>> GetFirstLevelValidationRules(
            ContractRequest.contractRequestType contractRequestType,
            ContractValidationLookupData lookupData,
            ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto> GetFundingTypeFundingPeriodContractTypes()
            {
                IReadOnlyCollection<FundingTypeFundingPeriodContractType> fundingTypeFundingPeriodContractTypes = _fundingTypeFundingPeriodContractTypeQueryRepository.GetFundingTypeFundingPeriodContractTypes(connectionInfo);
                return CollectionTransformer.Transform<FundingTypeFundingPeriodContractType, FundingTypeFundingPeriodContractTypeDto>(fundingTypeFundingPeriodContractTypes,_mapper);
            }

            return _contractOperationRules.GetContractAmendmentFirstLevelRules(contractRequestType,
                lookupData.FscDeliverableStructureData
                , lookupData.ProfileFundingStreamPeriodDeliverables, GetFundingTypeFundingPeriodContractTypes,
                lookupData.HasSiblingContractWithDraftStatus);
        }

        protected IEnumerable<IRule<ContractRequest.contractRequestType>> GetSecondLevelValidationRules(
            ContractRequest.contractRequestType contractRequestType,
            ContractValidationLookupData lookupData,
            IReadOnlyCollection<ContractRequest.ContractIdentityInfo> lastApprovedContractIdentityInfos,
            ConnectionInfo connectionInfo)
        {            
            bool allowUseOfDeliveryOrgs = _fundingTypeFundingPeriodQueryRepository.Get(contractRequestType.contract.fundingTypeCode,
                contractRequestType.GetFundingPeriod(), connectionInfo).AllowUseOfDeliveryOrgs;
         
            return _contractOperationRules.GetContractAmendmentSecondLevelRules(
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
                lastApprovedContractIdentityInfos,
                allowUseOfDeliveryOrgs);
        }

        private object GetCommandToSaveToCrm(ModifyContractSagaData sagaData)
        {
            CorporateContract.ExtendedContractType extendedContract = sagaData.ExtendedCorporateContract.ConvertByteArrayToObject<CorporateContract.ExtendedContractType>();

            return new AmendContractCommand
            {
                BatchId = sagaData.BatchId,
                CorrelationId = sagaData.ProcessId,
                Contract = extendedContract
            };
        }

        private void IncrementContractVersion(contractType contractType)
        {
            contractType.contractVersionNumber++;
            contractType.contractSubVersionNumber = 0;
        }
    }
}
