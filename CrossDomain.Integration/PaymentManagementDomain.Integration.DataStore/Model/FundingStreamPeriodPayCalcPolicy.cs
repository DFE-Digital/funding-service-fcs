namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FundingStreamPeriodPayCalcPolicy
    {

        [Key, Column(Order = 0)]
        public string FundingStreamPeriodCode { get; set; }

        [Key, Column(Order = 1)]
        public int CalcPolicyVersion { get; set; }

        [Required]
        public PaymentCappingPeriodType PaymentCappingPeriod { get; set; }

        [ForeignKey("FundingStreamPeriodCode")]
        public PolicyFundingStreamPeriod FundingStreamPeriod { get; set; }

        public virtual ICollection<FundingStreamPeriodCappingPeriodPayCalcPolicy> FundingStreamPeriodCappingPeriodPayCalcPolicies { get; set; }
    }
}
