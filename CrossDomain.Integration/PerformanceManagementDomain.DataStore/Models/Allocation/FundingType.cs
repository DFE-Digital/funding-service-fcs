namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation
{
    using System.ComponentModel.DataAnnotations;

    public class FundingType
    {
        [Required]
        [MaxLength(20)]
        public string FundingTypeCode { get; set; }

        [Required]
        [MaxLength(150)]
        public string FundingTypeName { get; set; }
    }
}
