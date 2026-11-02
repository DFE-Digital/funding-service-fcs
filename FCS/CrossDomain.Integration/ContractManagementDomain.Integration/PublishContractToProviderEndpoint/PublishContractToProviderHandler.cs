namespace SFA.FCT.ContractManagementDomain.Integration.PublishContractToProviderEndpoint
{
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using ContractManagementService.Common;
    using ContractManagementService.Common.Services;
    using CrossDomain.Integration.Common.Exceptions;
    using CrossDomain.Integration.Common.PagedStorage.Exceptions;
    using CrossDomain.Integration.Events;
    using Extensions;
    using Framework.Logging.Interfaces;
    using Infrastructure;
    using NServiceBus;

    public class PublishContractToProviderHandler : IHandleMessages<ContractReadyToPublishEvent>
    {
        private readonly ILogger _logger;
        private readonly IDraftContractAtomItemRepository _draftContractRepository;
        private readonly IContractTransformer _contractTransformer;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public PublishContractToProviderHandler(
            ILogger logger,
            IDraftContractAtomItemRepository draftContractRepository,
            IContractTransformer contractTransformer,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _draftContractRepository = draftContractRepository;
            _contractTransformer = contractTransformer;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(ContractReadyToPublishEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
               ContractManagementLoggingEvents.PublishContractToProviderEventStart,
               $"{nameof(ContractReadyToPublishEvent)} - START ");

            try
            {
                string errorMessage;

                RaiseExceptionOnError(!ContractValidator.ValidateMasterAndChildContracts(message.CorporateContract, out errorMessage), errorMessage);

                var corporateContract = message.CorporateContract;
                var contractToPublish = corporateContract.contracts.First();

                RaiseExceptionOnError(!ContractValidator.ValidateMasterAndChildContractNumber(corporateContract.contractNumber, contractToPublish.contractNumber, out errorMessage), errorMessage);

                RaiseExceptionOnError(!ContractValidator.ValidateContractStatus(corporateContract, out errorMessage), errorMessage);

                _logger.LogInformation(
                    ContractManagementLoggingEvents.PublishContractToProviderEventReceived,
                    $"{nameof(ContractReadyToPublishEvent)} to publish to atom feed received for Master Contract Number: {corporateContract.contractNumber} Contract Number:{contractToPublish.contractNumber}");
                
                var connection = _sessionConnectionFactory.GetConnection(context);

                var corpSchemaContract = _contractTransformer.TransformToCorporateSchemaContract(corporateContract);

                _draftContractRepository.Add(AtomFeedItem.CreateAtomFeedItem(corpSchemaContract,
                    corpSchemaContract.GetFirstContractNumber(), AtomItemType.DraftContract, CorporateSchemaContractValidator.IsContractXmlValid), connection);

                await context.Publish(message.CorporateContract.ToContractPublishedEvent());

                _logger.LogInformation(
                ContractManagementLoggingEvents.PublishContractToProviderEventCompleted,
                $"{nameof(ContractReadyToPublishEvent)} to publish to atom feed completed for Master Contract Number: {corporateContract.contractNumber} Contract Number:{contractToPublish.contractNumber}");

            }
            catch (ContractValidationException contractValidationException)
            {

                _logger.LogError(
                    ContractManagementLoggingEvents.PublishContractToProviderFailed,
                    contractValidationException, $"Publish contract failed. Validation on master and/or child contract failed");
            }
            catch (DuplicateKeyStorageException)
            {
                _logger.LogError(
                    ContractManagementLoggingEvents.PublishContractToProviderFailed,
                    $"Published to provider Contract {message.CorporateContract.contractNumber}, version {message.CorporateContract.contracts.First().contractVersionNumber} event threw duplicate key storage exception");
            }

            _logger.LogInformation(
             ContractManagementLoggingEvents.PublishContractToProviderEventStart,
             $"{nameof(ContractReadyToPublishEvent)} - END");

        }
        private void RaiseExceptionOnError(bool error, string errorMessage)
        {
            if (error)
            {
                throw new ContractValidationException(errorMessage);
            }

        }
    }
}
