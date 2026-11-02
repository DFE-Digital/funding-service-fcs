namespace ContractCreateDomain.Endpoint.CreateContract
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
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
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ContractCreateDomainEventLoggingId = Endpoint.ContractCreateDomainEventLoggingId;
    using IContractOperationRules = Infrastructure.IContractOperationRules;
    using IContractValidationLookupDataCreator = Infrastructure.IContractValidationLookupDataCreator;
    using IFundingTypeFundingPeriodQueryRepository = Infrastructure.IFundingTypeFundingPeriodQueryRepository;
    using IProcessedMessageRepository = Infrastructure.IProcessedMessageRepository;

    public class NewContractSaga :
        IHandleMessages<NewContractRequestCommand>            
    {
        private readonly CreateContractSaga _createContractSaga;
        private readonly Infrastructure.IContractOperationRules _contractOperationRules;
        private readonly ILogger _logger;
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;
        private readonly ISagaDataStorage _sagaDataStorage;
        private readonly IFundingTypeFundingPeriodContractTypeQueryRepository _fundingTypeFundingPeriodContractTypeQueryRepository;

        public NewContractSaga(
            IContractDeliverableEnricher contractDeliverableEnricher,
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
            IRelatedAllocationEnricher relatedAllocationEnricher)
        {
            _logger = logger;
            _contractOperationRules = contractOperationRules;
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _sagaDataStorage = sagaDataStorage;
            _fundingTypeFundingPeriodContractTypeQueryRepository = fundingTypeFundingPeriodContractTypeQueryRepository;

            _createContractSaga= new CreateContractSaga(
                contractDeliverableEnricher,
                contractRequestTransformer,
                contractValueAggregator,
                logger,
                numberRequestManager,
                organisationMessageEnricher,
                validator,
                processedMessageRepository,
                sessionConnectionFactory,
                ContractCreateDomainEventLoggingId.NewContractRequestCommandReceived,
                contractValidationLookupDataCreator,
                siblingApprovedContractService,
                relatedAllocationEnricher);
        }

        public async Task Handle(NewContractRequestCommand message, IMessageHandlerContext context)
        {
            CreateContractSagaData data = new CreateContractSagaData
            {
                DasEngagementEventId = message.DasEngagementEventId,
                ShouldReply = message.ShouldReply
            };

            SagaMethodResult sagaMethodResult = await _createContractSaga.Handle(message, context, data, GetValidationRules)
                .ConfigureAwait(false);

            if (sagaMethodResult.IsSagaComplete)
            {
                _logger.LogInformation(
                    ContractCreateDomainEventLoggingId.NewContractRequestCommandReceived,
                    $"The NewContractSaga is prematurely complete ProcessId: {data.ProcessId}");
            }
            else
            {
                SagaStorageValue sagaStorageValue = new SagaStorageValue(sagaData:data, intent: Intent.New);
                _sagaDataStorage.UploadSagaData(data.ProcessId, sagaStorageValue);
            }

            if (!data.ShouldReply)
            {
                message.ContractRequest.errorInfo
                    .Where(e => e.Severity == ErrorSeverity.Severe)
                    .ToList()
                    .ForEach(e => LogErrorToOperationsCode(error: e, prefix: "DAS"));

                message.ContractRequest.errorInfo
                    .Where(e => e.Severity == ErrorSeverity.Standard)
                    .ToList()
                    .ForEach(e => LogInformationToDasRequestCode(error: e, prefix: "DAS"));
            }

            _logger.LogInformation(
                ContractCreateDomainEventLoggingId.NewContractRequestCommandReceived,
                $"CreateContractRequestCommand - Handler complete: {message}, CorrelationId: {message.ContractRequest.correlationInfo.correlationId}");
        }

        private void LogErrorToOperationsCode(errorInfoType error, string prefix)
        {
           _logger.LogError(ContractCreateDomainEventLoggingId.FCSOperationsErrorCode, $"{prefix} - {error.Value}");
        }

        private void LogInformationToDasRequestCode(errorInfoType error, string prefix)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.DasRequestIgnored, $"{prefix} - {error.Value}");
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

            bool IsNewAmendmentAllowed(FundingTypeFundingPeriodDto fundingTypeFundingPeriod)
            {
                return _fundingTypeFundingPeriodQueryRepository
                    .Get(fundingTypeFundingPeriod.FundingType, fundingTypeFundingPeriod.FundingPeriod, connectionInfo)
                    .AllowNewAmendment;
            }

            return _contractOperationRules.GetCreateContractRules(
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
                IsNewAmendmentAllowed);
        }
    }
}
