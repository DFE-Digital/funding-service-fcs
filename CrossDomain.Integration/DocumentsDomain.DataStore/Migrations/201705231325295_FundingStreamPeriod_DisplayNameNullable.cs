namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FundingStreamPeriod_DisplayNameNullable : DbMigration
    {
        public override void Up()
        {
            AlterColumn("DocumentsDomain.FundingStreamPeriod", "DisplayName", c => c.String(maxLength: 100));
        }
        
        public override void Down()
        {
            AlterColumn("DocumentsDomain.FundingStreamPeriod", "DisplayName", c => c.String(nullable: false, maxLength: 100));
        }
    }
}
