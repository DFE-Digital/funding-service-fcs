namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore
{
    using System.Data;
    using System.Data.Common;
    using System.Data.Entity;
    using System.Data.Entity.ModelConfiguration.Conventions;
    using Migrations;
    using Model;
    using System.Linq;
    using CrossDomain.Integration.Entities.Data;

    public class MonitoringDeliverablesDbContext : DbContext, IMonitoringDeliverablesDbContext
    {
        public static string KeyVaultValue { get; set; }

        public MonitoringDeliverablesDbContext() : base(GetConnectionString())
        {
        }

        public MonitoringDeliverablesDbContext(IDbConnection connection)
        : base((DbConnection)connection, false)
        {
        }

        public MonitoringDeliverablesDbContext(ConnectionInfo connectionInfo)
            : this(connectionInfo.Connection, connectionInfo.Transaction)
        {
        }

        public MonitoringDeliverablesDbContext(IDbConnection connection, DbTransaction transaction)
            : base((DbConnection)connection, false)
        {
            if (transaction != null)
            {
                Database.UseTransaction(transaction);
            }
        }
         
        private static string GetConnectionString()
        {
            if (!string.IsNullOrWhiteSpace(KeyVaultValue))
            {
                return KeyVaultValue;
            }
            return "name=MonitoringDeliverablesDbContext";
        }



        public virtual DbSet<FundingStreamPeriodDeliverable> FundingStreamPeriodDeliverables { get; set; }

        public virtual DbSet<AllocationDeliverablePeriod> AllocationDeliverablePeriods { get; set; }
        
        public virtual DbSet<AllocationDeliverablePeriodActualAudit> AllocationDeliverablePeriodActualAudits { get; set; }

        public virtual DbSet<CurrentViewActual> CurrentViewActuals { get; set; }

        public virtual DbSet<FundingStreamPeriod> FundingStreamPeriods { get; set; }

        public virtual DbSet<EsfAllocationData> ESFAllocationData { get; set; }

        public virtual DbSet<PaymentInstructionAudit> PaymentInstructionAudits { get; set; }

        public virtual DbSet<InactiveAllocation> InactiveAllocations { get; set; }

        public virtual DbSet<HeldReportedActualGroup> HeldReportedActualGroups { get; set; }

        public virtual DbSet<HeldFspCollectionConfig> HeldFspCollectionConfigs { get; set; }

        public virtual DbSet<AllocationUnderTermination> AllocationsUnderTermination { get; set; }

        public IDbSet<ClosedCollection> ClosedCollections { get; set; }

        public IDbSet<SummarisedActual> SummarisedActuals { get; set; }

        public IQueryable<AllocationDeliverablePeriod> ActiveAllocationDeliverablePeriods =>
            AllocationDeliverablePeriods.Where(adp => !InactiveAllocations.Select(ca => ca.ContractAllocationNumber).Contains(adp.ContractAllocationNumber));

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("MonitoringDeliverables");
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }

        private void SetDatabaseInitializer()
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersionWithTransactionSuppressInitializer<MonitoringDeliverablesDbContext, Configuration>());
            Configuration.ProxyCreationEnabled = false;   
        }
    }
}