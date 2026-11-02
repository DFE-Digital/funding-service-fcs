namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddAllowProfileToFspDeliverableClaim : DbMigration
    {
        public override void Up()
        {
            AddColumn("PerformanceManagement.FspDeliverableClaim", "AllowProfile", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("PerformanceManagement.FspDeliverableClaim", "AllowProfile");
        }
    }
}
