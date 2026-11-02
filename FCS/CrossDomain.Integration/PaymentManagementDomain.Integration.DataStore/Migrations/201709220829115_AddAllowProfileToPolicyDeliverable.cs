namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddAllowProfileToPolicyDeliverable : DbMigration
    {
        public override void Up()
        {
            AddColumn("PolicyCache.PolicyDeliverable", "AllowProfile", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("PolicyCache.PolicyDeliverable", "AllowProfile");
        }
    }
}
