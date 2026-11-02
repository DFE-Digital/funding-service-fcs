namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddCappingApportionmentPriorityOrderColumn : DbMigration
    {
        public override void Up()
        {
            AddColumn("PolicyCache.PolicyDeliverable", "CappingApportionmentPriorityOrder", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("PolicyCache.PolicyDeliverable", "CappingApportionmentPriorityOrder");
        }
    }
}
