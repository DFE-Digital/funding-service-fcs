namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;

    public class FundingStreamPeriod
    {
        public FundingStreamPeriod(string fundingStreamPeriodCode, bool isPayOnProfile)
        {
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            IsPayOnProfile = isPayOnProfile;
        }

        private FundingStreamPeriod()
        {
        }

        [Key]
        [MaxLength(20)]
        public string FundingStreamPeriodCode { get; private set; }

        [Required]
        public bool IsPayOnProfile { get; private set; }
    }
}