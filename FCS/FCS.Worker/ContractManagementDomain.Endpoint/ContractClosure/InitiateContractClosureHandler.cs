namespace ContractManagementDomain.Endpoint.ContractClosure
{
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class InitiateContractClosureHandler : IHandleMessages<InitiateContractClosureCommand>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IValidationService _validationService;
        private readonly ICrmContractRepository _crmContractRepository;

        public InitiateContractClosureHandler(
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory,
            IValidationService validationService,
            ICrmContractRepository crmContractRepository)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _validationService = validationService;
            _crmContractRepository = crmContractRepository;
        }

        public async Task Handle(InitiateContractClosureCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.ContractClosureCommandReceived, $"InitiateContractClosureCommand handler started - {message}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            string failureMessage =
                _validationService.GetFirstFailureMessageForInitiateContractClosure(
                    new ContractIdentifier(message.ContractNumber, message.VersionNumber, message.SubVersionNumber),
                    connectionInfo);

            if (failureMessage != null)
            {
                _crmContractRepository.UpdateServiceResponseOnContract(message.ContractNumber, message.VersionNumber, message.SubVersionNumber, sfa_serviceresponse.ClosureInitiationFailed);

                await context.Send(new IssueCrmNotificationCommand
                {
                    ContractNumber = message.ContractNumber,
                    VersionNumber = message.VersionNumber,
                    SubVersionNumber = message.SubVersionNumber,
                    NotificationText = failureMessage,
                    NotificationType = NotificationType.InitiateContractClosureFailed
                }).ConfigureAwait(false);
            }
            else
            {
                _crmContractRepository.UpdateServiceResponseOnContract(message.ContractNumber, message.VersionNumber, message.SubVersionNumber, sfa_serviceresponse.ClosureInitiationSuccessful);
            }

            _logger.LogInformation(ContractManagementLoggingEvents.ContractClosureCommandCompleted, $"InitiateContractClosureCommand handler ended - {message}");
        }
    }
}
