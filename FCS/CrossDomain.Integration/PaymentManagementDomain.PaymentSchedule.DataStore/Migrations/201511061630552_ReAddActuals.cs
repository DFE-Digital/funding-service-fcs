namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ReAddActuals : DbMigration
    {
        public override void Up()
        {
            AddColumn("PaymentSchedule.DeliverablePayment", "ActualVolumne", c => c.Int());
            AddColumn("PaymentSchedule.DeliverablePayment", "ActualValue", c => c.Decimal(precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            DropColumn("PaymentSchedule.DeliverablePayment", "ActualValue");
            DropColumn("PaymentSchedule.DeliverablePayment", "ActualVolumne");
        }
    }
}
