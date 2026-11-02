namespace ContractManagementDomain.Termination.Services
{
    using System;
    using ContractManagement.DataStore.Exceptions;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ApprovalOnwardsContractAtomFeedService : IApprovalOnwardsContractAtomFeedService
    {
        private readonly ILogger _logger;
        private readonly IApprovalOnwardsContractAtomItemRepository _approvalOnwardsContractRepository;
        private readonly IContractTransformer _contractTransformer;
        private readonly IContractXmlValidator _contractXmlValidator;

        public ApprovalOnwardsContractAtomFeedService(
            ILogger logger,
            IApprovalOnwardsContractAtomItemRepository approvalOnwardsContractRepository,
            IContractTransformer contractTransformer,
            IContractXmlValidator contractXmlValidator)
        {
            _logger = logger;
            _approvalOnwardsContractRepository = approvalOnwardsContractRepository;
            _contractTransformer = contractTransformer;
            _contractXmlValidator = contractXmlValidator;
        }

        public AtomItemCreationResult AddContractToFeed(ConnectionInfo connectionInfo, contract corporateContract, Guid feedItemId, AtomItemType atomItemType)
        {
            SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contract corporateSchema = _contractTransformer.TransformToCorporateSchemaContract(corporateContract);
            try
            {
                _approvalOnwardsContractRepository.Add(connectionInfo, AtomFeedItem.CreateAtomFeedItem(corporateSchema,
                    corporateSchema.GetFirstContractNumber(), atomItemType, feedItemId, IsValidXml));

                return AtomItemCreationResult.Added;
            }
            catch (SqlDuplicateKeyStorageException)
            {
                string businessKey = corporateSchema.GetFirstContractNumber();

                if (_approvalOnwardsContractRepository.GetIdentifierForBusinessKey(connectionInfo, businessKey,
                        atomItemType) == feedItemId)
                {
                    return AtomItemCreationResult.AlreadyPresentWithSameFeedItemId;
                }

                _logger.LogInformation(
                    ContractManagementLoggingEvents.AddApprovedTerminationInitiationContractAlreadyPresent,
                    $"{atomItemType} - Feed Item already present - Business Key {businessKey}");

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
