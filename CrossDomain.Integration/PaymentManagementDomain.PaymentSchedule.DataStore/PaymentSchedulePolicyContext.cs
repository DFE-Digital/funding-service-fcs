namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore
{
    using System.Data.Common;
    using System.Data;
    using System.Data.Entity.ModelConfiguration.Conventions;
    using System.Data.Entity;
    using CrossDomain.Integration.Entities.Data;
    using Model;

    public class PaymentSchedulePolicyContext : DbContext, IPaymentSchedulePolicyContext
    {
        public static string KeyVaultValue { get; set; } = string.Empty;
        public PaymentSchedulePolicyContext() : base(GetConnectionString())
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersionWithTransactionSuppressInitializer<PaymentSchedulePolicyContext, Migrations.Configuration>());
        }

        public PaymentSchedulePolicyContext(IDbConnection connection)
            : base((DbConnection)connection, false)
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersionWithTransactionSuppressInitializer<PaymentSchedulePolicyContext, Migrations.Configuration>());
        }
        private static string GetConnectionString()
        {
            if (!string.IsNullOrWhiteSpace(KeyVaultValue))
            {
                return KeyVaultValue;
            }
            return "name=PaymentSchedulePolicyContext";
        }

        public PaymentSchedulePolicyContext(ConnectionInfo connectionInfo)
            : this(connectionInfo.Connection, connectionInfo.Transaction)
        {
        }

        public PaymentSchedulePolicyContext(IDbConnection connection, DbTransaction transaction)
            : base((DbConnection)connection, false)
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersionWithTransactionSuppressInitializer<PaymentSchedulePolicyContext, Migrations.Configuration>());

            if (transaction != null)
            {
                Database.UseTransaction(transaction);
            }
        }

        public virtual IDbSet<Allocation> Allocations { get; set; }

        public virtual IDbSet<DeliverablePayment> DeliverablePayments { get; set; }

        public IDbSet<OrganisationIdentifer> OrganisationIdentifiers { get; set; }

        public IDbSet<ProvisionIdentifier> ProvisionIdentifiers { get; set; }

        public IDbSet<PublishedPayableFcrAllocation> PublishedPayableFcrAllocations { get; set; }

        public IDbSet<ProcessedMessage> ProcessedMessages { get; set; }

        public void UpdateEntry<TEntity>(TEntity entityInDb, TEntity entity) where TEntity : class
        {
            Entry(entityInDb).CurrentValues.SetValues(entity);
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("PaymentSchedule");
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }
    }
}
