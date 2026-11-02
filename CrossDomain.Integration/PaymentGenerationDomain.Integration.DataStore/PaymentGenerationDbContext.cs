namespace PaymentGenerationDomain.Integration.DataStore
{
    using System;
    using System.Data;
    using System.Data.Common;
    using System.Data.Entity;
    using System.Data.Entity.ModelConfiguration.Conventions;
    using Migrations;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class PaymentGenerationDbContext : DbContext
    {
        private Guid _contextId;

        public static string KeyVaultValue { get; set; }//This keyvalut value is set by the test framework when running in a test environment, and is used to override the connection string for the database context. This allows the tests to connect to a different database than the one used in production, which can be useful for testing purposes. The value is typically retrieved from Azure Key Vault, which is a secure storage service for secrets such as connection strings. By using this approach, the tests can be run without exposing sensitive information in the code or configuration files.

        public PaymentGenerationDbContext() : base(GetConnectionString())
        {
            Configuration.ProxyCreationEnabled = false;
        }

        private static string GetConnectionString()
        {
            if (!string.IsNullOrWhiteSpace(KeyVaultValue))
            {
                return KeyVaultValue;
            }
            return "name=PaymentGenerationDbContext";
        }

        public PaymentGenerationDbContext(IDbConnection connection)
        : base((DbConnection) connection, false)
        {
            Configuration.ProxyCreationEnabled = false;
        }

        public PaymentGenerationDbContext(ConnectionInfo connectionInfo)
            : base((DbConnection)connectionInfo.Connection, contextOwnsConnection: false)
        {
            Configuration.ProxyCreationEnabled = false;

            if (connectionInfo.Transaction != null)
            {
                Database.UseTransaction(connectionInfo.Transaction);
            }
        }

        public virtual DbSet<PaymentTimetable> PaymentTimetables { get; set; }

        public virtual DbSet<FundingStream> FundingStreams { get; set; }

        public virtual DbSet<FundingStreamPeriod> FundingStreamPeriods { get; set; }

        public virtual DbSet<Subnominal> Subnominals { get; set; }

        public virtual DbSet<SubnominalAggregation> SubnominalAggregations { get; set; }

        public virtual DbSet<PaymentTimetableHistory> PaymentTimetableHistories { get; set; }

        public virtual DbSet<PaymentBatchFeedItem> PaymentBatchFeedItems { get; set; }
       
        public virtual void SetModified(object entity)
        {
            Entry(entity).State = EntityState.Modified;
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("PaymentGeneration");
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }

        private void Initialize()
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersion<PaymentGenerationDbContext, Configuration>());
            Configuration.ProxyCreationEnabled = false;
            _contextId = Guid.NewGuid();   
        }
    }
}
