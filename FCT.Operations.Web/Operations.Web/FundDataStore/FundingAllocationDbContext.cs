using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;

namespace Operations.Web.FundDataStore
{
    public partial class FundingAllocationDbContext : DbContext
    {
        public FundingAllocationDbContext()
            : base("name=ContractManagementDbContext")
        {
        }

        public FundingAllocationDbContext(string nameOrConnectionString) : base(nameOrConnectionString)
        {
        }

        public virtual DbSet<AllocationFundingStreamConfig> AllocationFundingStreamConfigs { get; set; }
        public virtual DbSet<AllocationLineConfig> AllocationLineConfigs { get; set; }
        public virtual DbSet<BulkUploadStatu> BulkUploadStatus { get; set; }
        public virtual DbSet<CfsCodesToContractTypeConfig> CfsCodesToContractTypeConfigs { get; set; }
        public virtual DbSet<Contract> Contracts { get; set; }
        public virtual DbSet<FeedRead> FeedReads { get; set; }
        public virtual DbSet<FspDeliverableConfig> FspDeliverableConfigs { get; set; }
        public virtual DbSet<FundingAllocation> FundingAllocations { get; set; }
        public virtual DbSet<FundingAllocationLine> FundingAllocationLines { get; set; }
        public virtual DbSet<FundingAllocationPageControl> FundingAllocationPageControls { get; set; }
        public virtual DbSet<FundingAllocationProfilePeriod> FundingAllocationProfilePeriods { get; set; }
        public virtual DbSet<FundingStreamPeriodConfig> FundingStreamPeriodConfigs { get; set; }
        public virtual DbSet<FundingTypeConfig> FundingTypeConfigs { get; set; }
        public virtual DbSet<FundingTypeFundingPeriodConfig> FundingTypeFundingPeriodConfigs { get; set; }
        public virtual DbSet<ParkingAndDiscardedInfo> ParkingAndDiscardedInfoes { get; set; }
        public virtual DbSet<ProcessedMessage> ProcessedMessages { get; set; }
        public virtual DbSet<ProviderCategoryException> ProviderCategoryExceptions { get; set; }
        public virtual DbSet<ProviderFunding> ProviderFundings { get; set; }
        public virtual DbSet<ProviderFundingAllocation> ProviderFundingAllocations { get; set; }
        public virtual DbSet<ProviderTypeConfig> ProviderTypeConfigs { get; set; }
        public virtual DbSet<ReleaseGroup> ReleaseGroups { get; set; }
        public virtual DbSet<ReleaseGroupGroup> ReleaseGroupGroups { get; set; }
        public virtual DbSet<StatusSubStatusConfig> StatusSubStatusConfigs { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<FspDeliverableConfig>()
                .HasMany(e => e.AllocationLineConfigs)
                .WithRequired(e => e.FspDeliverableConfig)
                .HasForeignKey(e => new { e.FspCode, e.DeliverableCode });

            modelBuilder.Entity<FundingAllocation>()
                .HasOptional(e => e.ParkingAndDiscardedInfo)
                .WithRequired(e => e.FundingAllocation)
                .WillCascadeOnDelete();

            modelBuilder.Entity<FundingAllocationLine>()
                .HasMany(e => e.FundingAllocationProfilePeriods)
                .WithRequired(e => e.FundingAllocationLine)
                .HasForeignKey(e => new { e.ProviderFundingId, e.FundingLineCode });

            modelBuilder.Entity<FundingAllocationPageControl>()
                .HasMany(e => e.FundingAllocations)
                .WithRequired(e => e.FundingAllocationPageControl)
                .HasForeignKey(e => new { e.ReadId, e.PageNumber });

            modelBuilder.Entity<ReleaseGroup>()
                .HasMany(e => e.FundingAllocations)
                .WithOptional(e => e.ReleaseGroup)
                .WillCascadeOnDelete();

            modelBuilder.Entity<StatusSubStatusConfig>()
                .HasMany(e => e.FundingAllocations)
                .WithOptional(e => e.StatusSubStatusConfig)
                .HasForeignKey(e => new { e.Status, e.SubStatus });
        }
    }
}
