namespace Operations.DataStore
{
    using System.Collections.ObjectModel;
    using System.Data;
    using System.Data.Common;
    using System.Data.Entity;
    using System.Data.Entity.ModelConfiguration.Conventions;
    using System.Data.SqlClient;
    using Model;

    public class OperationsDbContext : DbContext
    {
        public static string KeyVaultValue { get; set; }
        public OperationsDbContext(IDbConnection connection, DbTransaction transaction)
            : base((DbConnection)connection, contextOwnsConnection: false)
        {
            if (transaction != null)
            {
                this.Database.UseTransaction(transaction);
            }
        }
        public OperationsDbContext() : base(GetConnectionString())
        {
        }

        private static string GetConnectionString()
        {
            if (!string.IsNullOrWhiteSpace(KeyVaultValue))
            {
                return KeyVaultValue;
            }
            return "name=OperationsDbContext";
        }
 
        public OperationsDbContext(SqlConnection connection)
        {
            Connection = connection;
        }

        public DbSet<Session> Sessions { get; set; }

        public DbSet<DataFixHistory> DataFixHistories { get; set; }

        public DbSet<DuplicateContract> DuplicateContracts { get; set; }

        public DbSet<AuditMessage> AuditMessages { get; set; }

        public DbSet<DeployedConfigVersion> DeployedConfigVersions { get; set; }

        public DbSet<IntegrityCheckChangeTracking> IntegrityCheckChangeTrackingRows { get; set; }

        public DbSet<ProcessedMessage> ProcessedMessages { get; set; }

        public DbSet<FundingReportProvider> FundingReportProviders { get; set; }
        public DbSet<FundingReportFSP> FundingReportFSPs { get; set; }
        public DbSet<FundingStreamPeriod> FundingStreamPeriods { get; set; }

        public SqlConnection Connection { get; }
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("Operations");
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }
    }
}
