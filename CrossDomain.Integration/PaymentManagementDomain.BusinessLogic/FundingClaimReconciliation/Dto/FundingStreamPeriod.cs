namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.FundingClaimReconciliation.Dto
{
    using System.Collections.Generic;

    public class FundingStreamPeriod
    {
        public string FundingStreamPeriodCode { get; set; }

        public List<CappingGroup> CappingGroups { get; set; }

        public string PaymentMethod { get; set; }

        public string CappingLevel { get; set; }

        public string CappingPeriodType { get; set; }

        public List<PaymentTimetableCensusDate> PaymentTimetableCensusDates { get; set; }
    }
}
