namespace SFA.FCT.PMD.PaymentManagment.DataStore
{
    using System.Data.Entity;
    using System.Data.Entity.ModelConfiguration.Conventions;
    using SFA.FCT.PMD.PaymentManagment.DataStore.Migrations;
    using SFA.FCT.PMD.PaymentManagment.DataStore.Model;

    public class PaymentManagementDBContext : DbContext, IPaymentManagementDBContext
    {
        public PaymentManagementDBContext()
            : base()
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersionWithTransactionSuppressInitializer<PaymentManagementDBContext, Configuration>());
        }

        public virtual IDbSet<ContractApprovedId> ContractApprovedIds { get; set; }

        public virtual IDbSet<PaymentAggregationXRMId> PaymentAggregationXrmIds { get; set; }

        public virtual IDbSet<PaymentScheduleId> PaymentScheduleIds { get; set; }

        public virtual IDbSet<PaymentScheduleXRMId> PaymentScheduleXrmIds { get; set; }

        public virtual IDbSet<AllocationActualsId> AllocationActualsIds { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("PaymentManagement");
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }
    }
}
