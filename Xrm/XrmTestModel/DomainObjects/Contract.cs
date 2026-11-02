namespace XrmTestModel
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public class Contract
    {
        [Required]
        public Organisation Provider { get; set; }

        public string Ukprn { get; set; }

        public string ContractNumber { get; set; }

        public int Version { get; set; }

        public int SubVersion { get; set; }

        public string ContractType { get; set; }

        public string FundingType { get; set; }

        public string Description { get; set; }

        public string ParentContractNumber { get; set; }

        public virtual IEnumerable<Contract> ChildContracts { get; set; }

        public virtual IEnumerable<ContractAllocation> Allocations { get; set; }

        public bool LastApprovedVersion { get; set; }

        public bool LatestVersion { get; set; }

        public DateTime? ContractApprovedDate { get; set; }
    }
}

