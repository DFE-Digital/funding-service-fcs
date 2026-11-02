namespace SFA.FCT.AllocationDelivery.DataStore
{
    using System.Data;
    using System.Data.Common;
    using System.Data.Entity;
    using System.Data.Entity.ModelConfiguration.Conventions;
    using CrossDomain.Integration.Entities.Data;
    using Model;

    public class AllocationDeliveryDbContext : DbContext, IAllocationDeliveryDbContext
    {
        public static string KeyVaultValue { get; set; } = string.Empty;
        public AllocationDeliveryDbContext() : base(GetConnectionString())
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersionWithTransactionSuppressInitializer<AllocationDeliveryDbContext, Migrations.Configuration>());
        }

        public AllocationDeliveryDbContext(IDbConnection connection)
        : base((DbConnection) connection, false)
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersionWithTransactionSuppressInitializer<AllocationDeliveryDbContext, Migrations.Configuration>());
        }
        private static string GetConnectionString()
        {
            if (!string.IsNullOrWhiteSpace(KeyVaultValue))
            {
                return KeyVaultValue;
            }
            return "name=AllocationDeliveryDbContext";
        }
        public AllocationDeliveryDbContext(ConnectionInfo connectionInfo)
            : base((DbConnection)connectionInfo.Connection, false)
        {
            if (connectionInfo.Transaction != null)
            {
                Database.UseTransaction(connectionInfo.Transaction);
            }

            Database.SetInitializer(new MigrateDatabaseToLatestVersionWithTransactionSuppressInitializer<AllocationDeliveryDbContext, Migrations.Configuration>());
        }

        public virtual IDbSet<AllocationDeliveryEntry> AllocationDeliveryEntries { get; set; }

        public virtual IDbSet<AllocationDeliveryEntryData> AllocationDeliveryEntryDataItems { get; set; }

        public virtual IDbSet<ProcessedMessage> ProcessedMessages { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("AllocationDelivery");
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();

            modelBuilder.Entity<AllocationDeliveryEntry>()
                .HasOptional(a => a.AllocationDeliveryEntryData)
                .WithRequired()
                .WillCascadeOnDelete();
        }
    }
}
