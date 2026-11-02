namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ContractVersionNumberNowAnInt : DbMigration
    {
        public override void Up()
        {
            AlterColumn("PerformanceManagement.ContractAllocation", "Contract_VersionNumber", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            AlterColumn("PerformanceManagement.ContractAllocation", "Contract_VersionNumber", c => c.Decimal(nullable: false, precision: 18, scale: 2));
        }
    }
}
