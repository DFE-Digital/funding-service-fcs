namespace SFA.FCT.PMD.PaymentManagment.DataStore.Migrations
{
    using System.Data.Entity.Migrations;

    /// <summary>
    /// The db migration configuration
    /// </summary>
    internal sealed class Configuration : DbMigrationsConfiguration<PaymentManagementDBContext>
    {
        /// <summary>
        /// Parameterless constructor for ensuring automatic migrations
        /// </summary>
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
        }
    }
}
