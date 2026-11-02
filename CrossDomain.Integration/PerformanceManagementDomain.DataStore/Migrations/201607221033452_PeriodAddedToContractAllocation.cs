namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class PeriodAddedToContractAllocation : DbMigration
    {
        public override void Up()
        {
            AddColumn("PerformanceManagement.ContractAllocation", "Period_PeriodTypeName", c => c.String(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("PerformanceManagement.ContractAllocation", "Period_PeriodTypeName");
        }
    }
}
