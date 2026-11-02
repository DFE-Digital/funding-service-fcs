namespace PerformanceManagement.IntegrationTests.State
{
    public class ClaimReferenceProfileValue
    {
        public ClaimReferenceProfileValue(string claimReconciliationDeliverableGroupCode, int ukprn, decimal plannedValue)
        {
            ClaimReconciliationDeliverableGroupCode = claimReconciliationDeliverableGroupCode;
            Ukprn = ukprn;
            PlannedValue = plannedValue;
        }

        public string ClaimReconciliationDeliverableGroupCode { get; }

        public int Ukprn { get; }

        public decimal PlannedValue { get; }
    }
}
