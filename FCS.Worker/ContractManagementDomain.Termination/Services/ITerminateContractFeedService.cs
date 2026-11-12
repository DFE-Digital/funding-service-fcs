namespace ContractManagementDomain.Termination.Services
{
    using System;
    using ContractManagement.DataStore.Model;
    using DTOs;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ITerminateContractFeedService
    {
        UpdateSubStatusAndAddContractToFeedResult UpdateContractAndAddToFeed(ConnectionInfo connectionInfo,
            ContractIdentifier contractIdentifier, Action<Contract> updateContract, string messageId, AtomItemType atomItemType);
    }
}