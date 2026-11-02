namespace ContractManagementDomain.Termination.Xrm
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ContractTerminationFailedHandler : IHandleMessages<ContractTerminationFailedEvent>
    {
        private readonly ILogger _logger;
        private readonly ICrmContractRepository _crmContractRepository;

        public ContractTerminationFailedHandler(
            ILogger logger,
            ICrmContractRepository crmContractRepository)
        {
            _logger = logger;
            _crmContractRepository = crmContractRepository;
        }

        public async Task Handle(ContractTerminationFailedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                ContractManagementLoggingEvents.ContractTerminationFailedReceived,
                $"START: ContractTerminationFailedEvent for {message} received");

            _crmContractRepository.UpdateServiceResponseOnContract(
                message.ContractNumber,
                message.VersionNumber,
                message.SubVersionNumber,
                sfa_serviceresponse.ContractTerminationFailed);

            await context.Send(new IssueCrmNotificationCommand
            {
                ContractNumber = message.ContractNumber,

                VersionNumber = message.VersionNumber,
                SubVersionNumber = message.SubVersionNumber,
                NotificationText = message.FailureReason,
                NotificationType = NotificationType.ContractTerminationFailed
            }).ConfigureAwait(continueOnCapturedContext: false);

            _logger.LogInformation(
                ContractManagementLoggingEvents.ContractTerminationFailedProcessed,
                $"END: ContractTerminationFailedEvent for {message} received");
        }
    }
}
