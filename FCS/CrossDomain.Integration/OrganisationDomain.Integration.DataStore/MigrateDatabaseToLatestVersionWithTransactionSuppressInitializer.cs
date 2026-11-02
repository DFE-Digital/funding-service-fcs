namespace OrganisationDomain.Integration.DataStore
{
    using System.Data.Entity;
    using System.Data.Entity.Migrations;
    using System.Transactions;

    public class MigrateDatabaseToLatestVersionWithTransactionSuppressInitializer<TContext, TMigrationsConfiguration> :
        MigrateDatabaseToLatestVersion<TContext, TMigrationsConfiguration>,
        IDatabaseInitializer<TContext>
        where TContext : DbContext
        where TMigrationsConfiguration : DbMigrationsConfiguration<TContext>, new()
    {
        public new void InitializeDatabase(TContext context)
        {
            using (var tran = new TransactionScope(TransactionScopeOption.Suppress))
            {
                base.InitializeDatabase(context);
            }
        }
    }
}
