namespace ContractManagementDomain.Termination.Xrm
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ContractTerminationCancelledHandler : IHandleMessages<ContractTerminationCancelledEvent>
    {
        private readonly ILogger _logger;
        private readonly ICrmContractRepository _crmContractRepository;

        public ContractTerminationCancelledHandler(ILogger logger, ICrmContractRepository crmContractRepository)
        {
            _logger = logger;
            _crmContractRepository = crmContractRepository;
        }

        public Task Handle(ContractTerminationCancelledEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                ContractManagementLoggingEvents.ContractTerminationCancelledEventReceived,
                $"START: ContractTerminationCancelledEvent for {message} received");

            _crmContractRepository.UpdateServiceResponseOnContract(
                contractNumber: message.ContractNumber,
                version: message.VersionNumber,
                subVersion: message.SubVersionNumber,
                serviceresponse: sfa_serviceresponse.TerminationCancellationSuccessful);

            _logger.LogInformation(
                ContractManagementLoggingEvents.ContractTerminationCancelledEventProcessed,
                $"END: ContractTerminationCancelledEvent for {message} processed");

            return Task.FromResult(0);
        }
    }
}
