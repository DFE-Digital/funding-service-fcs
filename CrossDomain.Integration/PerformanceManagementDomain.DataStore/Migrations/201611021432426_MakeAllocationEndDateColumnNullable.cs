namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class MakeAllocationEndDateColumnNullable : DbMigration
    {
        public override void Up()
        {
            AlterColumn("PerformanceManagement.ContractAllocation", "EndDate", c => c.DateTime(nullable: true));
        }
        
        public override void Down()
        {
            AlterColumn("PerformanceManagement.ContractAllocation", "EndDate", c => c.DateTime(nullable: false));
        }
    }
}
