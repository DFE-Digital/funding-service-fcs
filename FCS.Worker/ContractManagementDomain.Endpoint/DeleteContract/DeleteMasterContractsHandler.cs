namespace ContractManagementDomain.Endpoint.DeleteContract
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class DeleteMasterContractsHandler : IHandleMessages<DeleteMasterContractsCommand>
    {
        private readonly ILogger _logger;
        private readonly ICrmContractRepository _crmContractRepository;

        public DeleteMasterContractsHandler(ILogger logger, ICrmContractRepository crmContractRepository)
        {
            _logger = logger;
            _crmContractRepository = crmContractRepository;
        }


        public Task Handle(DeleteMasterContractsCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.DeleteMasterContractsCommandReceived,
                $"DeleteContractCommand received for - {message}");

            _crmContractRepository.DeleteContractsTasksAndWorkflows(message.MasterContractIds);
           
            _logger.LogInformation(ContractManagementLoggingEvents.DeleteMasterContractsCommandProcessed,
                $"DeleteContractCommand completed for - {message}");

            return Task.CompletedTask;
        }
    }
}
