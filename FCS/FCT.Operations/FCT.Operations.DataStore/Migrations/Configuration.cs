namespace SFA.FCT.Operations.DataStore.Migrations
{
    using System.Data.Entity.Migrations;

    /// <summary>
    /// The db migration configuration
    /// </summary>
    internal sealed class Configuration : DbMigrationsConfiguration<OperationsDbContext>
    {
        /// <summary>
        /// Parameterless constructor for ensuring automatic migrations
        /// </summary>
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
            ContextKey = "FCT.Operations.DataStore.OperationsDbContext";
        }

        protected override void Seed(OperationsDbContext context)
        {
            //  This method will be called after migrating to the latest version.

            //  You can use the DbSet<T>.AddOrUpdate() helper extension method 
            //  to avoid creating duplicate seed data. E.g.
            //
            //    context.People.AddOrUpdate(
            //      p => p.FullName,
            //      new Person { FullName = "Andrew Peters" },
            //      new Person { FullName = "Brice Lambson" },
            //      new Person { FullName = "Rowan Miller" }
            //    );
            //
        }

    }
}
