namespace ContractCreateDomain.Endpoint
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Infrastructure;
    using Infrastructure.Extensions;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using IContractValidationLookupDataCreator = Infrastructure.IContractValidationLookupDataCreator;

    public class CreateContractSaga
    {
        private readonly IContractDeliverableEnricher _contractDeliverableEnricher;

        private readonly IContractRequestTransformer _contractRequestTransformer;

        private readonly IContractValueAggregator _contractValueAggregator;

        private readonly IContractValidationLookupDataCreator _contractValidationLookupDataCreator;

        private readonly ILogger _logger;

        private readonly INumberRequestManager _numberRequestManager;

        private readonly IOrganisationMessageEnricher _organisationMessageEnricher;

        private readonly IValidator _validator;

        private readonly IProcessedMessageRepository _processedMessageRepository;

        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        private readonly int _createContractRequestCommandReceivedEventLoggingId;

        private readonly ISiblingApprovedContractService _siblingApprovedContractService;

        private readonly IRelatedAllocationEnricher _relatedAllocationEnricher;

        public CreateContractSaga(
            IContractDeliverableEnricher contractDeliverableEnricher,
            IContractRequestTransformer contractRequestTransformer,
            IContractValueAggregator contractValueAggregator,
            ILogger logger,
            INumberRequestManager numberRequestManager,
            IOrganisationMessageEnricher organisationMessageEnricher,
            IValidator validator,
            IProcessedMessageRepository processedMessageRepository,
            ISessionConnectionFactory sessionConnectionFactory,
            int createContractRequestCommandReceivedEventLoggingId,
            IContractValidationLookupDataCreator contractValidationLookupDataCreator,
            ISiblingApprovedContractService siblingApprovedContractService,
            IRelatedAllocationEnricher relatedAllocationEnricher)
        {
            _contractDeliverableEnricher = contractDeliverableEnricher;
            _contractRequestTransformer = contractRequestTransformer;
            _contractValueAggregator = contractValueAggregator;
            _logger = logger;            
            _numberRequestManager = numberRequestManager;
            _organisationMessageEnricher = organisationMessageEnricher;
            _validator = validator;
            _processedMessageRepository = processedMessageRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
            _createContractRequestCommandReceivedEventLoggingId = createContractRequestCommandReceivedEventLoggingId;            
            _contractValidationLookupDataCreator = contractValidationLookupDataCreator;
            _siblingApprovedContractService = siblingApprovedContractService;
            _relatedAllocationEnricher = relatedAllocationEnricher;
        }

        public async Task<SagaMethodResult> Handle(
            CreateContractRequestCommand command,
            IMessageHandlerContext context,
            CreateContractSagaData data,
            Func<contractRequestType, ContractValidationLookupData, ConnectionInfo, IEnumerable<IRule<contractRequestType>>> getValidationRules)
        {
            _logger.LogInformation(
                _createContractRequestCommandReceivedEventLoggingId,
                $"CreateContractRequestCommand - Handler started {command}, CorrelationId: {command.ContractRequest.correlationInfo.correlationId}");

            // set non-null ProcessId as NServiceBus will still persist saga data if duplicate message detected, and ProcessId is a unique constraint
            data.ProcessId = GenerateDefaultProcessId();

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            if (_processedMessageRepository.Add(context.MessageId, connectionInfo))
            {
                // the unique identifier of a contract request is the correlationId of the Master Contract
                data.ProcessId = command.ContractRequest.correlationInfo.correlationId;

                _logger.LogInformation(
                    _createContractRequestCommandReceivedEventLoggingId,
                    "{0} received with request id of {1}",
                    command.GetType().Name,
                    data.ProcessId);

                // enrich with the org data
                _organisationMessageEnricher.Enrich(command.ContractRequest);

                // get validation lookup data
                ContractValidationLookupData lookupData = _contractValidationLookupDataCreator.CreateLookupDataAndSetContractPresence(command.ContractRequest, connectionInfo);
                _logger.LogInformation(_createContractRequestCommandReceivedEventLoggingId, "Validation Lookup Data has been populated for {0}", command.ContractRequest.correlationInfo.correlationId);

                IEnumerable<IRule<contractRequestType>> rules = getValidationRules(command.ContractRequest, lookupData, connectionInfo);

                if (_validator.Validate(command.ContractRequest, rules))
                {
                    await ProcessValidContract(command.ContractRequest, context, data);
                    return new SagaMethodResult(false);
                }
               
                await ProcessInvalidContract(command.ContractRequest, context, data);
                return new SagaMethodResult(true);
            }
           
            _logger.LogInformation(
                   _createContractRequestCommandReceivedEventLoggingId,
                   $"CreateContractRequestCommand - Handler we have already processed this: {command}, CorrelationId: {command.ContractRequest.correlationInfo.correlationId}");

            return new SagaMethodResult(true);
        }

        public static async Task Handle(IMessageHandlerContext context, CreateContractSagaData data, ILogger logger)
        {
            logger.LogInformation(ContractCreateDomainEventLoggingId.ContractCreated, "Contract reported as created for request {0}", data.ProcessId);

            contractRequestType contractRequestObject = data.ContractRequestContract.ConvertByteArrayToObject<contractRequestType>();

            if (data.ShouldReply)
            {
                await context.Send(
                    new ContractRequestProcessedCommand
                    {
                        ContractRequest = contractRequestObject
                    });
            }
            else
            {
                await MarkDasContractRequestAsInCrm(contractRequestObject.contract.contracts[0].contractNumber, context, data, logger)
                    .ConfigureAwait(false);
            }            
        }

        private static string GenerateDefaultProcessId()
        {
            return $"DEFAULT-PROCESSID-{Guid.NewGuid()}";
        }

        private async Task ProcessValidContract(contractRequestType contractRequest, IMessageHandlerContext context, CreateContractSagaData data)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.ValidationSuccessful, "Validation successful for request {0}, proceeding", data.ProcessId);

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);
            
            if (data.AddContractAllocationNumbersOnly)
            {
                _numberRequestManager.PopulateContractAllocationNumbers(contractRequest, connectionInfo);
                _logger.LogInformation(ContractCreateDomainEventLoggingId.ContractAllocationNumbersAdded,
                    "Contract Allocation Numbers Only have been added for {0}", contractRequest.correlationInfo.correlationId);
            }
            else
            {
                contractRequest = _numberRequestManager.GetContractNumbers(contractRequest, connectionInfo);
                _logger.LogInformation(ContractCreateDomainEventLoggingId.ContractNumbersAdded,
                    "Contract Numbers have been added for {0}", contractRequest.correlationInfo.correlationId);
            }

            // the corp request on the message has the contract numbers so assign to saga data
            data.ContractRequestContract = contractRequest.ConvertObjectToByteArray();

            // convert the contract request to the corp schema
            ExtendedContractType extendedContractType = _contractRequestTransformer.TransformToCorpContractType(contractRequest);

            // aggregate the contract values from the deliverable periods up the tree to the parent nodes
            _contractValueAggregator.Aggregate(extendedContractType);

            // Enrich the contract with required deliverables
            _contractDeliverableEnricher.Enrich(extendedContractType);

            _logger.LogInformation(ContractCreateDomainEventLoggingId.ContractTransformed, "Contract transformed and enriched for request {0}", data.ProcessId);

            // store the extended contract type on the saga as we will need it later
            data.ExtendedContractType = extendedContractType.ConvertObjectToByteArray();

            // Doc Gen requires the child contract, not the master  
            // store Master contract contract number as required in the generate docs' mergefield
            string masterContractNumber = extendedContractType.contractNumber;
            extendedContractType = extendedContractType.contracts.First();
            extendedContractType.contractAllocations.ForEach(a =>
            {
                a.HasBeenAdded = true;
                a.HasBeenAddedOrUpdated = true;
            });  

            // Doc Gen requires a contract type not an ExtendedContractType so transform it
            Contract corpContract = _contractRequestTransformer.TransformToCorpContract(extendedContractType);
            corpContract.IsNewRevisedNewOrUpdateDraft = contractRequest.IsNewRevisedNewOrUpdateDraft();
            corpContract.IsNewAmendment = contractRequest.IsNewAmendment();
            IReadOnlyCollection<ApprovedContractInfo> siblingApprovedContractsForDocumentGeneration =
                await _siblingApprovedContractService.GetSiblingApprovedContractsForDocumentGeneration(
                    masterContractNumber,
                    corpContract.fundingType.fundingTypeCode,
                    corpContract.GetFundingPeriod(),
                    connectionInfo).ConfigureAwait(false);

            corpContract.SharedMasterApprovedContracts = siblingApprovedContractsForDocumentGeneration.ToList();
            corpContract.SharedMasterApprovedContracts.ForEach(_relatedAllocationEnricher.EnrichWithRelatedAllocationsWhenAppropriate);
            
            await _relatedAllocationEnricher.EnrichWithRelatedAllocationsWhenAppropriate(corpContract, connectionInfo);

            SendOptions sendOptions = new SendOptions();
            sendOptions.RouteReplyTo("ContractCreateDomain.CreateContractInternal");
            // now publish to Doc Gen and get the reply to go back to the internal queue rather than the public queue
            await context.Send(
                new DocumentGenerationCommand
                {
                    CorrelationId = data.ProcessId,
                    CorporateContract = corpContract,
                    MasterContractNumber = masterContractNumber
                },
                sendOptions).ConfigureAwait(false);
        }

        private async Task ProcessInvalidContract(contractRequestType contractRequest, IMessageHandlerContext context, CreateContractSagaData data)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.ValidationFailed, "Validation has failed for request {0} with errors: {1}",
                data.ProcessId, string.Join(", ", contractRequest.errorInfo.Select(e => e.Value)));

            if (data.ShouldReply)
            {
                await context.Send(new ContractRequestProcessedCommand
                {
                    ContractRequest = contractRequest
                });
            }
            else if (IsOrganisationNull(contractRequest.contract.contractor))
            {
                await MarkDasContractRequestAsProviderNotFound(context, data.DasEngagementEventId)
                    .ConfigureAwait(false);
            }
            else
            {
                await MarkDasContractRequestAsRejected(context, data.DasEngagementEventId)
                    .ConfigureAwait(false);
            }
        }

        private bool IsOrganisationNull(SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.Contractor organisation)
        {
            return string.IsNullOrEmpty(organisation.organisationIdentifier);
        }

        protected static async Task MarkDasContractRequestAsInCrm(string contractNumber, IMessageHandlerContext context, CreateContractSagaData data, ILogger logger)
        {
            logger.LogInformation(ContractCreateDomainEventLoggingId.DasRequestNowInCrm, $"Contract Created in Crm for Das - {contractNumber}");
            if (data.DasEngagementEventId != null)
            {
                DasContractRequestCreatedEvent createdEvent = new DasContractRequestCreatedEvent
                {
                    DasEngagementEventId = data.DasEngagementEventId.Value,
                    ContractNumber = contractNumber
                };

                await context.Publish(createdEvent).ConfigureAwait(false);
            }
            else
            {
                logger.LogError(ContractCreateDomainEventLoggingId.DasRequestReplyMissingEventId, "Attempted to reply to DAS request where Saga data has no EventID");
            }
        }

        protected async Task MarkDasContractRequestAsRejected(IMessageHandlerContext context, long? dasEngagementEventId)
        {
            if (dasEngagementEventId.HasValue)
            {
                _logger.LogInformation(ContractCreateDomainEventLoggingId.DasRequestRejectedByRule, $"Das Contract Request rejected by rule - {dasEngagementEventId.Value}");
                DasContractRequestRejectedEvent rejectedEvent = new DasContractRequestRejectedEvent
                {
                    DasEngagementEventId = dasEngagementEventId.Value
                };

                await context.Publish(rejectedEvent)
                    .ConfigureAwait(false);
            }
            else
            {
                _logger.LogError(ContractCreateDomainEventLoggingId.DasRequestReplyMissingEventId, "Attempted to reply to DAS request where Saga data has no EventID");
            }
        }

        protected async Task MarkDasContractRequestAsProviderNotFound(IMessageHandlerContext context, long? dasEngagementEventId)
        {
            if (dasEngagementEventId.HasValue)
            {
                DasContractRequestProviderNotFoundEvent notFoundEvent = new DasContractRequestProviderNotFoundEvent
                {
                    DasEngagementEventId = dasEngagementEventId.Value
                };

                _logger.LogInformation(ContractCreateDomainEventLoggingId.DasRequestProviderNotFound, $"A provider could not be found for Das Contract Request - {dasEngagementEventId.Value}");
                await context.Publish(notFoundEvent)
                    .ConfigureAwait(false);
            }
            else
            {
                _logger.LogError(ContractCreateDomainEventLoggingId.DasRequestReplyMissingEventId, "Attempted to reply to DAS request where Saga data has no EventID");
            }
        }
    }
}
