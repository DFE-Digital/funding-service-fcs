namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RemovedLastModifiedDateFromCAD : DbMigration
    {
        public override void Up()
        {
            DropColumn("PerformanceManagement.ContractAllocationDeliverable", "LastModifiedDate");
        }
        
        public override void Down()
        {
            AddColumn("PerformanceManagement.ContractAllocationDeliverable", "LastModifiedDate", c => c.DateTime());
        }
    }
}
