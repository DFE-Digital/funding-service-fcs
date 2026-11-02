namespace ContractRequestDomain.Cfs.Dto
{
    using System;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [Serializable]
    public class ContractCfsAllocation
    {
        public ExtendedContractType Contract { get; set; }

        public Guid CfsAllocationId { get; set; }
    }
}
