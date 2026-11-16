namespace ContractManagement.DataStore
{
    using System.Data.Entity;
    using Model;
    using System.Data.Entity.ModelConfiguration.Conventions;
    using Migrations;
    using System.Data;
    using System.Data.Common;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ContractManagementDbContext : DbContext, IContractManagementDbContext
    {
        public static string KeyVaultValue { get; set; }

        public ContractManagementDbContext() : base(GetConnectionString())
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersion<ContractManagementDbContext, Configuration>());
        }

        private static string GetConnectionString()
        {
            if (!string.IsNullOrWhiteSpace(KeyVaultValue))
            {
                return KeyVaultValue;
            }
            return "name=ContractManagementDbContext";
        }


        public ContractManagementDbContext(IDbConnection connection)
            : base((DbConnection)connection, contextOwnsConnection: false)
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersion<ContractManagementDbContext, Configuration>());
        }

        public ContractManagementDbContext(ConnectionInfo connectionInfo)
            : this(connectionInfo.Connection, connectionInfo.Transaction)
        {
        }

        public ContractManagementDbContext(IDbConnection connection, DbTransaction transaction)
            : base((DbConnection)connection, contextOwnsConnection: false)
        {
            if (transaction != null)
            {
                this.Database.UseTransaction(transaction);
            }
        }

        public IDbSet<AtomFeedItem> AtomFeedItems { get; set; }

        public IDbSet<Model.IntegrityCheck> IntegrityCheckItems { get; set; }

        public IDbSet<FundingTypeFundingPeriod> FundingTypeFundingPeriodItems { get; set; }

        public IDbSet<MonthEndHistory> MonthEndHistories { get; set; }

        public IDbSet<EngagementEvent> EngagementEvents { get; set; }

        public IDbSet<FundingTypePeriodFundingStreamPeriod> FundingTypePeriodFundingStreamPeriodItems { get; set; }

        public IDbSet<CdaReportFundingStreamPeriod> CdaReportFundingStreamPeriods { get; set; }

        public IDbSet<CdaExtract> CdaExtracts { get; set; }

        public IDbSet<ApprovedContract> ApprovedContracts { get; set; }

        public IDbSet<ApprovedContractAllocation> ApprovedContractAllocations { get; set; }

        public IDbSet<ApprovedContractDeliverable> ApprovedContractDeliverables { get; set; }

        public IDbSet<RoatpProvider>  RoatpProviders { get; set; }

        public IDbSet<ProcessedMessage> ProcessedMessages { get; set; }

        public IDbSet<ContractType> ContractTypes { get; set; }

        public IDbSet<RegionType> RegionTypes { get; set; }

        public IDbSet<FundingStreamPeriodLegalDeliverable> FundingStreamPeriodLegalDeliverables { get; set; }

        public IDbSet<FundingTypeFundingPeriodContractType> FundingTypeFundingPeriodContractTypes { get; set; }

        public IDbSet<FundingStreamPeriod> FundingStreamPeriods { get; set; }

        public IDbSet<CreatedContract> CreatedContracts { get; set; }

        public IDbConnection Connection => Database.Connection;

        public int ExecuteSql(string sqlCommand)
        {
            return Database.ExecuteSqlCommand(sqlCommand);
        }

        public async Task<int> ExecuteSqlAsync(string sqlCommand)
        {
            return await Database.ExecuteSqlCommandAsync(sqlCommand);
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("ContractManagement");
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }
    }
}