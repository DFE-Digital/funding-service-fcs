namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    /// <summary>
    /// Entity representing Policy Funding Stream Census Date
    /// </summary>
    public class PolicyFundingStreamCensusDate
    {
        [Key, Column(Order = 0)]
        public string FundingStreamPeriod { get; set; }

        [Column(Order = 1)]
        public DateTime CensusDate { get; set; }

        [Key, Column(Order = 2)]
        public int CalendarYear { get; set; }

        [Key, Column(Order = 3)]
        public int CalendarPeriod { get; set; }

        public int? PayCalcPolicyVersion { get; set; }
    }
}
