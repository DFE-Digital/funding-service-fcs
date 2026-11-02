namespace ContractCreateDomain.Endpoint.XrmService
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Events;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CreateContractHandler : IHandleMessages<CreateContractCommand>
    {
        private readonly ILogger _logger;

        private readonly IContractsManager _contractsManager;

        private readonly IProcessedMessageRepository _processedMessageRepository;

        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        private readonly IContractDeDuplicationService _contractDeDuplicationService;

        public CreateContractHandler(
            ILogger logger,
            IContractsManager contractsManager,
            IProcessedMessageRepository processedMessageRepository,
            ISessionConnectionFactory sessionConnectionFactory, IContractDeDuplicationService contractDeDuplicationService)
        {
            _logger = logger;
            _contractsManager = contractsManager;
            _processedMessageRepository = processedMessageRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
            _contractDeDuplicationService = contractDeDuplicationService;
        }

        public async Task Handle(CreateContractCommand message, IMessageHandlerContext context)
        {
            var connectionInfo = _sessionConnectionFactory.GetConnection(context);
            _logger.LogInformation(1, $"Attempting to create contract message:{message}, id: {context.MessageId}");
            if (_processedMessageRepository.Add(context.MessageId, connectionInfo))
            {
                _logger.LogInformation(ContractCreateDomainEventLoggingId.AttemptingToCreateInCRM, "Attempting to create contract {0} in CRM for {1}", message.CorporateContract, message.CorrelationId);
                try
                {
                    // set the batchId so that lookup data can be cached against this batch then used again for subsequent calls for the same batch
                    _contractsManager.BatchId = message.BatchId;
                    Guid crmMasterContractId = _contractsManager.CreateContract(
                        message.CorporateContract, 
                        message.CorrelationId, 
                        getExistingContractId:_contractDeDuplicationService.GetExistingContractId,
                        insertAllocationIfNotPresent:_contractDeDuplicationService.InsertAllocationWithoutDuplication);
                    if (crmMasterContractId != Guid.Empty)
                    {
                        _logger.LogInformation(ContractCreateDomainEventLoggingId.ContractCreatedInCRM, "Created Contract {0} for {1} in CRM and replying to caller", message.CorporateContract, message.CorrelationId);

                        await context.Reply(new NewContractCreated
                        {
                            CorrelationId = message.CorrelationId,
                            CrmMasterContractId = crmMasterContractId,
                            ChildContractNumber = message.CorporateContract.contracts.Single().contractNumber,
                            ChildContractVersionNumber = message.CorporateContract.contracts.Single().contractVersionNumber,
                            ChildContractSubVersionNumber = message.CorporateContract.contracts.Single().contractSubVersionNumber
                        }).ConfigureAwait(false);

                        await context.Publish(new ContractCreatedInCrmEvent
                        {
                            ContractNumber = message.CorporateContract.contracts.Single().contractNumber,
                            ContractVersionNumber = message.CorporateContract.contracts.Single().contractVersionNumber,
                            ContractSubVersionNumber = message.CorporateContract.contracts.Single().contractSubVersionNumber
                        }).ConfigureAwait(false);
                    }
                    else
                    {
                        _logger.LogInformation(ContractCreateDomainEventLoggingId.ContractAlreadyCreatedInCRM, "Already Created Contract {0} for {1} in CRM", message.CorporateContract, message.CorrelationId);
                    }
                }
                catch (Exception)
                {
                    _logger.LogInformation(ContractCreateDomainEventLoggingId.ContractCreateException, "Exception thrown while attempting to create contract {0} in CRM for {1}, exception follows", message.CorporateContract, message.CorrelationId);
                    throw;
                }
            }
            else
            {
                _logger.LogInformation(ContractCreateDomainEventLoggingId.ContractCreateException, "We have already processed this message {0} in CRM for {1}", message.CorporateContract, message.CorrelationId);
            }
        }
    }
}
