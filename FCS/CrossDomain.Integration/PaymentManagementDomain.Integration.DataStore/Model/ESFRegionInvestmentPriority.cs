namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class ESFRegionInvestmentPriority
    {
        private ESFRegionInvestmentPriority()
        {
        }

        public ESFRegionInvestmentPriority(RegionType regionType, decimal investmentPriority, string subnominalCode)
        {
            RegionType = regionType.ToString();
            InvestmentPriority = investmentPriority;
            SubnominalCode = subnominalCode;
            CreatedDate = DateTime.UtcNow;
        }

        [Key, Column(Order = 0)]
        public string RegionType { get; private set; }

        [Key, Column(Order = 1)]
        public decimal InvestmentPriority { get; private set; }

        [Required]
        public string SubnominalCode { get; private set; }

        public DateTime CreatedDate { get; private set; } = DateTime.UtcNow;
    }
}
