namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddDeliverableNameColumn : DbMigration
    {
        public override void Up()
        {
            AddColumn("PerformanceManagement.FspDeliverableClaim", "DeliverableName", c => c.String(nullable: false, maxLength: 120));
        }
        
        public override void Down()
        {
            DropColumn("PerformanceManagement.FspDeliverableClaim", "DeliverableName");
        }
    }
}
