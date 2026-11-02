namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RenameColumnsDeliverablePayment : DbMigration
    {
        public override void Up()
        {
            RenameColumn(table: "PaymentSchedule.DeliverablePayment", name: "PlannedVolumne", newName: "PlannedVolume");
            RenameColumn(table: "PaymentSchedule.DeliverablePayment", name: "ActualVolumne", newName: "ActualVolume");
        }
        
        public override void Down()
        {
            RenameColumn(table: "PaymentSchedule.DeliverablePayment",name: "PlannedVolume", newName: "PlannedVolumne");
            RenameColumn(table: "PaymentSchedule.DeliverablePayment", name: "ActualVolume", newName: "ActualVolumne");
        }
    }
}
