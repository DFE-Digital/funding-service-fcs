namespace SFA.FCT.ContractRequestDomain.DataStore
{
    using System.Data;
    using System.Data.Common;
    using System.Data.Entity;
    using System.Data.Entity.ModelConfiguration.Conventions;
    using Model;

    public class ContractRequestDbContext : DbContext, IContractRequestDbContext
    {
        public ContractRequestDbContext()
        {
        }

        public ContractRequestDbContext(IDbConnection connection)
            : base((DbConnection) connection, false)
        {
        }

        public ContractRequestDbContext(IDbConnection connection, DbTransaction transaction)
            : base((DbConnection)connection, false)
        {
            if (transaction != null)
            {
                Database.UseTransaction(transaction);
            }
        }
        
        public virtual IDbSet<FundingTypeFundingPeriod> FundingTypeFundingPeriods { get; set; }

        public virtual IDbSet<FileWatcherLockResource> FileWatcherLockResources { get; set; }

        public virtual DbSet<AllocationNotification> AllocationNotifications { get; set; }

        public IDbSet<FundingAllocationRelease> FundingAllocationReleases { get; set; }

        public IDbSet<WebjobStatus> WebjobStatuses { get; set; }

        public int ExecuteSql(string sqlCommand)
        {
            return Database.ExecuteSqlCommand(sqlCommand);
        }

        public DbConnection GetConnection() => this.Database.Connection;

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            Database.SetInitializer<ContractRequestDbContext>(null);
            modelBuilder.HasDefaultSchema("ContractRequest");
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }
    }
}