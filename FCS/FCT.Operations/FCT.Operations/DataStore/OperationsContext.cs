namespace FCT.Operations.DataStore
{
    using Model;
    using Microsoft.EntityFrameworkCore;

    public class OperationsContext : DbContext
    {
        public OperationsContext()
        {
        }

        public OperationsContext(DbContextOptions<OperationsContext> options) : base(options)
        {
        }

        public virtual DbSet<AuditMessage> AuditMessages { get; set; }
        public virtual DbSet<DataFixHistory> DataFixHistories { get; set; }
        public virtual DbSet<DeployedConfigVersion> DeployedConfigVersions { get; set; }
        public virtual DbSet<DuplicateContract> DuplicateContracts { get; set; }
        public virtual DbSet<Session> Sessions { get; set; }
        public virtual DbSet<ProcessedMessage> ProcessedMessages { get; set; }
        public virtual DbSet<IntegrityCheckChangeTracking> IntegrityCheckChangeTrackings { get; set; }
        public virtual DbSet<FundingReportFSP> FundingReportFsps { get; set; }
        public virtual DbSet<FundingReportProvider> FundingReportProviders { get; set; }
        public DbSet<LaFundingReportProvider> LaFundingReportProviders { get; set; }
        public virtual DbSet<FundingStreamPeriod> FundingStreamPeriods { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder options)
        {
            options.UseSqlServer(o => o.MigrationsHistoryTable("__EFMigrationsHistory", "Operations"));
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("Operations");
            modelBuilder.HasAnnotation("Relational:Collation", "SQL_Latin1_General_CP1_CI_AS");

            modelBuilder.Entity<AuditMessage>(entity =>
            {
                entity.HasKey(e => new { e.MessageId, e.ProcessingEndpoint }).HasName("PK_Operations.AuditMessage");
                entity.ToTable("AuditMessage");
                entity.HasIndex(e => e.MessageType, "IX_AuditMessage_MessageType");
                entity.Property(e => e.ProcessingEndpoint).HasMaxLength(100);
                entity.Property(e => e.BusinessKey).IsRequired().HasMaxLength(80);
                entity.Property(e => e.MessageBytes).IsRequired();
                entity.Property(e => e.MessageType).IsRequired().HasMaxLength(120);
                entity.Property(e => e.OriginatingEndpoint).IsRequired().HasMaxLength(100);
                entity.Property(e => e.PropertiesBytes).IsRequired();
                entity.Property(e => e.SentTime).HasColumnType("datetime");
                entity.Property(e => e.CreatedDate).HasColumnType("datetime").HasDefaultValueSql("(getutcdate())");
                entity.HasIndex(e => e.CreatedDate).IsClustered(false).HasDatabaseName("IX_AUDITMESSAGE_CREATED_DATE");
            });

            modelBuilder.Entity<DataFixHistory>(entity =>
            {
                entity.HasKey(e => new { e.Id }).HasName("PK_Operations.DataFixHistory");
                entity.ToTable("DataFixHistory");
                entity.HasIndex(e => new { e.Release, e.StoryNumber, e.Name }, "IX_DataFixHistory_ReleaseStoryNumberName").IsUnique();
                entity.Property(e => e.Name).IsRequired().HasMaxLength(100);
                entity.Property(e => e.Release).IsRequired().HasMaxLength(10);
            });
            
            modelBuilder.Entity<DeployedConfigVersion>(entity =>
            {
                entity.HasKey(e => new { e.Id }).HasName("PK_Operations.DeployedConfigVersion");
                entity.ToTable("DeployedConfigVersion");
                entity.Property(e => e.Checksum).IsRequired().HasMaxLength(16);
                entity.Property(e => e.Version).IsRequired().HasMaxLength(30);
            });

            modelBuilder.Entity<DuplicateContract>(entity =>
            {
                entity.HasKey(e => new { e.ContractNumber, e.Version, e.SubVersion }).HasName("PK_Operations.DuplicateContract");
                entity.ToTable("DuplicateContract");
                entity.Property(e => e.ContractNumber).HasMaxLength(30);
                entity.Property(e => e.NumDuplicateAllocations).IsRequired().HasDefaultValue(0); 
                entity.Property(e => e.NumDuplicateContracts).IsRequired().HasDefaultValue(0);
            });

            modelBuilder.Entity<Session>(entity =>
            {
                entity.HasKey(e => e.Identifier).HasName("PK_Operations.Session");
                entity.ToTable("Session");
                entity.Property(e => e.Identifier).ValueGeneratedNever();
                entity.Property(e => e.CreatedDate).HasColumnType("datetime").HasDefaultValueSql("(getutcdate())");
            });

            modelBuilder.Entity<ProcessedMessage>(entity =>
            {
                entity.HasKey(e => new { e.MessageId, e.ProcessingEndpoint }).HasName("PK_Operations.ProcessedMessage");
                entity.ToTable("ProcessedMessage");
                entity.Property(e => e.MessageId).IsRequired().HasMaxLength(36);
                entity.Property(e => e.ProcessingEndpoint).IsRequired().HasMaxLength(100);
            });

            modelBuilder.Entity<IntegrityCheckChangeTracking>(entity =>
            {
                entity.HasKey(e => new { e.Name }).HasName("PK_Operations.IntegrityCheckChangeTracking");
                entity.ToTable("IntegrityCheckChangeTracking");
                entity.Property(e => e.Name).IsRequired().HasMaxLength(70);
            });

            modelBuilder.Entity<Connectivity>(entity =>
            {
                entity.HasKey(e => new { e.ServiceName }).HasName("PK_Operations.Connectivity");
                entity.ToTable("Connectivity");
                entity.Property(e => e.CanConnect).IsRequired();
                entity.Property(e => e.ServiceName).IsRequired().HasMaxLength(50);
                entity.Property(e => e.ErrorInfo).HasMaxLength(500);
                entity.Property(e => e.SupplementaryInfo).HasMaxLength(500);
            });

            modelBuilder.Entity<Connectivity>(entity =>
            {
                entity.HasKey(e => new { e.ServiceName }).HasName("PK_Operations.Connectivity");
                entity.ToTable("Connectivity");
                entity.Property(e => e.CanConnect).IsRequired();
                entity.Property(e => e.ServiceName).IsRequired().HasMaxLength(50);
                entity.Property(e => e.ErrorInfo).HasMaxLength(500);
                entity.Property(e => e.SupplementaryInfo).HasMaxLength(500);
            });

            modelBuilder.Entity<FundingReportFSP>(entity =>
            {
                entity.HasKey(e => new { e.FspCode, e.FundingPeriod }).HasName("PK_Operations.FundingReportFSP");
                entity.ToTable("FundingReportFSP");
                entity.Property(e => e.FspCode).HasMaxLength(100).IsRequired();
                entity.Property(e => e.FundingPeriod).HasMaxLength(100).IsRequired();
                entity.Property(e => e.Description).HasMaxLength(150).IsRequired();
                entity.Property(e => e.Order).IsRequired();
            });

            modelBuilder.Entity<FundingReportProvider>(entity =>
            {
                entity.HasKey(e => new { e.Ukprn, e.FundingPeriod }).HasName("PK_Operations.FundingReportProvider");
                entity.ToTable("FundingReportProvider");
                entity.Property(e => e.Ukprn).IsRequired();
                entity.Property(e => e.FundingPeriod).HasMaxLength(50).IsRequired();
                entity.Property(e => e.Type).HasMaxLength(30).IsRequired();
                entity.Property(e => e.Period).IsRequired();
            });

            modelBuilder.Entity<LaFundingReportProvider>(entity =>
            {
                entity.HasKey(e => new { e.Ukprn, e.FundingPeriod }).HasName("PK_Operations.LaFundingReportProvider");
                entity.ToTable("LaFundingReportProvider");
                entity.Property(e => e.Ukprn).IsRequired();
                entity.Property(e => e.FundingPeriod).HasMaxLength(50).IsRequired();
                entity.Property(e => e.Type).HasMaxLength(30).IsRequired();
                entity.Property(e => e.Period).IsRequired();
            });

            modelBuilder.Entity<FundingStreamPeriod>(entity =>
            {
                entity.HasKey(e => new { e.FundingStreamPeriodCode }).HasName("PK_Operations.FundingStreamPeriod");
                entity.ToTable("FundingStreamPeriod");
                entity.Property(e => e.FundingStreamPeriodCode).HasMaxLength(100).IsRequired();
                entity.Property(e => e.PeriodTypeCode).HasMaxLength(50).IsRequired();
            });

            modelBuilder.Entity<AvailableActualsCollection>(entity =>
            {
                entity.HasKey(e => new { e.CollectionType, e.CollectionReturnCode }).HasName("PK_Operations.AvailableActualsCollection");
                entity.ToTable("AvailableActualsCollection");
                entity.Property(e => e.CollectionType).HasMaxLength(20).IsRequired();
                entity.Property(e => e.CollectionReturnCode).HasMaxLength(20).IsRequired();
                entity.Property(e => e.ClosedDateTime).HasColumnType("datetime").IsRequired();
                entity.Property(e => e.TotalItems).IsRequired();
            });

            modelBuilder.RemovePluralizingTableNameConvention();
        }
    }
}
