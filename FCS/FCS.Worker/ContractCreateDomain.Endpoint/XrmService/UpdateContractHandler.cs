namespace ContractCreateDomain.Endpoint.XrmService
{
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Events;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.ContractCreateDomain.Implementation.Exceptions;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class UpdateContractHandler : IHandleMessages<UpdateContractCommand>
    {
        private readonly ILogger _logger;

        private readonly IContractsManager _contractsManager;

        private readonly IProcessedMessageRepository _processedMessageRepository;

        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        private readonly IContractDeDuplicationService _contractDeDuplicationService;

        public UpdateContractHandler(
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

        public async Task Handle(UpdateContractCommand command, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.UpdatingContractInCrm, "Updating contract {0} for {1} in CRM", command.Contract, command.CorrelationId);

            var connectionInfo = _sessionConnectionFactory.GetConnection(context);
            if (_processedMessageRepository.Add(context.MessageId, connectionInfo))
            {
                try
                {
                    _contractsManager.BatchId = command.BatchId;
                    _contractsManager.UpdateAmendedContract(
                        command.Contract,
                        command.CorrelationId, 
                        insertAllocationIfNotPresent: _contractDeDuplicationService.InsertAllocationWithoutDuplication,
                        getExistingContractId:_contractDeDuplicationService.GetExistingContractId);

                    var childContract = command.Contract.contracts[0];

                    await context.Reply(new ContractAmended
                    {
                        ProcessId = command.CorrelationId,
                        ContractNumber = childContract.contractNumber,
                        ContractVersionNumber = childContract.contractVersionNumber,
                        ContractSubVersionNumber = childContract.contractSubVersionNumber,
                        MasterContractNumber = command.Contract.contractNumber,
                        Ukprn = childContract.contractor.ukprn,
                        AmendmentType = childContract.amendmentType
                    });

                    await context.Publish(new ContractCreatedInCrmEvent
                    {
                        ContractNumber = childContract.contractNumber,
                        ContractVersionNumber = childContract.contractVersionNumber,
                        ContractSubVersionNumber = childContract.contractSubVersionNumber,
                        AmendmentType = childContract.amendmentType
                    }).ConfigureAwait(false);

                    _logger.LogInformation(ContractCreateDomainEventLoggingId.UpdatedContractInCrm,
                        "Updated contract {0} for {1} in CRM", command.Contract, command.CorrelationId);
                }
                catch (ContractDoesntExistException ex)
                {
                    await context.Reply(new AmendContractUnsuccessful
                    {
                        Error = new errorInfoType()
                        {
                            correlationId = command.CorrelationId,
                            level = errorInfoTypeLevel.Contract,
                            Value = "Contract was not present in Dynamics CRM"
                        }
                    });
                    _logger.LogError(ContractCreateDomainEventLoggingId.AmendmentFailed,
                        "Failed to update contract {0} for {1} in CRM: {2}", command.Contract, command.CorrelationId,
                        ex.Message);
                }
            }
            else
            {
                _logger.LogInformation(ContractCreateDomainEventLoggingId.UpdateDuplicate, "We have already processed this message {0} in CRM for {1}", command.Contract, command.CorrelationId);
            }
        }
    }
}
