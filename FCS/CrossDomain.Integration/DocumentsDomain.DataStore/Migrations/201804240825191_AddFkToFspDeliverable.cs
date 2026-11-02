namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddFkToFspDeliverable : DbMigration
    {
        public override void Up()
        {
            DropIndex("DocumentsDomain.FSPDeliverable", "IX_FSPDeliverableIndex");
            DropPrimaryKey("DocumentsDomain.FSPDeliverable");
            AddColumn("DocumentsDomain.FSPDeliverable", "FundingStreamPeriodCode", c => c.String(nullable: false, maxLength: 100));
            AddPrimaryKey("DocumentsDomain.FSPDeliverable", new[] { "DeliverableCode", "FundingStreamPeriodCode" });
            CreateIndex("DocumentsDomain.FSPDeliverable", "FundingStreamPeriodCode");
            AddForeignKey("DocumentsDomain.FSPDeliverable", "FundingStreamPeriodCode", "DocumentsDomain.FundingStreamPeriod", "FundingStreamPeriodCode", cascadeDelete: true);
            DropColumn("DocumentsDomain.FSPDeliverable", "FundingStreamPeriod");
        }
        
        public override void Down()
        {
            AddColumn("DocumentsDomain.FSPDeliverable", "FundingStreamPeriod", c => c.String(nullable: false, maxLength: 128));
            DropForeignKey("DocumentsDomain.FSPDeliverable", "FundingStreamPeriodCode", "DocumentsDomain.FundingStreamPeriod");
            DropIndex("DocumentsDomain.FSPDeliverable", new[] { "FundingStreamPeriodCode" });
            DropPrimaryKey("DocumentsDomain.FSPDeliverable");
            DropColumn("DocumentsDomain.FSPDeliverable", "FundingStreamPeriodCode");
            AddPrimaryKey("DocumentsDomain.FSPDeliverable", new[] { "DeliverableCode", "FundingStreamPeriod" });
            CreateIndex("DocumentsDomain.FSPDeliverable", new[] { "DeliverableCode", "FundingStreamPeriod" }, unique: true, name: "IX_FSPDeliverableIndex");
        }
    }
}
