namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    public class FundingStreamPeriodQueryRepository : IFundingStreamPeriodQueryRepository
    {
        private readonly IPerformanceManagementDbContext _performanceManagementDbContext;

        public FundingStreamPeriodQueryRepository(IPerformanceManagementDbContext performanceManagementDbContext)
        {
            _performanceManagementDbContext = performanceManagementDbContext;
        }

        public bool IsFundingStreamPeriodPayOnProfile(string fspCode)
        {
            return _performanceManagementDbContext.FundingStreamPeriods.Find(fspCode).IsPayOnProfile;
        }
    }
}