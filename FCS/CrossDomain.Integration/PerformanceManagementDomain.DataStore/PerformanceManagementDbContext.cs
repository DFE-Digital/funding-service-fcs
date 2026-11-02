namespace SFA.FCT.PerformanceManagementDomain.DataStore
{
    using CrossDomain.Integration.Entities.Data;
    using Models;
    using Models.Allocation;
    using System;
    using System.Configuration;
    using System.Data;
    using System.Data.Common;
    using System.Data.Entity;
    using System.Data.Entity.ModelConfiguration.Conventions;
    using System.Linq;

    public class PerformanceManagementDbContext : DbContext, IPerformanceManagementDbContext
    {
        public static string KeyVaultValue { get; set; }

        // ✅ Used by DI (Web App)
        public PerformanceManagementDbContext(IDbConnection connection)
            : base((DbConnection)connection, contextOwnsConnection: false)
        {
        }

        // ✅ Used ONLY by tests (fallback)
        public PerformanceManagementDbContext()
            : base(GetConnectionString())
        {
        }

        private static string GetConnectionString()
        {
            try
            {
                var kvValue = System.Configuration.ConfigurationManager
                    .ConnectionStrings["PerformanceManagementDbContext"]?.ConnectionString;

                if (!string.IsNullOrWhiteSpace(kvValue))
                {
                    return kvValue;
                }

                // ✅ detect Azure environment
                var isAzure = !string.IsNullOrEmpty(
                    Environment.GetEnvironmentVariable("WEBSITE_SITE_NAME"));

                if (isAzure)
                {
                    // ✅ CRITICAL: do NOT return "name=..."
                    return "Server=(local);Database=DummyDb;Trusted_Connection=True;";
                }

                // ✅ local fallback
                return "Server=(localdb)\\MSSQLLocalDB;Database=TestDb;Trusted_Connection=True;";
            }
            catch
            {
                return "Server=(local);Database=DummyDb;Trusted_Connection=True;";
            }
        }



        public PerformanceManagementDbContext(IDbConnection connection, DbTransaction transaction)
            : base((DbConnection)connection, contextOwnsConnection: false)
        {
            if (transaction != null)
            {
                this.Database.UseTransaction(transaction);
            }
        }

        public PerformanceManagementDbContext(ConnectionInfo connectionInfo)
            : this(connectionInfo.Connection, connectionInfo.Transaction)
        {
        }

        public IDbSet<ClaimType> ClaimTypes { get; set; }

        public IDbSet<ClaimCollection> ClaimCollections { get; set; }

        public IDbSet<ClaimReconciliationAllocationGroup> ClaimReconciliationAllocationGroups { get; set; }

        public IDbSet<ClaimReconciliationAllocationGroupFsp> ClaimReconciliationAllocationGroupFsps { get; set; }

        public IDbSet<ClaimReconciliationDeliverableGroup> ClaimReconciliationDeliverableGroups { get; set; }

        public IDbSet<ClaimReconciliationReferenceDataProfile> ClaimReconciliationReferenceDataProfiles { get; set; }

        public IDbSet<ClaimReconciliationBehaviour> ClaimReconciliationBehaviours { get; set; }

        public IDbSet<ClaimReconciliationPublicationException> ClaimReconciliationPublicationExceptions { get; set; }

        public IDbSet<FspDeliverableClaim> FspDeliverableClaims { get; set; }

        public DbSet<FundingClaim> FundingClaims { get; set; }

        public IQueryable<FundingClaim> FundingClaimsWithAllocations => FundingClaims
            .AsNoTracking()
            .Include(fc => fc.Allocations)
            .Where(fc => fc.Allocations.Any());

        public IDbSet<FundingClaimContractAllocation> FundingClaimContractAllocations { get; set; }

        public IDbSet<FundingClaimDeliverable> FundingClaimDeliverables { get; set; }

        public IDbSet<FundingClaimCollectionImportInfo> FundingClaimCollectionImportInfos { get; set; }

        public DbSet<ContractAllocationDeliverable> ContractAllocationDeliverables { get; set; }

        public IDbSet<ContractAllocation> ContractAllocations { get; set; }

        public IDbSet<AtomFeedItem> AtomFeedItems { get; set; }

        public IDbSet<FundingStreamPeriod> FundingStreamPeriods { get; set; }

        public IDbSet<ClaimReconciliationReferenceDataReconProfiling> ClaimReconciliationReferenceDataReconProfilings { get; set; }

        public int ExecuteSqlCommand(string sql, params object[] parameters)
        {
            return Database.ExecuteSqlCommand(sql, parameters);
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("PerformanceManagement");
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }
    }
}
