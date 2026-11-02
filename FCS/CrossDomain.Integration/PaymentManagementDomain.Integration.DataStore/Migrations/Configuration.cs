namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System.Data.Entity.Migrations;

    /// <summary>
    /// The db migration configuration
    /// </summary>
    internal sealed class Configuration : DbMigrationsConfiguration<PaymentManagementPolicyContext>
    {
        /// <summary>
        /// Parameterless constructor for ensuring automatic migrations
        /// </summary>
        public Configuration()
        {
            this.AutomaticMigrationsEnabled = false;
            this.AutomaticMigrationDataLossAllowed = true;
        }
    }
}
