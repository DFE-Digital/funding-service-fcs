namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableFSPDeliverable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "DocumentsDomain.FSPDeliverable",
                c => new
                    {
                        DeliverableCode = c.Int(nullable: false),
                        FundingStreamPeriod = c.String(nullable: false, maxLength: 128),
                        AllowProfile = c.Boolean(nullable: false),
                        DisplayOnFundingAgreement = c.Boolean(nullable: false),
                        MandatoryOnFundingAgreement = c.Boolean(nullable: false),
                        DisplayOrderOnFundingAgreement = c.Int(nullable: false),
                        AllowCustomDescription = c.Boolean(nullable: false),
                        ShouldDisplayValue = c.Boolean(nullable: false),
                        ShouldDisplayVolumeAndUnitCost = c.Boolean(nullable: false),
                        DisplayNameOnSummaryOfFunding = c.String(maxLength: 150),
                        DisplayNameOnFundingAgreement = c.String(maxLength: 150),
                        DisplayOnSummaryOfFunding = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => new { t.DeliverableCode, t.FundingStreamPeriod })
                .Index(t => new { t.DeliverableCode, t.FundingStreamPeriod }, unique: true, name: "IX_FSPDeliverableIndex");
            
        }
        
        public override void Down()
        {
            DropIndex("DocumentsDomain.FSPDeliverable", "IX_FSPDeliverableIndex");
            DropTable("DocumentsDomain.FSPDeliverable");
        }
    }
}
