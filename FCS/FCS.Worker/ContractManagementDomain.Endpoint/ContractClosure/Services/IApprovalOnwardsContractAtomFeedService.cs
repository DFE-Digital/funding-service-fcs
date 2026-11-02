namespace ContractManagementDomain.Endpoint.ContractClosure.Services
{
    using System;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IApprovalOnwardsContractAtomFeedService
    {
        AtomItemCreationResult AddClosedContract(contract corporateContract, Guid feedItemId, ConnectionInfo connectionInfo);
    }
}
