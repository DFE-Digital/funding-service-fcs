namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class SubVersionNowInt : DbMigration
    {
        public override void Up()
        {
            AlterColumn("PerformanceManagement.ContractAllocation", "Contract_SubVersionNumber", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            AlterColumn("PerformanceManagement.ContractAllocation", "Contract_SubVersionNumber", c => c.Decimal(nullable: false, precision: 18, scale: 2));
        }
    }
}
