namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System.Data.Entity.Migrations;

    internal sealed class Configuration : DbMigrationsConfiguration<MonitoringDeliverablesDbContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
            MigrationsDirectory = "DataStore\\Migrations";
            CommandTimeout = 300;
        }
    }
}
