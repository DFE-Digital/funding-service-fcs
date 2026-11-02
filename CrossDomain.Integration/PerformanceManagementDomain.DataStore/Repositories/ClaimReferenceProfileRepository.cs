namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using Models;

    public class ClaimReferenceProfileRepository : PerformanceManagementRepositoryBase<ClaimReconciliationReferenceDataProfile>, IClaimReferenceProfileRepository
    {
        private readonly IPerformanceManagementDbContext _dbContext;
        public ClaimReferenceProfileRepository(IPerformanceManagementDbContext dbContext)
            : base(dbContext.ClaimReconciliationReferenceDataProfiles)
        {
            _dbContext = dbContext;
        }

        public bool IsProfileFromReferenceData(string claimReconciliationDeliverableGroupCode)
        {
            return
                _dbContext.ClaimReconciliationDeliverableGroups.Find(claimReconciliationDeliverableGroupCode)
                    .ObtainProfileFromReferenceData;
        }

        public decimal? GetPlannedValue(string claimReconciliationDeliverableGroupCode, int ukprn)
        {
            return FindByKey(new object[] { claimReconciliationDeliverableGroupCode, ukprn })?.PlannedValue;
        }
    }
}