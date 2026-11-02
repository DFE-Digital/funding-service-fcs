namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddColumnsTotalEstimatedNewStartsFunding : DbMigration
    {
        public override void Up()
        {
            Sql("DELETE FROM DocumentsDomain.NlapFundingConfig");

            AddColumn("DocumentsDomain.NlapFundingConfig", "TotalEstimatedNewStartsFunding1618", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("DocumentsDomain.NlapFundingConfig", "TotalEstimatedNewStartsFundingAdult", c => c.Decimal(nullable: false, precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            DropColumn("DocumentsDomain.NlapFundingConfig", "TotalEstimatedNewStartsFundingAdult");
            DropColumn("DocumentsDomain.NlapFundingConfig", "TotalEstimatedNewStartsFunding1618");
        }
    }
}
