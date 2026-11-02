namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddColumnTotalDeliveryToTableFundingClaimDeliverable : DbMigration
    {
        public override void Up()
        {
            AddColumn("PerformanceManagement.FundingClaimDeliverable", "TotalDelivery", c => c.Decimal(precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            DropColumn("PerformanceManagement.FundingClaimDeliverable", "TotalDelivery");
        }
    }
}
