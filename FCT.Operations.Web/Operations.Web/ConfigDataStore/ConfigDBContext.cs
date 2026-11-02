using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;

namespace Operations.Web.ConfigDataStore
{
    public partial class ConfigDBContext : DbContext
    {
        public ConfigDBContext()
            : base("name=ConfigDBContext")
        {
        }

        public virtual DbSet<Environment> Environments { get; set; }
        public virtual DbSet<Release_Deployments> Release_Deployments { get; set; }
        public virtual DbSet<Release> Releases { get; set; }
        public virtual DbSet<ClaimCollection> ClaimCollections { get; set; }
        public virtual DbSet<ClaimReconciliationAllocationGroup> ClaimReconciliationAllocationGroups { get; set; }
        public virtual DbSet<ClaimReconciliationAllocationGroupFsp> ClaimReconciliationAllocationGroupFsps { get; set; }
        public virtual DbSet<ClaimReconciliationBehaviour> ClaimReconciliationBehaviours { get; set; }
        public virtual DbSet<ClaimReconciliationDeliverableGroup> ClaimReconciliationDeliverableGroups { get; set; }
        public virtual DbSet<ClaimReconciliationReferenceDataReconProfiling> ClaimReconciliationReferenceDataReconProfilings { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Environment>()
                .HasMany(e => e.Release_Deployments)
                .WithRequired(e => e.Environment)
                .HasForeignKey(e => e.env_id)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Release>()
                .HasMany(e => e.Release_Deployments)
                .WithRequired(e => e.Release)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<ClaimCollection>()
                .Property(e => e.CreatedBy)
                .IsUnicode(false);

            modelBuilder.Entity<ClaimCollection>()
                .Property(e => e.ModifiedBy)
                .IsUnicode(false);

            modelBuilder.Entity<ClaimReconciliationAllocationGroup>()
                .Property(e => e.CreatedBy)
                .IsUnicode(false);

            modelBuilder.Entity<ClaimReconciliationAllocationGroup>()
                .Property(e => e.ModifiedBy)
                .IsUnicode(false);

            modelBuilder.Entity<ClaimReconciliationAllocationGroupFsp>()
                .Property(e => e.CreatedBy)
                .IsUnicode(false);

            modelBuilder.Entity<ClaimReconciliationAllocationGroupFsp>()
                .Property(e => e.ModifiedBy)
                .IsUnicode(false);

            modelBuilder.Entity<ClaimReconciliationBehaviour>()
                .Property(e => e.CreatedBy)
                .IsUnicode(false);

            modelBuilder.Entity<ClaimReconciliationBehaviour>()
                .Property(e => e.ModifiedBy)
                .IsUnicode(false);

            modelBuilder.Entity<ClaimReconciliationDeliverableGroup>()
                .Property(e => e.CreatedBy)
                .IsUnicode(false);

            modelBuilder.Entity<ClaimReconciliationDeliverableGroup>()
                .Property(e => e.ModifiedBy)
                .IsUnicode(false);

            modelBuilder.Entity<ClaimReconciliationReferenceDataReconProfiling>()
                .Property(e => e.CreatedBy)
                .IsUnicode(false);

            modelBuilder.Entity<ClaimReconciliationReferenceDataReconProfiling>()
                .Property(e => e.ModifiedBy)
                .IsUnicode(false);
        }
    }
}
