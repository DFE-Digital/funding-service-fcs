namespace ContractManagementDomain.Endpoint.ContractApproved.Services
{
    using System;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Exceptions;
    using ContractManagement.DataStore.Model;
    using Repositories;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ApprovedContractAtomFeedItemCreationService : IApprovedContractAtomFeedItemCreationService
    {
        private readonly ILogger _logger;
        private readonly IApprovedContractAtomItemRepository _approvedContractAtomItemRepository;
        private readonly IContractTransformer _contractTransformer;
        private readonly IContractXmlValidator _contractXmlValidator;

        public ApprovedContractAtomFeedItemCreationService(
            ILogger logger,
            IApprovedContractAtomItemRepository approvedContractAtomItemRepository,
            IContractTransformer contractTransformer,
            IContractXmlValidator contractXmlValidator)
        {
            _logger = logger;
            _approvedContractAtomItemRepository = approvedContractAtomItemRepository;
            _contractTransformer = contractTransformer;
            _contractXmlValidator = contractXmlValidator;
        }

        public async Task<AtomItemCreationResult> AddApprovedContract(Contract corporateContract, Guid feedItemId, ConnectionInfo connectionInfo)
        {
            _logger.LogInformation(
             ContractManagementLoggingEvents.CMApprovedEventReceivedForPagedStorage,
             $"Approved Contract {corporateContract.contractNumber}, version {corporateContract.contractVersionNumber} received for storage");

            SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.Contract corpSchemaContract =
                _contractTransformer.TransformToCorporateSchemaContract(corporateContract);

            try
            {
                await _approvedContractAtomItemRepository.Add(
                    AtomFeedItem.CreateAtomFeedItem(
                        corpSchemaContract, 
                        corpSchemaContract.GetFirstContractNumber(), 
                        AtomItemType.ApprovedContract,
                        feedItemId,
                        IsValidXml),
                    connectionInfo).ConfigureAwait(false);

                return AtomItemCreationResult.Added;
            }
            catch (SqlDuplicateKeyStorageException)
            {
                Guid? existingEntityId = await _approvedContractAtomItemRepository.GetIdentifierForBusinessKey(
                    corpSchemaContract.GetFirstContractNumber(),
                    AtomItemType.ApprovedContract,
                    connectionInfo).ConfigureAwait(false);

                if (existingEntityId == feedItemId)
                {
                    _logger.LogError(
                        ContractManagementLoggingEvents.CMApprovedEventReceivedForPagedStorage,
                        $"Approved Contract {corporateContract.contractNumber}, version {corporateContract.contractVersionNumber} event threw duplicate key storage exception." +
                        $" The AtomFeedItem was already written previously for Feed Item Id {feedItemId} so it is not a problem");

                    return AtomItemCreationResult.AlreadyPresentWithSameFeedItemId;
                }

                _logger.LogError(
                    ContractManagementLoggingEvents.CMApprovedEventReceivedForPagedStorage,
                    $"Approved Contract {corporateContract.contractNumber}, version {corporateContract.contractVersionNumber} event threw duplicate key storage exception");

                return AtomItemCreationResult.AlreadyPresent;
            }
        }

        private bool IsValidXml(string xml)
        {
            bool isValidXml = _contractXmlValidator.IsValid(xml);
            
            if (!isValidXml)
            {
                _logger.LogError(ContractManagementLoggingEvents.ContractXmlInvalidAgainstCorporateSchema, $"Invalid XML: {xml}");
            }
            
            return isValidXml;
        }
    }
}