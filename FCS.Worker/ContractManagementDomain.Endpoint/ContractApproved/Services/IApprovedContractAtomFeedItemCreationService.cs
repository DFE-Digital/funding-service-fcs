namespace ContractManagementDomain.Endpoint.ContractApproved.Services
{
    using System;
    using System.Threading.Tasks;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IApprovedContractAtomFeedItemCreationService
    {
        Task<AtomItemCreationResult> AddApprovedContract(contract corporateContract, Guid feedItemId, ConnectionInfo connectionInfo);
    }
}
