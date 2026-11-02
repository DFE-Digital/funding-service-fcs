namespace OrganisationDomain.Integration.DataStore
{
    using System.Data;
    using System.Data.Common;
    using System.Data.Entity;
    using Migrations;
    using Model;
    using System.Data.Entity.ModelConfiguration.Conventions;

    public class OrganisationDomainDbContext : DbContext, IOrganisationDomainDbContext
    {
        public static string KeyVaultValue { get; set; }//This keyvalut value is set by the test framework when running in a test environment, and is used to override the connection string for the database context. This allows the tests to connect to a different database than the one used in production, which can be useful for testing purposes. The value is typically retrieved from Azure Key Vault, which is a secure storage service for secrets such as connection strings. By using this approach, the tests can be run without exposing sensitive information in the code or configuration files.
        public OrganisationDomainDbContext() : base(GetConnectionString())
        {
           Database.SetInitializer(new MigrateDatabaseToLatestVersionWithTransactionSuppressInitializer<OrganisationDomainDbContext, Configuration>());
        }


        public OrganisationDomainDbContext(IDbConnection connection)
            : base((DbConnection)connection, false)
        {
        }

        private static string GetConnectionString()
        {
            if (!string.IsNullOrWhiteSpace(KeyVaultValue))
            {
                return KeyVaultValue;
            }
            return "name=organisationDomainDatabase";
        }

        public virtual IDbSet<Organisation> Organisations { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("Organisation");
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }
    }
}
