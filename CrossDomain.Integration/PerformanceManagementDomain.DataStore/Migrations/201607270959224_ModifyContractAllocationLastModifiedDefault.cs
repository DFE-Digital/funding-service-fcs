namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;

    public partial class ModifyContractAllocationLastModifiedDefault : DbMigration
    {
        public override void Up()
        {
            AlterColumn("PerformanceManagement.ContractAllocation", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"));
        }

        public override void Down()
        {
            AlterColumn("PerformanceManagement.ContractAllocation", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
        }
    }
}
