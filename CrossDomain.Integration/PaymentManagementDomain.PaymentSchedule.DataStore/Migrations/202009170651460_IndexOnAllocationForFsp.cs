namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class IndexOnAllocationForFsp : DbMigration
    {
        public override void Up()
        {
            AlterColumn("PaymentSchedule.Allocation", "FundingStreamPeriodCode", c => c.String(nullable: false, maxLength: 100));
            CreateIndex("PaymentSchedule.Allocation", "FundingStreamPeriodCode", name: "IX_Allocation_FundingStreamPeriodCode");
        }
        
        public override void Down()
        {
            DropIndex("PaymentSchedule.Allocation", "IX_Allocation_FundingStreamPeriodCode");
            AlterColumn("PaymentSchedule.Allocation", "FundingStreamPeriodCode", c => c.String());
        }
    }
}
