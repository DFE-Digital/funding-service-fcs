namespace ContractManagementDomain.Endpoint.ReleaseForReview
{
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ReleaseForReviewHandler : IHandleMessages<ReleaseForReviewCommand>
    {
        private readonly ILogger _logger;
        private readonly IContractsManager _contractManager;

        public ReleaseForReviewHandler(ILogger logger, IContractsManager contractsManager)
        {
            _logger = logger;
            _contractManager = contractsManager;
        }

        public async Task Handle(ReleaseForReviewCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.ReleaseForReviewCommandReceived, $"ReleaseForReviewCommand received for: {message}");

            contract corporateContract = _contractManager.GetCorporateContract(
                contractNumber: message.ContractNumber,
                masterContractNumber: message.MasterContractNumber,
                lastApproved: false);

            DocumentMergeCommand documentMergeCommand = new DocumentMergeCommand
            {
                CorporateContract = corporateContract,
                ContractNumberToBeMerged = message.ContractNumber
            };

            await context.Send(documentMergeCommand)
                .ConfigureAwait(false);

            _logger.LogInformation(ContractManagementLoggingEvents.DocumentMergeCommandSent, $"DocumentMergeCommand sent for: {message}");
        }
    }
}
