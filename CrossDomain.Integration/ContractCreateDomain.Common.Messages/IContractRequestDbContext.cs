namespace SFA.FCT.ContractRequestDomain.DataStore
{
    using System.Data.Common;
    using System.Data.Entity;
    using Model;

    public interface IContractRequestDbContext
    {
        IDbSet<FundingTypeFundingPeriod> FundingTypeFundingPeriods { get; set; }

        DbSet<AllocationNotification> AllocationNotifications { get; set; }

        IDbSet<FundingAllocationRelease> FundingAllocationReleases { get; set; }

        IDbSet<WebjobStatus> WebjobStatuses { get; set; }

        int ExecuteSql(string sqlCommand);

        int SaveChanges();
        DbConnection GetConnection();
    }
}