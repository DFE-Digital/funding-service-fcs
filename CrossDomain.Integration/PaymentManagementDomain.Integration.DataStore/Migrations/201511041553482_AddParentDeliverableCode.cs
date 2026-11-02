namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddParentDeliverableCode : DbMigration
    {
        public override void Up()
        {
            AddColumn("PolicyCache.PolicyDeliverable", "ParentDeliverableCode", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("PolicyCache.PolicyDeliverable", "ParentDeliverableCode");
        }
    }
}
