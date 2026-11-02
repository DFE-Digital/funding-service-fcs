namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.CrmRepositories
{
    public class AllocationPlannedValue
    {
        public AllocationPlannedValue(string allocationNumber, decimal plannedValue)
        {
            AllocationNumber = allocationNumber;
            PlannedValue = plannedValue;
        }

        public string AllocationNumber { get; }

        public decimal PlannedValue { get; }

        public System.Guid FcrAllocationId { get; set; }

        protected bool Equals(AllocationPlannedValue other)
        {
            return string.Equals(AllocationNumber, other.AllocationNumber) && PlannedValue == other.PlannedValue;
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((AllocationPlannedValue)obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                return ((AllocationNumber?.GetHashCode() ?? 0) * 397) ^ PlannedValue.GetHashCode();
            }
        }
    }
}