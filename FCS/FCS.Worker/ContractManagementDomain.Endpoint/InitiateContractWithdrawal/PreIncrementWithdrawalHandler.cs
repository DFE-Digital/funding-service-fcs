namespace ContractManagementDomain.Endpoint.InitiateContractWithdrawal
{
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractWithdrawal;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class PreIncrementWithdrawalHandler : IHandleMessages<PreIncrementWithdrawalCommand>
    {
        private readonly ILogger _logger;

        public PreIncrementWithdrawalHandler(ILogger logger)
        {
            _logger = logger;
        }

        public async Task Handle(PreIncrementWithdrawalCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.PreIncrementWithdrawalCommandReceived,
                $"PreIncrementWithdrawalCommand received for - {message}");

            InitiateContractWithdrawalCommand initiateContractWithdrawalCommand = new InitiateContractWithdrawalCommand
            {
                ContractVersionNumber = message.VersionNumber,
                ContractNumber = message.ContractNumber,
                MasterContractNumber = message.MasterContractNumber,
                ContractWithdrawalType = ContractWithdrawalType.BulkWithdrawalByAgency,
                RequestSource = WithdrawalRequestSource.Fcs,
                IncrementContractVersionNumber = true,
                ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment = message.ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment,
                Ukprn = message.Ukprn,
                ShouldMergeAmendmentTemplate = message.ShouldMergeAmendmentTemplate,
                OverrideTemplateName = message.OverrideTemplateName,
                OverrideAmendmentTemplate = message.OverrideAmendmentTemplate
            };

            await context.Send(initiateContractWithdrawalCommand)
                .ConfigureAwait(false);

            _logger.LogInformation(ContractManagementLoggingEvents.PreIncrementWithdrawalCommandCompleted,
                $"PreIncrementWithdrawalCommand completed for - {message}");
        }
    }
}
