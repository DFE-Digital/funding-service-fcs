namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FundingStreamPeriodCappingPeriodPayCalcPolicy
    {
        private FundingStreamPeriodCappingPeriodPayCalcPolicy()
        {
        }

        public FundingStreamPeriodCappingPeriodPayCalcPolicy(string fundingStreamPeriodCode,
            int calcPolicyVersion,
            int cappingPeriod,
            decimal overDeliveryLimit)
        {
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            CalcPolicyVersion = calcPolicyVersion;
            CappingPeriod = cappingPeriod;
            OverDeliveryLimit = overDeliveryLimit;
        }

        [Key, Column(Order = 0)]
        public string FundingStreamPeriodCode { get; private set; }

        [Key, Column(Order = 1)]
        public int CalcPolicyVersion { get; private set; }

        [Key, Column(Order = 2)]
        public int CappingPeriod { get; private set; }

        [Required]
        public decimal OverDeliveryLimit { get; private set; }
    }
}