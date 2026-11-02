namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore
{
    using System.Data;
    using System.Data.Common;
    using System.Data.Entity;
    using System.Data.Entity.ModelConfiguration.Conventions;
    using CrossDomain.Integration.Entities.Data;
    using Model;

    /// <summary>
    /// A Db context used for Payment Management Policy entities
    /// </summary>
    public class PaymentManagementPolicyContext : DbContext, IPaymentManagementPolicyContext
    {

        public static string KeyVaultValue { get; set; }
        /// <summary>
        /// Parameterless Constructor for Payment Management Policy to set the initializer
        /// </summary>
        public PaymentManagementPolicyContext() : base(GetConnectionString())
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersionWithTransactionSuppressInitializer<PaymentManagementPolicyContext, Migrations.Configuration>());
        }
        private static string GetConnectionString()
        {
            if (!string.IsNullOrWhiteSpace(KeyVaultValue))
            {
                return KeyVaultValue;
            }
            return "name=PaymentManagementPolicyContext";
        }

        public PaymentManagementPolicyContext(IDbConnection connection)
        : base((DbConnection) connection, false)
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersionWithTransactionSuppressInitializer<PaymentManagementPolicyContext, Migrations.Configuration>());
        }

        public PaymentManagementPolicyContext(ConnectionInfo connectionInfo)
            : this(connectionInfo.Connection, connectionInfo.Transaction)
        {
        }
        
        public PaymentManagementPolicyContext(IDbConnection connection, DbTransaction transaction)
            : base((DbConnection)connection, false)
        {
            if (transaction != null)
            {
                Database.UseTransaction(transaction);
            }
        }

        public virtual IDbSet<Model.PolicyDeliverable> PolicyDeliverables { get; set; }

        public virtual IDbSet<Model.PolicyDeliverableToSubnominals> PolicyDeliverableToSubnominals { get; set; }

        public virtual IDbSet<Model.PolicyFundingStreamCensusDate> PolicyFundingStreamCensusDates { get; set; }

        public virtual IDbSet<Model.PolicyFundingStreamPeriod> PolicyFundingStreamPeriods { get; set; }

        public virtual IDbSet<Model.PolicySubnominal> PolicySubnominals { get; set; }

        public virtual IDbSet<Model.CappingGroup> CappingGroups { get; set; }

        public virtual IDbSet<Model.ESFRegionInvestmentPriority> ESFRegionInvestmentPriorities { get; set; }

        public DbSet<FundingStreamPeriodPayCalcPolicy> FundingStreamPeriodPayCalcPolicies { get; set; }

        public DbSet<FundingStreamPeriodCappingPeriodPayCalcPolicy> FundingStreamPeriodCappingPeriodPayCalcPolicies { get; set; }

        public IDbConnection GetConnection() => Database.Connection;

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("PolicyCache");
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }
    }
}