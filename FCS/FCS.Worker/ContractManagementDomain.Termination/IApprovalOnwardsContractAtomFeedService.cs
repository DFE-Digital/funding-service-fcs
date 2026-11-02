namespace SFA.FCT.ContractManagementDomain.Integration.Services
{
    using System;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Entities.Data;
    using SFA.FCT.ContractManagementService.Common;

    public interface IApprovalOnwardsContractAtomFeedService
    {
        AtomItemCreationResult AddClosedContract(contract corporateContract, Guid feedItemId);

        AtomItemCreationResult AddApprovedTerminationInitiationContract(ConnectionInfo connectionInfo, contract corporateContract, Guid feedItemId);
    }
}
