namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.DataStore
{
    using System.Data.Entity;
    using System.Data.Entity.ModelConfiguration.Conventions;
    using Migrations;
    using Model;

    public class MonitoringDeliverablesDbContext : DbContext, IMonitoringDeliverablesDbContext
    {
        public MonitoringDeliverablesDbContext()   
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersionWithTransactionSuppressInitializer<MonitoringDeliverablesDbContext, Configuration>());
            Configuration.ProxyCreationEnabled = false;
        }


        public virtual IDbSet<FundingStreamPeriodDeliverable> FundingStreamPeriodDeliverables { get; set; }

        public virtual IDbSet<AllocationDeliverablePeriod> AllocationDeliverablePeriods { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("MonitoringDeliverables");
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }

    }
}
