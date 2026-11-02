namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddFspGroupForeignKeyToFsp : DbMigration
    {
        public override void Up()
        {
            AddColumn("DocumentsDomain.FundingStreamPeriod", "FSPGroupCode", c => c.String(maxLength: 50));
            CreateIndex("DocumentsDomain.FundingStreamPeriod", "FSPGroupCode");
            AddForeignKey("DocumentsDomain.FundingStreamPeriod", "FSPGroupCode", "DocumentsDomain.FSPGroup", "FSPGroupCode");
        }
        
        public override void Down()
        {
            DropForeignKey("DocumentsDomain.FundingStreamPeriod", "FSPGroupCode", "DocumentsDomain.FSPGroup");
            DropIndex("DocumentsDomain.FundingStreamPeriod", new[] { "FSPGroupCode" });
            DropColumn("DocumentsDomain.FundingStreamPeriod", "FSPGroupCode");
        }
    }
}
