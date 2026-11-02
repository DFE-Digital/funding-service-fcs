namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.FundingClaimReconciliation.Dto
{
    using System;

    public class PaymentTimetableCensusDate
    {
        public DateTime CensusDate { get; set; }

        public int PeriodMonth { get; set; }

        public int PeriodYear { get; set; }
    }
}
