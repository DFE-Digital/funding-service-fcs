namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Add_LastModifiedDate_ToAllEntities : DbMigration
    {
        public override void Up()
        {
            AddColumn("PaymentSchedule.Allocation", "LastModifiedDate", c => c.DateTime());
            AddColumn("PaymentSchedule.DeliverablePayment", "LastModifiedDate", c => c.DateTime());
            AddColumn("PaymentSchedule.OrganisationIdentifer", "LastModifiedDate", c => c.DateTime());
            AddColumn("PaymentSchedule.ProvisionIdentifier", "LastModifiedDate", c => c.DateTime());
        }
        
        public override void Down()
        {
            DropColumn("PaymentSchedule.ProvisionIdentifier", "LastModifiedDate");
            DropColumn("PaymentSchedule.OrganisationIdentifer", "LastModifiedDate");
            DropColumn("PaymentSchedule.DeliverablePayment", "LastModifiedDate");
            DropColumn("PaymentSchedule.Allocation", "LastModifiedDate");
        }
    }
}
