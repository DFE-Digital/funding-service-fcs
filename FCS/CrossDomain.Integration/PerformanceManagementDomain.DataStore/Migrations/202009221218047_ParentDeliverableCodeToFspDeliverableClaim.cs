namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class ParentDeliverableCodeToFspDeliverableClaim : DbMigration
    {
        public override void Up()
        {
            AddColumn("PerformanceManagement.FspDeliverableClaim", "ParentDeliverableCode", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("PerformanceManagement.FspDeliverableClaim", "ParentDeliverableCode");
        }
    }
}
