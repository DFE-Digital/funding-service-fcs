namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;   

    internal sealed class Configuration : DbMigrationsConfiguration<SFA.FCT.DocumentsDomain.DataStore.DocumentsDomainDbContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
            ContextKey = "DocumentsDomain.DataStore.DocumentsDomainDbContext";
        }

        protected override void Seed(SFA.FCT.DocumentsDomain.DataStore.DocumentsDomainDbContext context)
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
