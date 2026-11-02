namespace SFA.FCT.CrossDomain.Integration.OverrideDate
{
    using System.Data;
    using System.Data.Common;
    using System.Data.Entity;
    using System.Data.Entity.ModelConfiguration.Conventions;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Migrations;

    public class OverrideDateDBContext : DbContext, IOverrideDateDBContext
    {
        public static string KeyVaultValue { get; set; } = string.Empty;

        public OverrideDateDBContext() : base(GetConnectionString())
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersionWithTransactionSuppressInitializer<OverrideDateDBContext, Configuration>());
        }

        public OverrideDateDBContext(IDbConnection connection)
            : base((DbConnection) connection, false)
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersionWithTransactionSuppressInitializer<OverrideDateDBContext, Configuration>());
        }

        private static string GetConnectionString()
        {
            if (!string.IsNullOrWhiteSpace(KeyVaultValue))
            {
                return KeyVaultValue;
            }
            return "name=OverrideDateDBContext";
        }


        public OverrideDateDBContext(IDbConnection connection, DbTransaction transaction)
            : base((DbConnection)connection, contextOwnsConnection: false)
        {
            if (transaction != null)
            {
                Database.UseTransaction(transaction);
            }
        }

        public virtual IDbSet<DataStore.Model.OverrideDate> OverrideDate { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("OverrideDate");
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }
    }
}
