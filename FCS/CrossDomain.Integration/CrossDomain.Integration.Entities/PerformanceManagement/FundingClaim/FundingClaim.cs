namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim
{
    using System.Collections.Generic;

    public class FundingClaim
    {
        public FundingClaim()
        {
            Contractor = new Contractor();
            ContractAllocations = new List<ContractAllocation>();
        }

        public Contractor Contractor { get; set; }

        public int VersionNumber { get; set; }

        public ClaimTypeName ClaimTypeName { get; set; }

        public PeriodTypeCode PeriodTypeCode { get; set; }

        public string Period { get; set; }

        public bool HasBeenSigned { get; set; }

        public List<ContractAllocation> ContractAllocations { get; set; }
    }
}
