namespace ContractCreateDomain.Endpoint.CreateContract
{
    using AutoMapper;
    using ContractManagement.DataStore.Dtos;
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
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using ContractCreateDomainEventLoggingId = Endpoint.ContractCreateDomainEventLoggingId;
    using CR=SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using IContractOperationRules = Infrastructure.IContractOperationRules;
    using IContractValidationLookupDataCreator = Infrastructure.IContractValidationLookupDataCreator;
    using IFundingTypeFundingPeriodQueryRepository = Infrastructure.IFundingTypeFundingPeriodQueryRepository;
    using IProcessedMessageRepository = Infrastructure.IProcessedMessageRepository;

    public class NewAmendmentSaga : IHandleMessages<NewAmendmentRequestCommand>
    {
        private readonly CreateContractSaga _createContractSaga;
        private readonly Infrastructure.IContractOperationRules _contractOperationRules;
        private readonly ILogger _logger;
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;
        private readonly ISagaDataStorage _sagaDataStorage;
        private readonly IFundingTypeFundingPeriodContractTypeQueryRepository _fundingTypeFundingPeriodContractTypeQueryRepository;
        private readonly IMapper _mapper;

        public NewAmendmentSaga(IContractDeliverableEnricher contractDeliverableEnricher,
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
            IFundingTypeFundingPeriodContractTypeQueryRepository fundingTypeFundingPeriodContractTypeQueryRepository,
            ISiblingApprovedContractService siblingApprovedContractService,
            IRelatedAllocationEnricher relatedAllocationEnricher,
            IMapper mapper)
        {
            _contractOperationRules = contractOperationRules;
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _sagaDataStorage = sagaDataStorage;
            _fundingTypeFundingPeriodContractTypeQueryRepository = fundingTypeFundingPeriodContractTypeQueryRepository;
            _logger = logger;
            _mapper= mapper;

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
                ContractCreateDomainEventLoggingId.NewAmendmentRequestCommandReceived,
                contractValidationLookupDataCreator,
                siblingApprovedContractService,
                relatedAllocationEnricher);
        }

        public async Task Handle(NewAmendmentRequestCommand message, IMessageHandlerContext context)
        {
            CreateContractSagaData data = new CreateContractSagaData();
            
            SagaMethodResult sagaMethodResult = await _createContractSaga.Handle(message, context, data, GetValidationRules)
                .ConfigureAwait(false);

            if (sagaMethodResult.IsSagaComplete)
            {
                _logger.LogInformation(
                    ContractCreateDomainEventLoggingId.RevisedNewContractRequestCommandReceived,
                    $"The NewAmendmentSaga is prematurely complete ProcessId: {data.ProcessId}");
            }
            else
            {
                SagaStorageValue sagaStorageValue = new SagaStorageValue(sagaData: data, intent: Intent.NewAmendment);
                _sagaDataStorage.UploadSagaData(data.ProcessId, sagaStorageValue);
            }
        }

        private IEnumerable<IRule<CR.contractRequestType>> GetValidationRules(CR.contractRequestType contractRequest, ContractValidationLookupData lookupData, ConnectionInfo connectionInfo)
        {
            bool allowUseOfDeliveryOrgs = _fundingTypeFundingPeriodQueryRepository.Get(contractRequest.contract.fundingTypeCode,
                contractRequest.GetFundingPeriod(), connectionInfo).AllowUseOfDeliveryOrgs;

            IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto> GetFundingTypeFundingPeriodContractType()
            {
                IReadOnlyCollection<FundingTypeFundingPeriodContractType> fundingTypeFundingPeriodContractTypes = _fundingTypeFundingPeriodContractTypeQueryRepository.GetFundingTypeFundingPeriodContractTypes(connectionInfo);
                return CollectionTransformer.Transform<FundingTypeFundingPeriodContractType, FundingTypeFundingPeriodContractTypeDto>(fundingTypeFundingPeriodContractTypes,_mapper);
            }

            bool IsNewAmendmentAllowed(FundingTypeFundingPeriodDto fundingTypeFundingPeriod)
            {
                return _fundingTypeFundingPeriodQueryRepository
                    .Get(fundingTypeFundingPeriod.FundingType, fundingTypeFundingPeriod.FundingPeriod, connectionInfo)
                    .AllowNewAmendment;
            }

            return _contractOperationRules.GetNewAmendmentContractRules(
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
                GetFundingTypeFundingPeriodContractType,
                IsNewAmendmentAllowed,
                lookupData.HasSiblingContractWithDraftStatus);
        }
    }
}
