namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddCreatedDateColumn : DbMigration
    {
        public override void Up()
        {
            AddColumn("PaymentSchedule.ProvisionIdentifier", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("PaymentSchedule.OrganisationIdentifer", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("PaymentSchedule.DeliverablePayment", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("PaymentSchedule.Allocation", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
        }
        
        public override void Down()
        {
            DropColumn("PaymentSchedule.ProvisionIdentifier", "CreatedDate");
            DropColumn("PaymentSchedule.OrganisationIdentifer", "CreatedDate");
            DropColumn("PaymentSchedule.DeliverablePayment", "CreatedDate");
            DropColumn("PaymentSchedule.Allocation", "CreatedDate");
        }
    }
}
