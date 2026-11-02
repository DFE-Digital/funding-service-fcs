namespace Operations.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    using System.Linq;
    using Model;

    internal sealed class Configuration : DbMigrationsConfiguration<Operations.DataStore.OperationsDbContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
            ContextKey = "Operations.DataStore.OperationsDbContext";
            int thirtyMinutes = 60 * 30;
            CommandTimeout = thirtyMinutes;
        }

        protected override void Seed(Operations.DataStore.OperationsDbContext dbContext)
        {
            if (!dbContext.IntegrityCheckChangeTrackingRows.Any(i =>
                i.Name == IntegrityCheckChangeTracking.PaasToCrmDeliverablePayment))
            {
                dbContext.IntegrityCheckChangeTrackingRows.AddOrUpdate(
                    new IntegrityCheckChangeTracking(IntegrityCheckChangeTracking.PaasToCrmDeliverablePayment));
            }
        }
    }
}
