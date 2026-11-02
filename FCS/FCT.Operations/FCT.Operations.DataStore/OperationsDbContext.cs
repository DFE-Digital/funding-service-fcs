namespace SFA.FCT.Operations.DataStore
{
    using System.Data;
    using System.Data.Common;
    using System.Data.Entity;
    using System.Data.Entity.ModelConfiguration.Conventions;
    using Model;

    public class OperationsDbContext : DbContext, IOperationsDbContext
    {
        public static string KeyVaultValue { get; set; }
        public OperationsDbContext() : base(GetConnectionString())
        {
        }

        public OperationsDbContext(IDbConnection connection)
            : base((DbConnection)connection, contextOwnsConnection: false)
        {
        }

        private static string GetConnectionString()
        {
            if (!string.IsNullOrWhiteSpace(KeyVaultValue))
            {
                return KeyVaultValue;
            }
            return "name=DocumentsDomainDbContext";
        }

        public IDbSet<ErrorMessageAction> ErrorMessageActions { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("Operations");
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }
    }
}
