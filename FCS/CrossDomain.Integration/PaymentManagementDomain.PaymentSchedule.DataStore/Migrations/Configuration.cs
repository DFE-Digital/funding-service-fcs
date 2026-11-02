namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;

    /// <summary>
    /// The db migration configuration
    /// </summary>
    internal sealed class Configuration : DbMigrationsConfiguration<PaymentSchedulePolicyContext>
    {
        /// <summary>
        /// Parameterless constructor for ensuring automatic migrations
        /// </summary>
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
            AutomaticMigrationDataLossAllowed = true;
            this.CommandTimeout = (int) TimeSpan.FromMinutes(5).TotalSeconds;
        }

        protected override void Seed(PaymentSchedulePolicyContext context)
        {
        }
    }
}
