namespace ContractManagementDomain.Termination.Services
{
    using System;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IApprovalOnwardsContractAtomFeedService
    {
        AtomItemCreationResult AddContractToFeed(ConnectionInfo connectionInfo, Contract corporateContract, Guid feedItemId, AtomItemType atomItemType);
    }
}
