namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    using SeedData;

    internal sealed class Configuration : DbMigrationsConfiguration<MonitoringDeliverablesDbContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = true;
            MigrationsDirectory = "DataStore\\Migrations";
        }

        protected override void Seed(MonitoringDeliverablesDbContext context)
        {
            context.FundingStreamPeriodDeliverables.AddOrUpdate(
                MonitoringDeliverablesSeedData.GetMonitoringDeliverables().ToArray());
        }
    }
}
