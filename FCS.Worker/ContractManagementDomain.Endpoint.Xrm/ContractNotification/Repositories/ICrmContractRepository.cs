namespace ContractManagementDomain.Endpoint.Xrm.ContractNotification.Repositories
{
    using System;
    using Dtos;

    public interface ICrmContractRepository
    {
        ProviderInfo GetProviderInfoForContract(string contractNumber, int version, int subVersion);

        ProviderInfo GetProviderInfoForContract(string contractNumber, int version);

        Guid GetLatestUserIdAssociatedWithWorkflowItemForContract(string contractNumber, int version, int subVersion, string workflowActionName);

        Guid GetSpecialTaskOwnerUserForContractWithSubStatus(string contractNumber, int versionNumber, string subStatusName);
    }
}