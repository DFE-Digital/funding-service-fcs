namespace ContractCreateDomain.Endpoint.UpdateDraftContractAmendment
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using ContractManagement.DataStore.Services;
    using Infrastructure;
    using Infrastructure.DTOs;
    using Infrastructure.Extensions;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.DTOs;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using IContractValidationLookupDataCreator = Infrastructure.IContractValidationLookupDataCreator;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using IContractOperationRules = Infrastructure.IContractOperationRules;
    using IFundingTypeFundingPeriodQueryRepository = Infrastructure.IFundingTypeFundingPeriodQueryRepository;
    using IFundingTypePeriodService = Infrastructure.IFundingTypePeriodService;
    using IProcessedMessageRepository = Infrastructure.IProcessedMessageRepository;
    using Services;

    public class UpdateDraftContractAmendmentSaga :
        IHandleMessages<UpdateDraftContractAmendmentRequestCommand>
    {
        private readonly IContractOperationRules _contractOperationRules;
        private readonly IContractRequestTransformer _contractRequestTransformer;
        private readonly ILookupManager _lookupManager;
        private readonly ModifyContractSaga _modifyContractSaga;
        private readonly ILogger _logger;
        private readonly ISagaDataStorage _sagaDataStorage;
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;
        private readonly IFundingTypeFundingPeriodContractTypeQueryRepository _fundingTypeFundingPeriodContractTypeQueryRepository;

        public UpdateDraftContractAmendmentSaga(
            ILogger logger,
            IContractOperationRules contractOperationRules,
            IContractValidationLookupDataCreator contractValidationLookupDataCreator,
            IValidator validator,
            IOrganisationMessageEnricher organisationMessageEnricher,
            IMasher contractMasher,
            IContractRequestTransformer contractRequestTransformer,
            IContractDeliverableEnricher contractDeliverableEnricher,
            IContractValueAggregator contractValueAggregator,
            IContractsManager contractsManager,
            INumberRequestManager numberRequestManager,
            ILookupManager lookupManager,
            IProcessedMessageRepository processedMessageRepository,
            IPreviousContractMerger previousContractMerger,
            ISessionConnectionFactory sessionConnectionFactory,
            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository,
            ILegalDeliverableService legalDeliverableService,
            ISagaDataStorage sagaDataStorage, IFundingTypeFundingPeriodContractTypeQueryRepository fundingTypeFundingPeriodContractTypeQueryRepository,
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
            _contractRequestTransformer = contractRequestTransformer;
            _lookupManager = lookupManager;
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _sagaDataStorage = sagaDataStorage;
            _fundingTypeFundingPeriodContractTypeQueryRepository = fundingTypeFundingPeriodContractTypeQueryRepository;
            _logger = logger;
        }

        protected int AmendRequestCommandReceivedEventLoggingId => ContractCreateDomainEventLoggingId.UpdateDraftContractAmendmentRequestCommandReceived;

        public async Task Handle(UpdateDraftContractAmendmentRequestCommand message, IMessageHandlerContext context)
        {
            ModifyContractSagaData data = new ModifyContractSagaData
            {
                GetContractTypeForVarianceCalculation = GetContractTypeForVarianceCalculation
            };

            SagaMethodResult sagaMethodResult = await _modifyContractSaga.Handle(
                message,
                context,
                data,
                GetFirstLevelValidationRules,
                GetSecondLevelValidationRules,
                AddApprovedContractAllocationsToContract).ConfigureAwait(false);

            if (sagaMethodResult.IsSagaComplete)
            {
                _logger.LogInformation(
                    AmendRequestCommandReceivedEventLoggingId,
                    $"The UpdateDraftContractSaga is prematurely complete Batch: {data.BatchId}, ProcessId: {data.ProcessId}");
            }
            else
            {
                SagaStorageValue sagaStorageValue = new SagaStorageValue(sagaData: data, intent: Intent.UpdateAmendment);
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

            return _contractOperationRules.GetUpdateDraftContractAmendmentFirstLevelRules(
                contractRequestType,
                lookupData.FscDeliverableStructureData,
                lookupData.ProfileFundingStreamPeriodDeliverables,
                GetFundingTypeFundingPeriodContractTypes);
        }

        private IEnumerable<IRule<SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractRequestType>> GetSecondLevelValidationRules(
            SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractRequestType contractRequestType,
            ContractValidationLookupData lookupData,
            IReadOnlyCollection<ContractIdentityInfo> lastApprovedContractIdentityInfos,
            ConnectionInfo connectionInfo)
        {
            bool allowUseOfDeliveryOrgs = _fundingTypeFundingPeriodQueryRepository.Get(contractRequestType.contract.fundingTypeCode,
                contractRequestType.GetFundingPeriod(), connectionInfo).AllowUseOfDeliveryOrgs;

            return _contractOperationRules.GetUpdateDraftContractAmendmentSecondLevelRules(
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

            return new UpdateContractCommand
            {
                BatchId = sagaData.BatchId,
                CorrelationId = sagaData.ProcessId,
                Contract = extendedContract
            };
        }

        protected contractType GetContractTypeForVarianceCalculation(contractType contract)
        {
            var transformedChildContracts =
                contract.contracts
                        .SelectMany(c =>
                        {
                            string contractNumber = c.contractNumber;
                            int ukprn = c.contractor.ukprn;

                            if (contract.ApprovedAllocationValues == null ||
                                !contract.ApprovedAllocationValues.Any())
                            {
                                contract.ApprovedAllocationValues = _lookupManager.GetAllocationsForApprovedContract(contractNumber);
                            }

                            return _contractRequestTransformer
                                .TransformAllocationsToContractRequestContract(
                                    contract.ApprovedAllocationValues, contractNumber, ukprn)
                                .contracts;
                        }).ToList();

            return new contractType
            {
                contracts = transformedChildContracts
            };
        }

        private void IncrementContractVersion(contractType contractType)
        {
            contractType.contractSubVersionNumber++;
        }

        private void AddApprovedContractAllocationsToContract(contractRequestType contractRequest)
        {
            contractRequest.contract.contracts.ForEach(subContract =>
            {
                subContract.ApprovedAllocationValues = _lookupManager.GetAllocationsForApprovedContract(subContract.contractNumber);
            });
        }
    }
}
