namespace SFA.FCT.DocumentsDomain.DataStore
{
    using System.Data;
    using System.Data.Common;
    using System.Data.Entity;
    using System.Data.Entity.ModelConfiguration.Conventions;
    using CrossDomain.Integration.Entities.Data;
    using Models;

    public class DocumentsDomainDbContext : DbContext
    {
        public static string KeyVaultValue { get; set; }
        public DocumentsDomainDbContext() : base(GetConnectionString())
        {
        }

        public DocumentsDomainDbContext(IDbConnection connection)
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

        public DocumentsDomainDbContext(ConnectionInfo connectionInfo)
            : this(connectionInfo.Connection, connectionInfo.Transaction)
        {
        }

        public DocumentsDomainDbContext(IDbConnection connection, DbTransaction transaction)
            : base((DbConnection)connection, contextOwnsConnection: false)
        {
            if (transaction != null)
            {
                this.Database.UseTransaction(transaction);
            }
        }

        public IDbSet<FundingStreamPeriod> FundingStreamPeriods { get; set; }

        public IDbSet<FSPDeliverable> FSPDeliverables { get; set; }

        public IDbSet<FspGroupDocumentTemplate> FspGroupDocumentTemplates { get; set; }

        public IDbSet<ContractDocumentTemplate> ContractDocumentTemplates { get; set; }

        public IDbSet<ArchivedDocument> ArchivedDocuments { get; set; }

        public IDbSet<FSPGroup> FSPGroups { get; set; }

        public IDbSet<FundingTypeFundingPeriod> FundingTypeFundingPeriods { get; set; }

        public IDbSet<NlapFundingConfig> NlapFundingConfigs { get; set; }

        public IDbSet<UploadedDocumentTemplate> UploadedDocumentTemplates{ get; set; }

        public IDbSet<ProcessedMessage> ProcessedMessages { get; set; }

        public IDbSet<ContractReferenceConfig> ContractReferenceConfigs { get; set; }

        public int ExecuteSql(string sqlCommand)
        {
            return Database.ExecuteSqlCommand(sqlCommand);
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("DocumentsDomain");
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }
    }
}
