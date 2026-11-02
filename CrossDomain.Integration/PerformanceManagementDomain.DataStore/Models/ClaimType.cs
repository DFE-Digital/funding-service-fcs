namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;

    public class ClaimType
    {
        private ClaimType()
        {
        }

        public ClaimType(string claimTypeCode, string name)
        {
            ClaimTypeCode = claimTypeCode;
            Name = name;
        }

        [Key]
        [MaxLength(5)]
        public string ClaimTypeCode { get; private set; }

        [MaxLength(50)]
        [Required]
        public string Name { get; set; }
    }
}
