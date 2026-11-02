namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;

    public class ClaimCollection
    {
        private ClaimCollection()
        {
        }

        public ClaimCollection(string claimCollectionCode, string claimTypeCode, string period, string periodType)
        {
            ClaimCollectionCode = claimCollectionCode;
            ClaimTypeCode = claimTypeCode;
            Period = period;
            PeriodType = periodType;
        }

        [Key]
        [MaxLength(30)]
        public string ClaimCollectionCode { get; private set; }

        [MaxLength(5)]
        [Required]
        public string ClaimTypeCode { get; set; }

        [MaxLength(4)]
        [Required]
        public string Period { get; set; }

        [MaxLength(2)]
        [Required]
        public string PeriodType { get; set; }

        public ClaimType ClaimType { get; set; }
    }
}
