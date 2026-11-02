namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddDocumentsRequiredToFundingTypeFundingPeriod : DbMigration
    {
        public override void Up()
        {
            AddColumn("DocumentsDomain.FundingTypeFundingPeriod", "DocumentsRequired", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("DocumentsDomain.FundingTypeFundingPeriod", "DocumentsRequired");
        }
    }
}
