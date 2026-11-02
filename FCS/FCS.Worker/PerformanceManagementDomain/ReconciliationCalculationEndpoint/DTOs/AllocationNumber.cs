namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs
{
    public class AllocationInfo
    {
        public AllocationInfo(string allocationNumber, decimal? plannedValue)
        {
            AllocationNumber = allocationNumber;
            PlannedValue = plannedValue;
        }

        public string AllocationNumber { get; }

        public decimal? PlannedValue { get; }
    }
}
