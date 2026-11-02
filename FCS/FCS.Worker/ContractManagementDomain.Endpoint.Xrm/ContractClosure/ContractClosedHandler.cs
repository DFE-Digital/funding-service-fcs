namespace ContractManagementDomain.Endpoint.Xrm.ContractClosure
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ContractClosedHandler : IHandleMessages<ContractClosedEvent>
    {
        private readonly ILogger _logger;
        private readonly IContractClosureService _contractClosureService;

        public ContractClosedHandler(ILogger logger, IContractClosureService contractClosureService)
        {
            _logger = logger;
            _contractClosureService = contractClosureService;
        }

        public Task Handle(ContractClosedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.ContractClosedEventReceived,
                $"ContractClosedEvent received for Contract: {message.ContractNumber} v{message.VersionNumber}.{message.SubVersionNumber}");

            _logger.LogInformation(ContractManagementLoggingEvents.ClosingContractInCrm,
                $"Closing contract in CRM: {message.ContractNumber} v{message.VersionNumber}.{message.SubVersionNumber}");

            _contractClosureService.CloseContractInCrm(
                message.ContractNumber,
                message.VersionNumber,
                message.SubVersionNumber,
                message.ClosureDate,
                message.IsContractOpenEnded);

            _logger.LogInformation(ContractManagementLoggingEvents.ContractClosedEventCompleted,
                $"ContractClosedEvent completed for Contract: {message.ContractNumber} v{message.VersionNumber}.{message.SubVersionNumber}");

            return Task.CompletedTask;
        }
    }
}
