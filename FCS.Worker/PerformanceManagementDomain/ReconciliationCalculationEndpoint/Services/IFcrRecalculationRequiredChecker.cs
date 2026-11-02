namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services
{
    using System.Collections.Generic;
    using DTOs;

    public interface IFcrRecalculationRequiredChecker
    {
        RecalculationCheckResult CheckIfRecalculationRequired(IReadOnlyCollection<AllocationInfo> allocationsPlannedValue, string allocationNumber, decimal newPlannedValue);
    }
}