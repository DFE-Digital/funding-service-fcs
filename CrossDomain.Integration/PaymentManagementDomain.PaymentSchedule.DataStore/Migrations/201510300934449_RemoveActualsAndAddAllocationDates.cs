namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RemoveActualsAndAddAllocationDates : DbMigration
    {
        public override void Up()
        {
            AddColumn("PaymentSchedule.Allocation", "AllocationStartDate", c => c.DateTime());
            AddColumn("PaymentSchedule.Allocation", "AllocationEndDate", c => c.DateTime());
            DropColumn("PaymentSchedule.DeliverablePayment", "ActualVolumne");
            DropColumn("PaymentSchedule.DeliverablePayment", "ActualValue");
        }
        
        public override void Down()
        {
            AddColumn("PaymentSchedule.DeliverablePayment", "ActualValue", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("PaymentSchedule.DeliverablePayment", "ActualVolumne", c => c.Int());
            DropColumn("PaymentSchedule.Allocation", "AllocationEndDate");
            DropColumn("PaymentSchedule.Allocation", "AllocationStartDate");
        }
    }
}
