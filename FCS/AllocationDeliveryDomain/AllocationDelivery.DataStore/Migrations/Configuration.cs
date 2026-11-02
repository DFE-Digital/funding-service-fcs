using System.Data.Entity.Migrations;

namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    /// <summary>
    /// The db migration configuration
    /// </summary>
    internal sealed class Configuration : DbMigrationsConfiguration<AllocationDeliveryDbContext>
    {
        /// <summary>
        /// Parameterless constructor for ensuring automatic migrations
        /// </summary>
        public Configuration()
        {
            this.AutomaticMigrationsEnabled = false;
            this.AutomaticMigrationDataLossAllowed = false;
        }

    }
}
