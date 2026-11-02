namespace SFA.FCT.CrossDomain.Integration.Events
{
    using System;

    public class FundingClaimReconciliationFailedPublicationEvent
    {
        public Guid FundingClaimReconciliationId { get; set; }

        public string FundingClaimReconciliationName { get; set; }

        public string FailureReason { get; set; }

        public DateTime OccurredOnDate { get; set; }
    }
}
