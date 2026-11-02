namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using System.Data.Entity;

    public class ClaimReferenceProfileRepository : IClaimReferenceProfileRepository
    {
        public async Task<bool> IsProfileFromReferenceData(string claimReconciliationDeliverableGroupCode, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                var claimReconciliationDeliverableGroups = await context.ClaimReconciliationDeliverableGroups
                    .SingleAsync(crdg => crdg.ClaimReconciliationDeliverableGroupCode == claimReconciliationDeliverableGroupCode)
                    .ConfigureAwait(continueOnCapturedContext: false);

                return claimReconciliationDeliverableGroups.ObtainProfileFromReferenceData;
            }
        }

        public async Task<decimal?> GetPlannedValue(string claimReconciliationDeliverableGroupCode, int ukprn, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                var claimReconciliationReferenceDataProfile = await context.ClaimReconciliationReferenceDataProfiles.SingleOrDefaultAsync(crrdp =>
                    crrdp.ClaimReconciliationDeliverableGroupCode == claimReconciliationDeliverableGroupCode &&
                    crrdp.Ukprn == ukprn).ConfigureAwait(continueOnCapturedContext: false);

                return claimReconciliationReferenceDataProfile?.PlannedValue;
            }
        }
    }
}