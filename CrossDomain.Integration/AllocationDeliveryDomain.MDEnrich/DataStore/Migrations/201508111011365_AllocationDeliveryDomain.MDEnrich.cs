namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AllocationDeliveryDomainMDEnrich : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "MonitoringDeliverables.FundingStreamPeriodDeliverable",
                c => new
                    {
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 100),
                        DeliverableCode = c.Int(nullable: false),
                        ParentDeliverableCode = c.Int(nullable: false),
                        DeliverableName = c.String(nullable: false, maxLength: 100),
                        AllowProfile = c.Boolean(nullable: false),
                        AllowActuals = c.Boolean(nullable: false),
                        AllowPayment = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => new { t.FundingStreamPeriodCode, t.DeliverableCode });
        }
        
        public override void Down()
        {
            DropTable("MonitoringDeliverables.FundingStreamPeriodDeliverable");
        }
    }
}
