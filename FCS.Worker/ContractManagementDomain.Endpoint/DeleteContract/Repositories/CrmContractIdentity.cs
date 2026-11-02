namespace ContractManagementDomain.Endpoint.DeleteContract.Repositories
{
    using System;

    public class CrmContractIdentity
    {
        public Guid ContractId { get; set; }

        public Guid MasterContractId { get; set; }
    }
}