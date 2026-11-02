namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FundingClaimContractAllocation
    {
        private FundingClaimContractAllocation()
        { }
        
        public FundingClaimContractAllocation(Guid fundingClaimId, string contractAllocationNumber, string fundingStreamPeriodCode)
        {
            Id = Guid.NewGuid();
            FundingClaimId = fundingClaimId;
            ContractAllocationNumber = contractAllocationNumber;
            FundingStreamPeriodCode = fundingStreamPeriodCode;
        }

        [Key]
        public Guid Id { get; set; }

        [Required]
        [Index("IX_FundingClaimAllocationNaturalKey", 1, IsUnique = true)]
        public Guid FundingClaimId { get; set; }

        [ForeignKey("FundingClaimId")]
        public virtual FundingClaim FundingClaim { get; set; }

        [Required]
        [Index("IX_FundingClaimAllocationNaturalKey", 2, IsUnique = true)]
        [MaxLength(20)]
        public string ContractAllocationNumber { get; private set; }

        [Required]
        [MaxLength(20)]
        public string FundingStreamPeriodCode { get; set; }

        public virtual ICollection<FundingClaimDeliverable> Deliverables { get; set; }

    }
}
