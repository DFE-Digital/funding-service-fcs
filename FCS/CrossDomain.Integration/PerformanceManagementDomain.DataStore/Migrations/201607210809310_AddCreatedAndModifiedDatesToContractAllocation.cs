namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddCreatedAndModifiedDatesToContractAllocation : DbMigration
    {
        public override void Up()
        {
            AddColumn("PerformanceManagement.ContractAllocation", "LastModifiedDate", c => c.DateTime());
            AddColumn("PerformanceManagement.ContractAllocation", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
        }
        
        public override void Down()
        {
            DropColumn("PerformanceManagement.ContractAllocation", "LastModifiedDate");
            DropColumn("PerformanceManagement.ContractAllocation", "CreatedDate");
        }
    }
}
