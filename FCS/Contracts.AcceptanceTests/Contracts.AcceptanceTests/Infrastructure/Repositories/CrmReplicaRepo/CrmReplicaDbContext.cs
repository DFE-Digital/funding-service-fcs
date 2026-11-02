using ADMonitoringDomain.DataStore;
using Dapper;
using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.Configuration;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Linq;

namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.CrmReplicaRepo
{
    public partial class CrmReplicaDbContext : DbContext
    {
        public static string KeyVaultValue { get; set; } = string.Empty;

        public static string _crmReplicaConnectionString = ConfigurationManager.ConnectionStrings["CrmReplicaDbContext"].ConnectionString;
        public CrmReplicaDbContext() : base(GetConnectionString())
        {            
        }
        private static string GetConnectionString()
        {
            if (!string.IsNullOrWhiteSpace(KeyVaultValue))
            {
                return KeyVaultValue;
            }
            return "name=CrmReplicaDbContext";
        }
        public virtual DbSet<sfa_caseload> sfa_caseload { get; set; }
        public virtual DbSet<sfa_contract> sfa_contract { get; set; }
        public virtual DbSet<sfa_contracttransitionhistory> sfa_contracttransitionhistory { get; set; }
        public virtual DbSet<sfa_fundingallocation> sfa_fundingallocation { get; set; }
        public virtual DbSet<sfa_fundingclaimreconciliation> sfa_fundingclaimreconciliation { get; set; }
        public virtual DbSet<sfa_releasegroup> sfa_releasegroup { get; set; }
        public virtual DbSet<sfa_subnominalaggregation> sfa_subnominalaggregation { get; set; }

        public static T ExecuteScalarSql<T>(string sql, object parameter)
        {
            using (var _crmDbContext = new CrmReplicaDbContext())
            {
                return _crmDbContext.Database.Connection.ExecuteScalar<T>(sql, parameter, commandTimeout: 180);
            }
        }
        public static void ExecuteSql(string sql, object parameter)
        {
            using (var _crmDbContext = new CrmReplicaDbContext())
            {
                _crmDbContext.Database.Connection.Execute(sql, parameter, commandTimeout: 180);
            }
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<sfa_contract>()
                .Property(e => e.sfa_contractvalue)
                .HasPrecision(38, 4);

            modelBuilder.Entity<sfa_contract>()
                .Property(e => e.sfa_contractvalue_base)
                .HasPrecision(38, 4);

            modelBuilder.Entity<sfa_contract>()
                .Property(e => e.exchangerate)
                .HasPrecision(38, 10);

            modelBuilder.Entity<sfa_contract>()
                .Property(e => e.sfa_variation)
                .HasPrecision(38, 2);

            modelBuilder.Entity<sfa_fundingallocation>()
                .Property(e => e.sfa_value_base)
                .HasPrecision(38, 4);

            modelBuilder.Entity<sfa_fundingallocation>()
                .Property(e => e.sfa_value)
                .HasPrecision(38, 4);

            modelBuilder.Entity<sfa_fundingallocation>()
                .Property(e => e.exchangerate)
                .HasPrecision(38, 10);

            modelBuilder.Entity<sfa_fundingclaimreconciliation>()
                .Property(e => e.sfa_cappedclaimedvalue)
                .HasPrecision(38, 2);

            modelBuilder.Entity<sfa_fundingclaimreconciliation>()
                .Property(e => e.sfa_adjustedcappedclaimedvalue)
                .HasPrecision(38, 2);

            modelBuilder.Entity<sfa_fundingclaimreconciliation>()
                .Property(e => e.sfa_plannedvalue)
                .HasPrecision(38, 2);

            modelBuilder.Entity<sfa_fundingclaimreconciliation>()
                .Property(e => e.sfa_claimadjustmentvalue)
                .HasPrecision(38, 2);

            modelBuilder.Entity<sfa_fundingclaimreconciliation>()
                .Property(e => e.sfa_reconciliationvalue)
                .HasPrecision(38, 2);

            modelBuilder.Entity<sfa_fundingclaimreconciliation>()
                .Property(e => e.sfa_proposedreconciliationvalue)
                .HasPrecision(38, 2);

            modelBuilder.Entity<sfa_fundingclaimreconciliation>()
                .Property(e => e.sfa_claimedvalue)
                .HasPrecision(38, 2);

            modelBuilder.Entity<sfa_fundingclaimreconciliation>()
                .Property(e => e.sfa_earningsboostvalue)
                .HasPrecision(38, 2);

            modelBuilder.Entity<sfa_releasegroup>()
                .Property(e => e.sfa_associatedvalue)
                .HasPrecision(38, 2);

            modelBuilder.Entity<sfa_releasegroup>()
                .Property(e => e.sfa_associatedvalue_base)
                .HasPrecision(38, 2);

            modelBuilder.Entity<sfa_releasegroup>()
                .Property(e => e.exchangerate)
                .HasPrecision(38, 10);

            modelBuilder.Entity<sfa_subnominalaggregation>()
                .Property(e => e.sfa_aggregatedvalue)
                .HasPrecision(38, 2);
        }
    }
}
