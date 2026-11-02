namespace FundingAllocation.DataStore
{
    using System;
    using System.Data;
    using System.Data.Common;
    using Model;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.EntityFrameworkCore.Infrastructure;

    public class FundingAllocationContext : DbContext
    {
        public FundingAllocationContext(DbContextOptions<FundingAllocationContext> options) : base(options)
        {
        }

        public FundingAllocationContext()
        {
        }

        public DbSet<FundingAllocationPageControl> FundingAllocationPageControls { get; set; }

        public DbSet<Contract> Contracts { get; set; }

        public DbSet<FundingAllocation> FundingAllocations { get; set; }

        public DbSet<ParkingAndDiscardedInfo> ParkingAndDiscardedInfos { get; set; }

        public DbSet<StatusSubStatusConfig> StatusSubStatusConfig { get; set; }

        public DbSet<ProviderFundingAllocation> ProviderFundingAllocations { get; set; }

        public DbSet<FundingAllocationLine> FundingAllocationLines { get; set; }

        public DbSet<FundingAllocationProfilePeriod> FundingAllocationProfilePeriods { get; set; }

        public DbSet<ProcessedMessage> ProcessedMessages { get; set; }

        public DbSet<ProviderTypeConfig> ProviderTypeConfigRows { get; set; }

        public DbSet<ProviderCategoryException> ProviderCategoryExceptions { get; set; }

        public DbSet<AllocationLineConfig> AllocationLineConfigRows { get; set; }

        public DbSet<FspDeliverableConfig> FspDeliverableConfigRows { get; set; }

        public DbSet<AllocationFundingStreamConfig> AllocationFundingStreamConfigRows { get; set; }

        public DbSet<CfsCodesToContractTypeConfig> CfsCodesToContractTypeConfigRows { get; set; }

        public DbSet<FundingTypeConfig> FundingTypeConfigRows { get; set; }

        public DbSet<FundingStreamPeriodConfig> FundingStreamPeriodConfigRows { get; set; }

        public DbSet<ReleaseGroup> ReleaseGroups { get; set; }
        public DbSet<FeedRead> FeedReads { get; set; }
        public DbSet<ProviderFunding> ProviderFundings { get; set; }
        public DbSet<FundingTypeFundingPeriodConfig> FundingTypeFundingPeriodConfigRows { get; set; }
        public DbSet<BulkUploadStatus> BulkUploadStatuses { get; set; }
        public DbSet<ReleaseGroupGroup> ReleaseGroupGroups { get; set; }

        public IDbTransaction CurrentTransaction =>
            ((IInfrastructure<DbTransaction>) Database.CurrentTransaction)?.Instance;

        protected override void OnConfiguring(DbContextOptionsBuilder options)
        {
            options.UseSqlServer(o => o.MigrationsHistoryTable("__EFMigrationsHistory", "FundingAllocation"));
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("FundingAllocation");

            modelBuilder.Entity<FundingAllocationPageControl>().HasKey(fapc => new { fapc.ReadId, fapc.PageNumber });
            modelBuilder.Entity<FundingAllocationPageControl>().Property(fapc => fapc.LatestBookmarkOnPage).HasColumnType("nvarchar").HasMaxLength(100);
            modelBuilder.Entity<FundingAllocationPageControl>()
                .HasOne(fa => fa.FeedRead)
                .WithMany(fapc => fapc.FundingAllocationPageControls)
                .HasForeignKey(fa => fa.ReadId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<FundingAllocation>().HasKey(fa => new { fa.FundingId });
            modelBuilder.Entity<FundingAllocation>().Property(fa => fa.FundingId).HasColumnType("nvarchar").HasMaxLength(200).IsRequired();
            modelBuilder.Entity<FundingAllocation>().Property(fa => fa.FundingVersion).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<FundingAllocation>().Property(fa => fa.Period).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<FundingAllocation>().Property(fa => fa.AllocationFundingStream).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<FundingAllocation>().Property(fa => fa.UKPRN).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<FundingAllocation>().Property(fa => fa.Value).HasColumnType("decimal(18,2)").IsRequired();
            modelBuilder.Entity<FundingAllocation>().HasIndex(fa => fa.PageNumber);
            modelBuilder.Entity<FundingAllocation>().Property(fa => fa.PageNumber).HasColumnType("int").IsRequired();
            modelBuilder.Entity<FundingAllocation>().Property(fa => fa.PositionInPage).HasColumnType("int").IsRequired();
            modelBuilder.Entity<FundingAllocation>().Property(fa => fa.ProviderFundingCount).HasColumnType("int").IsRequired();
            modelBuilder.Entity<FundingAllocation>().Property(fa => fa.ReadId).HasColumnType("int").IsRequired();
            modelBuilder.Entity<FundingAllocation>().Property(fa => fa.Status).HasColumnType("nvarchar").HasMaxLength(50).IsRequired(false);
            modelBuilder.Entity<FundingAllocation>().Ignore(fa => fa.FundingAllocationStatus);
            modelBuilder.Entity<FundingAllocation>().Property(fa => fa.FundingAllocationName).HasColumnType("nvarchar").HasMaxLength(200).IsRequired();
            modelBuilder.Entity<FundingAllocation>().HasIndex(fa => fa.FundingAllocationName);
            modelBuilder.Entity<FundingAllocation>().Property(fa => fa.SubStatus).HasColumnType("nvarchar").HasMaxLength(50).IsRequired(false);
            modelBuilder.Entity<FundingAllocation>().Ignore(fa => fa.FundingAllocationSubStatus);
            modelBuilder.Entity<FundingAllocation>().HasIndex(fa => new { fa.Status, fa.SubStatus });
            modelBuilder.Entity<FundingAllocation>()
                .HasOne(fa => fa.Contract)
                .WithMany(c => c.FundingAllocations)
                .HasForeignKey(fa => fa.ContractId)
                .OnDelete(DeleteBehavior.NoAction);
            modelBuilder.Entity<FundingAllocation>()
                .HasOne(fa => fa.ReleaseGroup)
                .WithMany(rg => rg.FundingAllocations)
                .HasForeignKey(fa => fa.ReleaseGroupId)
                .OnDelete(DeleteBehavior.Cascade);
            modelBuilder.Entity<FundingAllocation>()
                .HasOne(fa => fa.FundingAllocationPageControl)
                .WithMany(fapc=> fapc.FundingAllocations)
                .HasForeignKey(fa => new { fa.ReadId, fa.PageNumber })
                .OnDelete(DeleteBehavior.Cascade);
            modelBuilder.Entity<FundingAllocation>()
                .HasOne<StatusSubStatusConfig>()
                .WithMany()
                .HasForeignKey(fa => new { fa.Status, fa.SubStatus })
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<ParkingAndDiscardedInfo>().Property(pi => pi.LastParked).HasColumnType("datetime").IsRequired(false);
            modelBuilder.Entity<ParkingAndDiscardedInfo>().Property(pi => pi.LastDiscarded).HasColumnType("datetime").IsRequired(false);
            modelBuilder.Entity<ParkingAndDiscardedInfo>().HasKey(pi => pi.FundingAllocationId);
            modelBuilder.Entity<ParkingAndDiscardedInfo>()
                .Property<DateTime>("CreatedDate")
                .HasDefaultValueSql("GETUTCDATE()");

            modelBuilder.Entity<ParkingAndDiscardedInfo>()
                .HasOne<FundingAllocation>()
                .WithOne(fa => fa.ParkingAndDiscardedInfo)
                .HasForeignKey<ParkingAndDiscardedInfo>(pi => pi.FundingAllocationId);

            modelBuilder.Entity<StatusSubStatusConfig>().Property(ssc => ssc.Status).HasColumnType("nvarchar").HasMaxLength(50);
            modelBuilder.Entity<StatusSubStatusConfig>().Property(ssc => ssc.SubStatus).HasColumnType("nvarchar").HasMaxLength(50);
            modelBuilder.Entity<StatusSubStatusConfig>().HasKey(ssc => new {ssc.Status, ssc.SubStatus});

            modelBuilder.Entity<ProviderFundingAllocation>().HasKey(pfa => new {pfa.ProviderFundingId, pfa.FundingId});
            modelBuilder.Entity<ProviderFundingAllocation>().Property(pfa => pfa.ProviderFundingId).HasColumnType("nvarchar").HasMaxLength(100).IsRequired();
            modelBuilder.Entity<ProviderFundingAllocation>().Property(pfa => pfa.FundingId).HasColumnType("nvarchar").HasMaxLength(200).IsRequired();
            
            modelBuilder.Entity<ProviderFundingAllocation>()
                .HasOne(pfa => pfa.FundingAllocation)
                .WithMany(fa => fa.ProviderFundingAllocations)
                .HasForeignKey(pfa => pfa.FundingId);
            modelBuilder.Entity<ProviderFundingAllocation>()
                .HasOne(pfa => pfa.ProviderFunding)
                .WithMany(pf => pf.ProviderFundingAllocations)
                .HasForeignKey(pf => pf.ProviderFundingId);

            modelBuilder.Entity<ProviderFunding>().HasKey(pf => pf.ProviderFundingId);
            modelBuilder.Entity<ProviderFunding>().Property(pfa => pfa.ProviderFundingId).HasColumnType("nvarchar").HasMaxLength(100).IsRequired();
            modelBuilder.Entity<ProviderFunding>().Property(pfa => pfa.DeliveryUkprn).HasColumnType("int").IsRequired();
            modelBuilder.Entity<ProviderFunding>().Property(pfa => pfa.ProviderType).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<ProviderFunding>().Property(pfa => pfa.ProviderSubType).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();

            modelBuilder.Entity<FundingAllocationLine>().HasKey(fal => new { fal.ProviderFundingId, fal.FundingLineCode });
            modelBuilder.Entity<FundingAllocationLine>().Property(fal => fal.ProviderFundingId).HasColumnType("nvarchar").HasMaxLength(100).IsRequired();
            modelBuilder.Entity<FundingAllocationLine>().Property(fal => fal.FundingLineCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<FundingAllocationLine>()
                .HasOne(fal => fal.ProviderFunding)
                .WithMany(fal => fal.FundingAllocationLines)
                .HasForeignKey(fal => fal.ProviderFundingId);
            modelBuilder.Entity<FundingAllocationLine>().Ignore(fal => fal.NonZeroFundingAllocationProfilePeriods);
            modelBuilder.Entity<FundingAllocationLine>().Property(fa => fa.IsOfNoInterest).HasColumnType("bit").IsRequired().HasDefaultValue(false);

            modelBuilder.Entity<FundingAllocationProfilePeriod>().HasKey(pp => new { pp.ProviderFundingId, pp.FundingLineCode, pp.Period });
            modelBuilder.Entity<FundingAllocationProfilePeriod>().Property(pp => pp.ProviderFundingId).HasColumnType("nvarchar").HasMaxLength(100).IsRequired();
            modelBuilder.Entity<FundingAllocationProfilePeriod>().Property(pp => pp.FundingLineCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<FundingAllocationProfilePeriod>().Property(pp => pp.Period).HasColumnType("int").IsRequired();
            modelBuilder.Entity<FundingAllocationProfilePeriod>().Property(pp => pp.PlannedValue).HasColumnType("decimal").HasPrecision(18, 2).IsRequired();
            modelBuilder.Entity<FundingAllocationProfilePeriod>()
                .HasOne(pp => pp.FundingAllocationLine)
                .WithMany(fal => fal.FundingAllocationProfilePeriods)
                .HasForeignKey(pp => new { pp.ProviderFundingId, pp.FundingLineCode });

            modelBuilder.Entity<Contract>(c =>
            {
                c.HasKey(e => e.Id);
                c.Property(e => e.Id).ValueGeneratedOnAdd();
                c.HasIndex(e => new { e.ContractNumber, e.ContractVersionNumber, e.ContractSubVersionNumber, e.RelationshipToFundingAllocation }).IsUnique();
            });
            modelBuilder.Entity<Contract>().Property(fa => fa.ContractNumber).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<Contract>().Property(fa => fa.RelationshipToFundingAllocation).HasDefaultValue("Created").HasColumnType("nvarchar").HasMaxLength(20).IsRequired();
            modelBuilder.Entity<Contract>().Ignore(c => c.RelationshipToFundingAllocationEnum);
            modelBuilder.Entity<ProcessedMessage>(pm =>
            {
                pm.HasKey(e => e.MessageId);
                pm.HasIndex(e => new { e.Endpoint, e.MessageType, e.BusinessKey }).IsUnique();
            });
            modelBuilder.Entity<ProcessedMessage>().Property(pm => pm.MessageId).HasColumnType("nvarchar").HasMaxLength(128).IsRequired();
            modelBuilder.Entity<ProcessedMessage>().Property(pm => pm.Endpoint).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<ProcessedMessage>().Property(pm => pm.MessageType).HasColumnType("nvarchar").HasMaxLength(100).IsRequired();
            modelBuilder.Entity<ProcessedMessage>().Property(pm => pm.BusinessKey).HasColumnType("nvarchar").HasMaxLength(200).IsRequired();

            modelBuilder.Entity<ProviderTypeConfig>().HasKey(ptc => new { ptc.Type, ptc.Subtype });
            modelBuilder.Entity<ProviderTypeConfig>().Property(ptc => ptc.Type).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<ProviderTypeConfig>().Property(ptc => ptc.Subtype).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<ProviderTypeConfig>().Property(ptc => ptc.Category).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();

            modelBuilder.Entity<AllocationLineConfig>().HasKey(alc => new { alc.FundingStreamCode, alc.PeriodId, alc.FundingLineCode, alc.ProviderCategory });
            modelBuilder.Entity<AllocationLineConfig>().Property(alc => alc.FundingStreamCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<AllocationLineConfig>().Property(alc => alc.PeriodId).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<AllocationLineConfig>().Property(alc => alc.FundingLineCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<AllocationLineConfig>().Property(alc => alc.ProviderCategory).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<AllocationLineConfig>().Property(alc => alc.FspCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<AllocationLineConfig>().Property(alc => alc.DeliverableCode).IsRequired();
            modelBuilder.Entity<AllocationLineConfig>()
                .HasOne(alc => alc.FspDeliverableConfig)
                .WithMany(fspD => fspD.AllocationLineConfigs)
                .HasForeignKey(alc => new {alc.FspCode, alc.DeliverableCode});

            modelBuilder.Entity<FspDeliverableConfig>().HasKey(d  => new { d.FspCode, d.DeliverableCode });
            modelBuilder.Entity<FspDeliverableConfig>().Property(d => d.FspCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<FspDeliverableConfig>().Property(d => d.DeliverableCode).HasColumnType("int").IsRequired();
            modelBuilder.Entity<FspDeliverableConfig>().Property(d => d.DeliverableName).HasColumnType("nvarchar").HasMaxLength(100).IsRequired();
            modelBuilder.Entity<FspDeliverableConfig>().Property(d => d.DisplayOrder).HasColumnType("int").IsRequired();

            modelBuilder.Entity<AllocationFundingStreamConfig>().HasKey(afsc => new { afsc.AllocationFundingStreamCode, afsc.AllocationPeriodId });
            modelBuilder.Entity<AllocationFundingStreamConfig>().Property(afsc => afsc.AllocationFundingStreamCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<AllocationFundingStreamConfig>().Property(afsc => afsc.AllocationPeriodId).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<AllocationFundingStreamConfig>().Property(afsc => afsc.FundingTypeCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<AllocationFundingStreamConfig>().Property(afsc => afsc.FundingPeriodCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<AllocationFundingStreamConfig>().Property(afsc => afsc.FSPGroupCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();

            modelBuilder.Entity<CfsCodesToContractTypeConfig>().HasKey(cctctc => new { cctctc.FundingTypeCode, cctctc.FundingPeriodCode, cctctc.ProviderCategory });
            modelBuilder.Entity<CfsCodesToContractTypeConfig>().Property(cctctc => cctctc.FundingTypeCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<CfsCodesToContractTypeConfig>().Property(cctctc => cctctc.FundingPeriodCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<CfsCodesToContractTypeConfig>().Property(cctctc => cctctc.ProviderCategory).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<CfsCodesToContractTypeConfig>().Property(cctctc => cctctc.ContractType).HasColumnType("nvarchar").HasMaxLength(100).IsRequired();

            modelBuilder.Entity<FundingTypeConfig>().HasKey(ftc => new { ftc.FundingTypeCode });
            modelBuilder.Entity<FundingTypeConfig>().Property(ftc => ftc.FundingTypeCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<FundingTypeConfig>().Property(ftc => ftc.ContractReferencePrefix).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();

            modelBuilder.Entity<FundingStreamPeriodConfig>().HasKey(fspc => new { fspc.FundingStreamPeriodCode });
            modelBuilder.Entity<FundingStreamPeriodConfig>().Property(fspc => fspc.FundingStreamPeriodCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<FundingStreamPeriodConfig>().Property(fspc => fspc.FundingStreamCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<FundingStreamPeriodConfig>().Property(fspc => fspc.AllocationReferencePrefix).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<FundingStreamPeriodConfig>().Property(fspc => fspc.StartDate).HasColumnType("datetime").IsRequired();
            modelBuilder.Entity<FundingStreamPeriodConfig>().Property(fspc => fspc.EndDate).HasColumnType("datetime").IsRequired();

            modelBuilder.Entity<FundingTypeFundingPeriodConfig>().HasKey(ftfpc => new { ftfpc.FundingTypeCode, ftfpc.FundingPeriod });
            modelBuilder.Entity<FundingTypeFundingPeriodConfig>().Property(ftfpc => ftfpc.FundingTypeCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<FundingTypeFundingPeriodConfig>().Property(ftfpc => ftfpc.FundingPeriod).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<FundingTypeFundingPeriodConfig>().Property(ftfpc => ftfpc.FtpGroupCode).HasColumnType("nvarchar").HasMaxLength(50);
            modelBuilder.Entity<FundingTypeFundingPeriodConfig>().Property(ftfpc => ftfpc.PrecedingFtpFundingType).HasColumnType("nvarchar").HasMaxLength(50);
            modelBuilder.Entity<FundingTypeFundingPeriodConfig>().Property(ftfpc => ftfpc.PrecedingFtpFundingPeriod).HasColumnType("nvarchar").HasMaxLength(50);

            modelBuilder.Entity<ReleaseGroup>(rg =>
            {
                rg.HasKey(e => e.Id);
                rg.Property(e => e.Id).ValueGeneratedOnAdd();
                rg.HasIndex(e => new { e.ReleaseGroupName }).IsUnique();
                rg.HasIndex(e => new { e.FundingTypeCode, e.FundingPeriodCode, e.FSPGroupCode, e.ContractType, e.Status, e.ReleasedDate })
                    .IsUnique()
                    .HasFilter("[ReleasedDate] IS NULL");
            });
            modelBuilder.Entity<ReleaseGroup>().Property(rg => rg.FundingTypeCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<ReleaseGroup>().Property(rg => rg.FundingPeriodCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<ReleaseGroup>().Property(rg => rg.FSPGroupCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<ReleaseGroup>().Property(rg => rg.ContractType).HasColumnType("nvarchar").HasMaxLength(100).IsRequired();
            modelBuilder.Entity<ReleaseGroup>().Property(rg => rg.ReleaseGroupName).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<ReleaseGroup>().Property(rg => rg.Status).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<ReleaseGroup>().Ignore(rg => rg.ReleaseGroupStatus);

            modelBuilder.Entity<FeedRead>().HasKey(r => new { r.ReadId });
            modelBuilder.Entity<FeedRead>().Property(r => r.CfsReadCompletedDate).HasColumnType("datetime");
            modelBuilder.Entity<FeedRead>().Property(r => r.JobCompletedDate).HasColumnType("datetime");

            modelBuilder.Entity<ProviderCategoryException>().HasKey(pce => new {pce.FundingTypeCode, pce.FundingPeriodCode, pce.UKPRN});
            modelBuilder.Entity<ProviderCategoryException>().Property(pce => pce.FundingTypeCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<ProviderCategoryException>().Property(pce => pce.UKPRN).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<ProviderCategoryException>().Property(pce => pce.FundingPeriodCode).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();
            modelBuilder.Entity<ProviderCategoryException>().Property(pce => pce.Category).HasColumnType("nvarchar").HasMaxLength(50).IsRequired();

            modelBuilder.Entity<BulkUploadStatus>(bus =>
            {
                bus.HasKey(e => e.BulkUploadBatchId);
                // bus.Property(e => e.BulkUploadBatchId).ValueGeneratedOnAdd();
                bus.HasIndex(e => new { e.FundingTypeCode, e.FundingPeriodName });
            });

            modelBuilder.Entity<BulkUploadStatus>().Property(bus => bus.BulkUploadBatchId).HasColumnType("UniqueIdentifier").IsRequired();
            modelBuilder.Entity<BulkUploadStatus>().Property(bus => bus.FundingTypeCode).HasColumnType("nvarchar").HasMaxLength(100).IsRequired();
            modelBuilder.Entity<BulkUploadStatus>().Property(bus => bus.FundingPeriodName).HasColumnType("nvarchar").HasMaxLength(100).IsRequired();
            modelBuilder.Entity<BulkUploadStatus>().Property(bus => bus.Status).HasColumnType("nvarchar").HasMaxLength(100).IsRequired();
            modelBuilder.Entity<BulkUploadStatus>().Ignore(c => c.BulkUploadProgressStatus);

            modelBuilder.Entity<ReleaseGroupGroup>().HasKey(rgg => new { rgg.ReleaseGroupGroupId, rgg.ReleaseGroupId  });
            modelBuilder.Entity<ReleaseGroupGroup>().Property(rgg => rgg.ReleaseGroupGroupId).HasColumnType("int").IsRequired();
            modelBuilder.Entity<ReleaseGroupGroup>().Property(rgg => rgg.ReleaseGroupId).HasColumnType("int").IsRequired();
            
            modelBuilder.RemovePluralizingTableNameConvention();
        }
    }
}