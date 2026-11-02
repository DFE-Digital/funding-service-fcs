namespace ContractManagementDomain.Termination.Services
{
    using System;
    using ContractManagement.DataStore.Model;
    using DTOs;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using ContractManagement.DataStore.Services;
    using ContractManagementDomain.Termination.Repositories;
    using SFA.FCT.ContractManagementService.Common.Repositories;

    public class TerminateContractFeedService : ITerminateContractFeedService
    {
        private readonly ICrmContractRepository _crmContractRepository;
        private readonly IContractsManager _contractsManager;
        private readonly ILegalDeliverableService _legalDeliverableService;
        private readonly IApprovalOnwardsContractAtomFeedService _approvalOnwardsContractAtomFeedService;
        private readonly ICorporateContractService _corporateContractService;

        public TerminateContractFeedService(ICrmContractRepository crmContractRepository,
            IContractsManager contractsManager, ILegalDeliverableService legalDeliverableService,
            IApprovalOnwardsContractAtomFeedService approvalOnwardsContractAtomFeedService,
            ICorporateContractService corporateContractService)
        {
            _crmContractRepository = crmContractRepository;
            _contractsManager = contractsManager;
            _legalDeliverableService = legalDeliverableService;
            _approvalOnwardsContractAtomFeedService = approvalOnwardsContractAtomFeedService;
            _corporateContractService = corporateContractService;
        }

        public UpdateSubStatusAndAddContractToFeedResult UpdateContractAndAddToFeed(ConnectionInfo connectionInfo,
            ContractIdentifier contractIdentifier, Action<contract> updateContract, string messageId, AtomItemType atomItemType)
        {
            contract corporateContract = _corporateContractService.GetContract(
                connectionInfo: connectionInfo,
                crmContractRepository: _crmContractRepository,
                contractsManager: _contractsManager,
                legalDeliverableService: _legalDeliverableService,
                contractIdentifier: contractIdentifier);

            updateContract(corporateContract);

            AtomItemCreationResult result =
                _approvalOnwardsContractAtomFeedService.AddContractToFeed(connectionInfo, corporateContract, new Guid(messageId), atomItemType);

            return new UpdateSubStatusAndAddContractToFeedResult(result, corporateContract);
        }

    }
}