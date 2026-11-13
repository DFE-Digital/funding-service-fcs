namespace ContractCreateDomain.Endpoint
{
    using NServiceBus;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Services;
    using Infrastructure;
    using Infrastructure.Extensions;
    using Services;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using IContractValidationLookupDataCreator = Infrastructure.IContractValidationLookupDataCreator;
    using IFundingTypePeriodService = Infrastructure.IFundingTypePeriodService;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    public class ModifyContractSaga 
    {
        private readonly ILogger _logger;
        private readonly IContractValidationLookupDataCreator _contractValidationLookupDataCreator;
        private readonly IValidator _validator;
        private readonly IOrganisationMessageEnricher _organisationMessageEnricher;
        private readonly IMasher _contractMasher;
        private readonly IContractRequestTransformer _contractRequestTransformer;
        private readonly IContractDeliverableEnricher _contractDeliverableEnricher;
        private readonly IContractValueAggregator _contractValueAggregator;
        private readonly IContractsManager _contractsManager;
        private readonly INumberRequestManager _numberRequestManager;
        private readonly IProcessedMessageRepository _processedMessageRepository;
        private readonly IPreviousContractMerger _previousContractMerger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly Action<ContractRequest.contractType> _incrementContractVersion;
        private readonly ILegalDeliverableService _legalDeliverableService;
        private readonly int _amendRequestCommandReceivedEventLoggingId;
        private readonly ICheckForContractChangeService _checkForContractChangeService;
        private readonly ISiblingApprovedContractService _siblingApprovedContractService;
        private readonly IRelatedAllocationEnricher _relatedAllocationEnricher;
        private readonly ILastApprovedContractCreationDateService _lastApprovedContractCreationDateService;

        private static readonly IReadOnlyCollection<Intent> AmendmentIntents = new List<Intent> { Intent.UpdateDraftAmendment, Intent.Amendment };
        private static readonly string ModifiedSubStatus = "Modified";

        public ModifyContractSaga(
            ILogger logger,
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
            Action<ContractRequest.contractType> incrementContractVersion,
            ILegalDeliverableService legalDeliverableService,
            int amendRequestCommandReceivedEventLoggingId,
            ICheckForContractChangeService checkForContractChangeService,
            ISiblingApprovedContractService siblingApprovedContractService,
            IRelatedAllocationEnricher relatedAllocationEnricher,
            ILastApprovedContractCreationDateService lastApprovedContractCreationDateService)
        {
            _logger = logger;
            _contractValidationLookupDataCreator = contractValidationLookupDataCreator;
            _validator = validator;
            _organisationMessageEnricher = organisationMessageEnricher;
            _contractMasher = contractMasher;
            _contractRequestTransformer = contractRequestTransformer;
            _contractDeliverableEnricher = contractDeliverableEnricher;
            _contractValueAggregator = contractValueAggregator;
            _contractsManager = contractsManager;
            _numberRequestManager = numberRequestManager;
            _processedMessageRepository = processedMessageRepository;
            _previousContractMerger = previousContractMerger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _incrementContractVersion = incrementContractVersion;
            _legalDeliverableService = legalDeliverableService;
            _amendRequestCommandReceivedEventLoggingId = amendRequestCommandReceivedEventLoggingId;
            _checkForContractChangeService = checkForContractChangeService;
            _siblingApprovedContractService = siblingApprovedContractService;
            _relatedAllocationEnricher = relatedAllocationEnricher;
            _lastApprovedContractCreationDateService = lastApprovedContractCreationDateService;
        }

        public async Task<SagaMethodResult> Handle(
            ModifyContractRequestCommand message,
            IMessageHandlerContext context,
            ModifyContractSagaData data,
            Func<ContractRequest.contractRequestType, ContractValidationLookupData, ConnectionInfo, IEnumerable<IRule<ContractRequest.contractRequestType>>> getFirstLevelRules,
            Func<ContractRequest.contractRequestType,
                ContractValidationLookupData,
                IReadOnlyCollection<ContractRequest.ContractIdentityInfo>,
                ConnectionInfo,
                IEnumerable<IRule<ContractRequest.contractRequestType>>> getSecondLevelRules,
            Action<ContractRequest.contractRequestType> addApprovedAllocationValues = null)
        {
            data.ProcessId = message.ContractRequest.correlationInfo.correlationId;
            data.BatchId = message.ContractRequest.correlationInfo.batchId;

            _logger.LogInformation(
                    _amendRequestCommandReceivedEventLoggingId,
                    $"ModifyContractRequestCommand - Handler started {message}, CorrelationId: {data.ProcessId}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            if (_processedMessageRepository.Add(context.MessageId, connectionInfo))
            {
                HashSet<ContractCorrelationData> contractCorrelationData = new HashSet<ContractCorrelationData>();

                message.ContractRequest
                    .GetSubContracts()
                    .ToList()
                    .ForEach(
                        c =>
                            contractCorrelationData.Add(new ContractCorrelationData(c.contractNumber)
                            {
                                IsCompleteDocGen = false
                            }));

                data.ContractsToProcessHashSet = contractCorrelationData.ConvertObjectToByteArray();

                _logger.LogInformation(_amendRequestCommandReceivedEventLoggingId, $"ModifyContractRequestCommand - Handler started {message}, CorrelationId: {data.ProcessId}");

                ContractRequest.contractRequestType contractRequest = message.ContractRequest;

                _logger.LogInformation(_amendRequestCommandReceivedEventLoggingId, $"Merging previous contract optional fields for: {message}");

                PreviousContractMergeResult previousContractMergeResult = _previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);

                _logger.LogInformation(_amendRequestCommandReceivedEventLoggingId, $"PreviousContractMergeResult was {previousContractMergeResult} for: {message}");

                if (previousContractMergeResult == PreviousContractMergeResult.PreviousContractMerged)
                {
                    _logger.LogInformation(_amendRequestCommandReceivedEventLoggingId, $"Getting lookup data for: {message}");

                    addApprovedAllocationValues?.Invoke(contractRequest);
                    ContractValidationLookupData lookupData = CreateLookupDataAndSetContractPresence(contractRequest, connectionInfo);

                    _logger.LogInformation(_amendRequestCommandReceivedEventLoggingId, $"Got lookup data for: {message}");

                    _organisationMessageEnricher.Enrich(contractRequest);

                    IEnumerable<IRule<ContractRequest.contractRequestType>> firstLevelRules = getFirstLevelRules(contractRequest, lookupData, connectionInfo);

                    if (_validator.Validate(contractRequest, firstLevelRules))
                    {
                        return await ProcessFirstLevelValidContract(contractRequest, context, data, getSecondLevelRules).ConfigureAwait(false);
                    }

                    await ProcessFirstLevelInvalidContract(contractRequest, context, data).ConfigureAwait(false);

                    return new SagaMethodResult(true);
                }
                
                await ProcessFirstLevelInvalidContract(contractRequest, context, data).ConfigureAwait(false);

                return new SagaMethodResult(true);
            }
                       
            _logger.LogInformation(
                ContractCreateDomainEventLoggingId.ModifyContractRequestCommandHandlerAlreadyProcessedThisMessage,
                $"ModifyContractRequestCommand - Handler we have already processed this: {message}, CorrelationId: {data.ProcessId}");
            
            _logger.LogInformation(
              ContractCreateDomainEventLoggingId.ModifyContractRequestCommandHandlerComplete,
              $"ModifyContractRequestCommand - Handler complete: {message}, CorrelationId: {data.ProcessId}");

            return new SagaMethodResult(true);
        }

        public static async Task Handle(DocumentGenerationComplete message,
            IMessageHandlerContext context,
            ModifyContractSagaData data,
            object commandToSendCrm,
            ILogger logger,
            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository,
            IFundingTypePeriodService fundingTypePeriodService,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            logger.LogInformation(
                ContractCreateDomainEventLoggingId.DocumentGenerationComplete,
                "{0} message received. ProcessId:{1}",
                message.GetType(),
                data.ProcessId);

            HashSet<ContractCorrelationData> correlationData =
                data.ContractsToProcessHashSet.ConvertByteArrayToObject<HashSet<ContractCorrelationData>>();
            correlationData.Single(c => c.ContractNumber == message.ContractNumber).IsCompleteDocGen = true;

            if (correlationData.All(c => c.IsCompleteDocGen)) // all processed flags true
            {
                if (commandToSendCrm is ModifyContractInCrmCommand amendContractCommand)
                {
                    CorporateContract.ExtendedContractType childContract = amendContractCommand.Contract.contracts.First();
                    var fundingTypeCode = childContract.fundingType.fundingTypeCode;
                    var fundingPeriod = childContract.period.GetFundingPeriodName();
                    ConnectionInfo connectionInfo = sessionConnectionFactory.GetConnection(context);
                    FundingTypeFundingPeriod fundingTypeFundingPeriod = fundingTypeFundingPeriodQueryRepository.Get(fundingTypeCode, fundingPeriod, connectionInfo);
                    fundingTypePeriodService.EnrichContract(amendContractCommand.Contract, fundingTypeFundingPeriod);

                    amendContractCommand.Contract.contracts.ForEach(c =>
                    {
                        c.CopyTerminationDetailsToProvisionalFields();
                    });
                }
                
                await context.Send(commandToSendCrm);
            }

            data.ContractsToProcessHashSet = correlationData.ConvertObjectToByteArray();
        }

        public static async Task Handle(ContractAmended message, IMessageHandlerContext context, ModifyContractSagaData data, ILogger logger)
        {
            logger.LogInformation(
                ContractCreateDomainEventLoggingId.ContractAmendedReceived,
                "{0} message received. ProcessId:{1}, ContractNumber(s):{2}:",
                message.GetType(),
                data.ProcessId,
                string.Join(", ", data.MashedContractRequest.ConvertByteArrayToObject<ContractRequest.contractRequestType>().contract.contracts.Select(c => c.contractNumber)));

            await context.Send(new ContractRequestProcessedCommand
            {
                ContractRequest = data.MashedContractRequest.ConvertByteArrayToObject<ContractRequest.contractRequestType>()
            });
        }

        public static async Task Handle(AmendContractUnsuccessful message, IMessageHandlerContext context, ModifyContractSagaData data, ILogger logger)
        {
            logger.LogInformation(
                ContractCreateDomainEventLoggingId.AmendContractUnsuccessfulReceived,
                "{0} message received. ProcessId:{1}, ContractNumber(s):{2}:",
                message.GetType(),
                data.ProcessId,
                string.Join(", ", data.MashedContractRequest.ConvertByteArrayToObject<ContractRequest.contractRequestType>().contract.contracts.Select(c => c.contractNumber)));

            var contractRequestToSend = message.ContractRequest ?? data.MashedContractRequest.ConvertByteArrayToObject<ContractRequest.contractRequestType>();

            if (message.Error != null)
            {
                contractRequestToSend.errorInfo.Add(message.Error);
            }

            await context.Send(new ContractRequestProcessedCommand
            {
                ContractRequest = contractRequestToSend
            });
        }

        protected ContractValidationLookupData CreateLookupDataAndSetContractPresence(ContractRequest.contractRequestType contractRequest, ConnectionInfo connectionInfo)
        {
            return _contractValidationLookupDataCreator.CreateLookupDataAndSetContractPresence(contractRequest, connectionInfo);
        }

        public async Task<SagaMethodResult> ProcessFirstLevelValidContract(
            ContractRequest.contractRequestType contractRequest,
            IMessageHandlerContext context,
            ModifyContractSagaData data,
            Func<ContractRequest.contractRequestType,
                ContractValidationLookupData,
                IReadOnlyCollection<ContractRequest.ContractIdentityInfo>,
                ConnectionInfo,
                IEnumerable<IRule<ContractRequest.contractRequestType>>> getSecondLevelRules)
        {
            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            if (contractRequest.HasUnnumberedAllocations())
            {
                EnrichWithMissingContractNumbers(contractRequest, connectionInfo);
            }

            ContractRequest.contractType existingCrmContractRequest = GetExistingContract(contractRequest, data.ProcessId);

            _legalDeliverableService.RemoveNonLegalDeliverablesFromContractType(connectionInfo, existingCrmContractRequest);

            IReadOnlyCollection<ContractRequest.ContractIdentityInfo> lastApprovedContractIdentityInfos =
                GetLastApprovedContractIdentityInformation(existingCrmContractRequest);

            // the masher updates the existing with the delta
            Intent intentOfImportedContract = contractRequest.contract.CRMIntent;
            
            contractRequest.contract = _contractMasher.Mash(existingCrmContractRequest, contractRequest.contract);
            
            if (AmendmentIntents.Contains(intentOfImportedContract))
            {
                _checkForContractChangeService.UpdateAllocationsThatHaveBeenAddedOrChangedService(mergedContract: existingCrmContractRequest);
                contractRequest.GetSubContracts().ToList().ForEach(c =>
                {
                    var subStatusOfLastApproved = _contractsManager.GetSubStatusOfLastApproved(c.contractNumber);
                    c.EnsureAllAllocationsHaveTheSameModificationDetails(subStatusOfLastApproved == ModifiedSubStatus);
                });
            }
            
            contractRequest.GetSubContracts().ToList().ForEach(childContract =>
            {
                if (childContract.IsWithdrawnContractWithContractNumberPresentInCrm)
                {
                    var maxWithdrawnVersionNo = _contractsManager.GetMaxWithdrawnContractVersion(childContract.contractNumber);
                    if (maxWithdrawnVersionNo > childContract.contractVersionNumber)
                    {
                        childContract.contractVersionNumber = maxWithdrawnVersionNo;
                    }
                }
            });

            // need to run again as after mashing we may have more allocations than we had before and we need to get data relevant to that

            ContractValidationLookupData lookupData = CreateLookupDataAndSetContractPresence(contractRequest, connectionInfo);

            IEnumerable<IRule<ContractRequest.contractRequestType>> rules = getSecondLevelRules(contractRequest, lookupData, lastApprovedContractIdentityInfos, connectionInfo);

            if (_validator.Validate(contractRequest, rules))
            {
                await ProcessSecondLevelValidContract(contractRequest, context, data).ConfigureAwait(false);
                return new SagaMethodResult(false);
            }
            
            await ProcessSecondLevelInvalidContract(contractRequest, context, data.ProcessId).ConfigureAwait(false);

            return new SagaMethodResult(true);
        }

        private IReadOnlyCollection<ContractRequest.ContractIdentityInfo> GetLastApprovedContractIdentityInformation(ContractRequest.contractType masterContract)
        {
            List<ContractRequest.ContractIdentityInfo> identityInfos = new List<ContractRequest.ContractIdentityInfo>();

            masterContract?.contracts.ForEach(childContract =>
            {
                ContractRequest.ContractIdentityInfo lastApprovedContractIdentityInfo =
                    _contractsManager.GetLastApprovedContractIdentityInfo(childContract.contractNumber);

                if (lastApprovedContractIdentityInfo != null)
                {
                    identityInfos.Add(lastApprovedContractIdentityInfo);
                }
            });

            return identityInfos;
        }

        private async Task ProcessFirstLevelInvalidContract(ContractRequest.contractRequestType contractRequest, IMessageHandlerContext context, ModifyContractSagaData data)
        {
            _logger.LogInformation(
                ContractCreateDomainEventLoggingId.ValidationFailed,
                "First level validation has failed for modify amendment {0} - wait for report",
                data.ProcessId);

            await context.Send(new ContractRequestProcessedCommand
            {
                ContractRequest = contractRequest
            });
        }

        private void EnrichWithMissingContractNumbers(ContractRequest.contractRequestType contractRequestType, ConnectionInfo connectionInfo)
        {
            _numberRequestManager.GetContractNumbers(contractRequestType, connectionInfo); // GetContractNumbers enriches passed reference 

            _logger.LogInformation(
                ContractCreateDomainEventLoggingId.ContractNumbersAdded,
                "Contract Numbers have been added for {0}",
                contractRequestType.correlationInfo.correlationId);
        }

        private ContractRequest.contractType GetExistingContract(ContractRequest.contractRequestType contractRequestType, string processId)
        {
            var masterContractNumber = contractRequestType.contract.contractNumber;

            _logger.LogInformation(
                ContractCreateDomainEventLoggingId.RetrievingContractFromCRM,
                $"Retrieving Master Contract {masterContractNumber} for {processId} from CRM");

            var contractRequestContract = _contractsManager.GetLatestContract(
                masterContractNumber,
                contractRequestType.GetSubContracts().Select(c => c.contractNumber));

            _logger.LogInformation(
                ContractCreateDomainEventLoggingId.RetrievedContractFromCRM,
                $"Retrieved Master Contract {masterContractNumber} for {processId} from CRM");

            return contractRequestContract;
        }

        private async Task ProcessSecondLevelValidContract(ContractRequest.contractRequestType mashedContractRequest, IMessageHandlerContext context, ModifyContractSagaData data)
        {
            foreach (var childContract in mashedContractRequest.GetSubContracts())
            {
                _incrementContractVersion(childContract);
                childContract.PreviousVersionId = childContract.Id;
                childContract.Id = null;
            }

            CorporateContract.ExtendedContractType corporateContract = _contractRequestTransformer.TransformToCorpContractType(mashedContractRequest);

            _contractDeliverableEnricher.Enrich(corporateContract);
            _contractValueAggregator.Aggregate(corporateContract);

            if (data.UpdateValueVarianceRequired)
            {
                // the mashed contract may have extra allocations but none will have a value set (the values are held on the deliverables)
                // we do not support deletes
                ContractRequest.contractType contractToCheckForVariance = data.GetContractTypeForVarianceCalculation(mashedContractRequest.contract);
                _contractValueAggregator.UpdateValueVariance(corporateContract, contractToCheckForVariance);
            }

            data.MashedContractRequest = mashedContractRequest.ConvertObjectToByteArray();
            data.ExtendedCorporateContract = corporateContract.ConvertObjectToByteArray();

            SendOptions sendOptions = new SendOptions();
            sendOptions.RouteReplyTo("ContractCreateDomain.CreateContractInternal");

            string masterContractNumber = corporateContract.contractNumber;
            var connectionInfo = _sessionConnectionFactory.GetConnection(context);
            foreach (var contract in corporateContract.contracts)
            {
                CorporateContract.Contract corpContract =
                    _contractRequestTransformer.TransformToCorpContract(contract);
                corpContract.IsNewRevisedNewOrUpdateDraft = mashedContractRequest.IsNewRevisedNewOrUpdateDraft();
                corpContract.IsAmendment = mashedContractRequest.IsAmendment();

                IReadOnlyCollection<CorporateContract.ApprovedContractInfo> siblingApprovedContractsForDocumentGeneration =
                    await _siblingApprovedContractService.GetSiblingApprovedContractsForDocumentGeneration(
                        masterContractNumber,
                        contract.contractNumber,
                        corpContract.fundingType.fundingTypeCode,
                        corpContract.GetFundingPeriod(),
                        connectionInfo).ConfigureAwait(false);

                corpContract.SharedMasterApprovedContracts = siblingApprovedContractsForDocumentGeneration.ToList();
                corpContract.SharedMasterApprovedContracts.ForEach(_relatedAllocationEnricher.EnrichWithRelatedAllocationsWhenAppropriate);

                await _relatedAllocationEnricher.EnrichWithRelatedAllocationsWhenAppropriate(corpContract, connectionInfo);

                corpContract.LatestCreatedDateForNonNotificationApprovedContract =
                    await _lastApprovedContractCreationDateService.GetLatestCreatedDateForNonNotificationApprovedContract(corpContract.contractNumber, connectionInfo);

                corpContract.IsVariation = contract.amendmentType == SFA.FCT.ContractManagementService.Common.AmendmentType.Variation.ToString();

                await context.Send(
                    new DocumentGenerationCommand
                    {
                        CorporateContract = corpContract,
                        CorrelationId = data.ProcessId,
                        MasterContractNumber = masterContractNumber
                    },
                    sendOptions);
            }
        }

        private async Task ProcessSecondLevelInvalidContract(ContractRequest.contractRequestType mashedContractRequest, IMessageHandlerContext context, string processId)
        {
            _logger.LogInformation(
                ContractCreateDomainEventLoggingId.ValidationFailed,
                "Second level validation has failed for modify amendment {0} - wait for report",
                processId);

            await context.Send(new ContractRequestProcessedCommand()
            {
                ContractRequest = mashedContractRequest
            }).ConfigureAwait(continueOnCapturedContext: false);
        }
    }
}
