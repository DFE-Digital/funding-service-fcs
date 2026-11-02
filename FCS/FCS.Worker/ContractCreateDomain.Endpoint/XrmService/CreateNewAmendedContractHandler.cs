namespace ContractCreateDomain.Endpoint.XrmService
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Events;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CreateNewAmendedContractHandler : IHandleMessages<CreateNewAmendedContractCommand>
    {
        private readonly ILogger _logger;

        private readonly IContractsManager _contractsManager;

        private readonly IProcessedMessageRepository _processedMessageRepository;

        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public CreateNewAmendedContractHandler(
            ILogger logger,
            IContractsManager contractsManager,
            IProcessedMessageRepository processedMessageRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _contractsManager = contractsManager;
            _processedMessageRepository = processedMessageRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(CreateNewAmendedContractCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.AttemptingToCreateANewAmendmentForAContract, "Attempting to Amend a New contract {0} in CRM for {1}", message.CorporateContract, message.CorrelationId);

            var connectionInfo = _sessionConnectionFactory.GetConnection(context);
            if (_processedMessageRepository.Add(context.MessageId, connectionInfo))
            {
                try
                {
                    _contractsManager.BatchId = message.BatchId;
                    _contractsManager.CreateNewAmendedContract(message.CorporateContract, message.CorrelationId);
                    _logger.LogInformation(ContractCreateDomainEventLoggingId.ContractCreatedInCRM,
                        "New Amendment Contract Created {0} for {1} in CRM and replying to caller",
                        message.CorporateContract, message.CorrelationId);

                    ExtendedContractType childContract = message.CorporateContract.contracts.Single();
               
                    await context.Reply(new NewContractCreated
                    {
                        CorrelationId = message.CorrelationId,
                        ChildContractNumber = childContract.contractNumber,
                        ChildContractVersionNumber = childContract.contractVersionNumber,
                        ChildContractSubVersionNumber = childContract.contractSubVersionNumber
                    });

                    await context.Publish(new ContractCreatedInCrmEvent
                    {
                        ContractNumber = childContract.contractNumber,
                        ContractVersionNumber = childContract.contractVersionNumber,
                        ContractSubVersionNumber = childContract.contractSubVersionNumber
                    }).ConfigureAwait(false);
                }
                catch (Exception)
                {
                    _logger.LogInformation(ContractCreateDomainEventLoggingId.ContractCreateException,
                        "Exception thrown while attempting to Amendment a New contract {0} in CRM for {1}, exception follows",
                        message.CorporateContract, message.CorrelationId);
                    throw;
                }
            }
            else
            {
                _logger.LogInformation(ContractCreateDomainEventLoggingId.NewAmendmentDuplicate, "We have already processed this message {0} in CRM for {1}", message.CorporateContract, message.CorrelationId);
            }
        }
    }
}
