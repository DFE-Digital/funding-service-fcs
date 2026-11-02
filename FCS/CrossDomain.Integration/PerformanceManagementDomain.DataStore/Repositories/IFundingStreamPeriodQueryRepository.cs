namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    public interface IFundingStreamPeriodQueryRepository
    {
        bool IsFundingStreamPeriodPayOnProfile(string fspCode);
    }
}