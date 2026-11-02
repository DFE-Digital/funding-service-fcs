namespace SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Migrations
{
    using System.Data.Entity.Migrations;

    /// <summary>
    /// The database migration configuration
    /// </summary>
    internal sealed class Configuration : DbMigrationsConfiguration<OverrideDateDBContext>
    {
        /// <summary>
        /// Parameter less constructor for ensuring automatic migrations
        /// </summary>
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
        }
    }
}
