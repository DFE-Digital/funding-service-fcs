namespace ContractCreateDomain.Endpoint.NonFinancialAmendment
{
    using NServiceBus;
    using System.Threading.Tasks;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Infrastructure;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using Services;

    public class AmendContractNonFinancialAmendmentHandler : IHandleMessages<AmendContractNonFinancialAmendmentCommand>
    {
        private readonly INonFinancialAmendmentValidationService _nonFinancialAmendmentValidationService;
        private readonly ICrmContractRepository _contractRepository;
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public AmendContractNonFinancialAmendmentHandler(INonFinancialAmendmentValidationService nonFinancialAmendmentValidationService, 
            ICrmContractRepository contractRepository, ILogger logger, ISessionConnectionFactory sessionConnectionFactory)
        {
            _nonFinancialAmendmentValidationService = nonFinancialAmendmentValidationService;
            _contractRepository = contractRepository;
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(AmendContractNonFinancialAmendmentCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation($"AmendContractNonFinancialAmendmentHandler started - {message}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            string validationResultText =
                _nonFinancialAmendmentValidationService.IsValid(new ContractIdentifier(message.ContractNumber,
                    message.VersionNumber, message.SubVersionNumber), connectionInfo);

            if (validationResultText == null)
            {
                IncrementContractVersionCommand incrementCommand = new IncrementContractVersionCommand
                {
                    ContractNumber = message.ContractNumber,
                    VersionNumber = message.VersionNumber,
                    SubVersionNumber = message.SubVersionNumber,
                    AmendmentType = message.AmendmentType,
                    IsNonFinancialAmendment = message.IsNonFinancialAmendment
                };
                await context.Send(incrementCommand);
            }
            else
            {
                _contractRepository.SetNonFinancialAmendmentFailedServiceResponseOnContract(
                    message.ContractNumber,
                    message.VersionNumber,
                    message.SubVersionNumber);

                IssueCrmNotificationCommand crmNotificationCommand = new IssueCrmNotificationCommand
                {
                    ContractNumber = message.ContractNumber,
                    VersionNumber = message.VersionNumber,
                    SubVersionNumber = message.SubVersionNumber,
                    NotificationText = validationResultText,
                    NotificationType =
                        message.AmendmentType == AmendmentType.Notification
                            ? NotificationType.ContractAmendmentNotificationNonFinancialAmendmentFailed
                            : NotificationType.ContractAmendmentVariationNonFinancialAmendmentFailed
                };
                await context.Send(crmNotificationCommand);
            }

            _logger.LogInformation($"AmendContractNonFinancialAmendmentHandler completed - {message}");
        }
    }
}