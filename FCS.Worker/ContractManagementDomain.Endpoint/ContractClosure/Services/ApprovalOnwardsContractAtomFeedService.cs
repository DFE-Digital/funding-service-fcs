namespace ContractManagementDomain.Endpoint.ContractClosure.Services
{
    using System;
    using ContractManagement.DataStore.Exceptions;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ApprovalOnwardsContractAtomFeedService : IApprovalOnwardsContractAtomFeedService
    {
        private readonly IApprovalOnwardsContractAtomItemRepository _approvalOnwardsContractRepository;
        private readonly IContractTransformer _contractTransformer;
        private readonly IContractXmlValidator _contractXmlValidator;
        private readonly ILogger _logger;

        public ApprovalOnwardsContractAtomFeedService(
            IApprovalOnwardsContractAtomItemRepository approvalOnwardsContractRepository,
            IContractTransformer contractTransformer,
            IContractXmlValidator contractXmlValidator,
            ILogger logger)
        {
            _approvalOnwardsContractRepository = approvalOnwardsContractRepository;
            _contractTransformer = contractTransformer;
            _contractXmlValidator = contractXmlValidator;
            _logger = logger;
        }

        public AtomItemCreationResult AddClosedContract(Contract corporateContract, Guid feedItemId, ConnectionInfo connectionInfo)
        {
            SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.Contract corporateSchema = _contractTransformer.TransformToCorporateSchemaContract(corporateContract);
            try
            {
                _approvalOnwardsContractRepository.Add(
                    connectionInfo,
                    AtomFeedItem.CreateAtomFeedItem(corporateSchema, corporateSchema.GetFirstContractNumber(), AtomItemType.ClosedContract, feedItemId, IsValidXml));

                return AtomItemCreationResult.Added;
            }
            catch (SqlDuplicateKeyStorageException)
            {
                if (_approvalOnwardsContractRepository.GetIdentifierForBusinessKey(connectionInfo, corporateSchema.GetFirstContractNumber(),
                    AtomItemType.ClosedContract) == feedItemId)
                {
                    return AtomItemCreationResult.AlreadyPresentWithSameFeedItemId;
                }

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
