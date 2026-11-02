namespace SFA.FCT.ContractManagementDomain.Integration.PublishContractWithdrawalEndpoint
{
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using ContractManagementService.Common;
    using ContractManagementService.Common.Commands;
    using CrossDomain.Integration.Common.PagedStorage.Exceptions;
    using CrossDomain.Integration.Events;
    using Framework.Logging.Interfaces;
    using Infrastructure;
    using NServiceBus;

    public class PublishContractWithdrawalHandler : IHandleMessages<ContractWithdrawnEvent>
    {
        private readonly ILogger _logger;
        private readonly IWithdrawnContractAtomItemRepository _withdrawalContractRepository;
        private readonly IContractTransformer _contractTransformer;
        private readonly IContractXmlValidator _contractXmlValidator;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public PublishContractWithdrawalHandler(
            ILogger logger,
            IWithdrawnContractAtomItemRepository withdrawalContractRepository,
            IContractTransformer contractTransformer,
            IContractXmlValidator contractXmlValidator, 
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _withdrawalContractRepository = withdrawalContractRepository;
            _contractTransformer = contractTransformer;
            _contractXmlValidator = contractXmlValidator;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(ContractWithdrawnEvent message, IMessageHandlerContext context)
        {
            var contract = message.CorporateContract.contracts.Single();

            _logger.LogInformation(
             ContractManagementLoggingEvents.PublishContractReadyToWithdrawEventReceived,
             "ContractWithdrawnEvent received by PublishContractWithdrawalHandler " +
             $"(for publishing to atom feed) for Contract Number:{contract.contractNumber}, " +
             $"Version:{contract.contractVersionNumber}");

            var corporateContract = message.CorporateContract;
            var corpSchemaContract = _contractTransformer.TransformToCorporateSchemaContract(corporateContract);

            var connection = _sessionConnectionFactory.GetConnection(context);

            try
            {
                _withdrawalContractRepository.Add(AtomFeedItem.CreateAtomFeedItem(corpSchemaContract,
                    corpSchemaContract.GetFirstContractNumber(), AtomItemType.WithdrawnContract, _contractXmlValidator.IsValid), connection);

                if (message.IncrementContractVersionNumber)
                {
                    var incrementContractVersionCommand = new IncrementContractVersionCommand
                    {
                        ContractNumber = contract.contractNumber,
                        VersionNumber = contract.contractVersionNumber,
                        SubVersionNumber = contract.contractSubVersionNumber,
                        AmendmentType = ContractManagementService.Common.AmendmentType.Variation,
                        IsNonFinancialAmendment = false,
                        ShouldAddPayableNonLevyAllocation = message.ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment,
                        ShouldMergeAmendmentTemplate = message.ShouldMergeAmendmentTemplate,
                        OverrideAmendmentTemplate = message.OverrideAmendmentTemplate,
                        OverrideTemplateName = message.OverrideTemplateName
                    };

                    await context.Send(incrementContractVersionCommand);
                }

                _logger.LogInformation(
                ContractManagementLoggingEvents.PublishContractReadyToWithdrawEventCompleted,
                $"PublishContractWithdrawalHandler successful for Contract Number:{contract.contractNumber}, " +
                $"Version:{contract.contractVersionNumber}");
            }
            catch (DuplicateKeyStorageException e)
            {
                _logger.LogError(
                    ContractManagementLoggingEvents.PublishContractReadyToWithdrawEventFailed,
                    e,
                    $"PublishContractWithdrawalHandler failed for Contract Number:{contract.contractNumber}, " +
                    $"Version:{contract.contractVersionNumber}");
            }
        }
    }
}
