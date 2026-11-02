namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FundingClaim
    {
        private FundingClaim()
        {
        }

        public FundingClaim(string organisationIdentifier, int ukprn, int versionNumber, string claimTypeName, string periodTypeCode, string period, bool hasBeenSigned)
        {
            Id = Guid.NewGuid();
            OrganisationIdentifier = organisationIdentifier;
            Ukprn = ukprn;
            VersionNumber = versionNumber;
            ClaimTypeName = claimTypeName;
            PeriodTypeCode = periodTypeCode;
            Period = period;
            HasBeenSigned = hasBeenSigned;
        }

        [Key, Column(Order = 1)]
        public Guid Id { get; private set; }

        [Index("IX_FundingClaimNaturalKey", 5, IsUnique = true)]
        [MaxLength(10)]
        [Required]
        public string OrganisationIdentifier { get; set; }

        [Required]
        public int Ukprn { get; set; }

        [Required]
        [Index("IX_FundingClaimNaturalKey", 4, IsUnique = true)]
        public int VersionNumber { get; set; }

        [Required]
        [MaxLength(20)]
        [Index("IX_FundingClaimNaturalKey", 1, IsUnique = true)]
        public string ClaimTypeName { get; set; }

        [Required]
        [MaxLength(10)]
        [Index("IX_FundingClaimNaturalKey", 3, IsUnique = true)]
        public string PeriodTypeCode { get; set; }

        [Required]
        [MaxLength(4)]
        [Index("IX_FundingClaimNaturalKey", 2, IsUnique = true)]
        public string Period { get; set; }

        [Required]
        public bool HasBeenSigned { get; set; }

        public virtual ICollection<FundingClaimContractAllocation> Allocations { get; set; } = new List<FundingClaimContractAllocation>();

    }
}
