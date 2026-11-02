namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    public interface IClaimReferenceProfileRepository
    {
        decimal? GetPlannedValue(string claimReconciliationDeliverableGroupCode, int ukprn);
        bool IsProfileFromReferenceData(string claimReconciliationDeliverableGroupCode);
    }
}
