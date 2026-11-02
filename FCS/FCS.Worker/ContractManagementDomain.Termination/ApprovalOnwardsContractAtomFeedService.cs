namespace SFA.FCT.ContractManagementDomain.Integration.Services
{
    using System;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using ContractManagementService.Common;
    using CrossDomain.Integration.Common.PagedStorage.Exceptions;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Entities.Data;
    using Framework.Logging.Interfaces;

    public class ApprovalOnwardsContractAtomFeedService : IApprovalOnwardsContractAtomFeedService
    {
        private readonly ILogger _logger;
        private readonly IApprovalOnwardsContractAtomItemRepository _approvalOnwardsContractRepository;
        private readonly IContractTransformer _contractTransformer;
        
        public ApprovalOnwardsContractAtomFeedService(ILogger logger, IApprovalOnwardsContractAtomItemRepository approvalOnwardsContractRepository, IContractTransformer contractTransformer)
        {
            _logger = logger;
            _approvalOnwardsContractRepository = approvalOnwardsContractRepository;
            _contractTransformer = contractTransformer;
        }

        public AtomItemCreationResult AddClosedContract(contract corporateContract, Guid feedItemId)
        {
            CrossDomain.Integration.Entities.CorporateSchema.Contract.contract corporateSchema = _contractTransformer.TransformToCorporateSchemaContract(corporateContract);
            try
            {
                _approvalOnwardsContractRepository.Add(AtomFeedItem.CreateAtomFeedItem(corporateSchema,
                    corporateSchema.GetFirstContractNumber(), AtomItemType.ClosedContract, feedItemId));

                return AtomItemCreationResult.Added;
            }
            catch (DuplicateKeyStorageException)
            {
                if (_approvalOnwardsContractRepository.GetIdentifierForBusinessKey(corporateSchema.GetFirstContractNumber(),
                    AtomItemType.ClosedContract) == feedItemId)
                {
                    return AtomItemCreationResult.AlreadyPresentWithSameFeedItemId;
                }

                return AtomItemCreationResult.AlreadyPresent;
            }
        }

        public AtomItemCreationResult AddApprovedTerminationInitiationContract(ConnectionInfo connectionInfo, contract corporateContract, Guid feedItemId)
        {
            CrossDomain.Integration.Entities.CorporateSchema.Contract.contract corporateSchema = _contractTransformer.TransformToCorporateSchemaContract(corporateContract);
            try
            {
                _approvalOnwardsContractRepository.Add(connectionInfo, AtomFeedItem.CreateAtomFeedItem(corporateSchema,
                    corporateSchema.GetFirstContractNumber(), AtomItemType.ContractTerminationInitiated, feedItemId));

                return AtomItemCreationResult.Added;
            }
            catch (DuplicateKeyStorageException)
            {
                if (_approvalOnwardsContractRepository.GetIdentifierForBusinessKey(connectionInfo, corporateSchema.GetFirstContractNumber(),
                        AtomItemType.ContractTerminationInitiated) == feedItemId)
                {
                    return AtomItemCreationResult.AlreadyPresentWithSameFeedItemId;
                }

                return AtomItemCreationResult.AlreadyPresent;
            }
        }
    }
}
