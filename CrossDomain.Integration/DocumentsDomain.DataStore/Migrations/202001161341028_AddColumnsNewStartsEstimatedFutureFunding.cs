namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddColumnsNewStartsEstimatedFutureFunding : DbMigration
    {
        public override void Up()
        {
            Sql("DELETE FROM DocumentsDomain.NlapFundingConfig");

            AddColumn("DocumentsDomain.NlapFundingConfig", "NewStartsEstimatedFutureFunding1618", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("DocumentsDomain.NlapFundingConfig", "NewStartsEstimatedFutureFundingAdult", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            DropColumn("DocumentsDomain.NlapFundingConfig", "TotalEstimatedFunding1618");
            DropColumn("DocumentsDomain.NlapFundingConfig", "TotalEstimatedFundingAdult");
            DropColumn("DocumentsDomain.NlapFundingConfig", "TotalEstimatedNewStartsFunding1618");
            DropColumn("DocumentsDomain.NlapFundingConfig", "TotalEstimatedNewStartsFundingAdult");
        }
        
        public override void Down()
        {
            AddColumn("DocumentsDomain.NlapFundingConfig", "TotalEstimatedNewStartsFundingAdult", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("DocumentsDomain.NlapFundingConfig", "TotalEstimatedNewStartsFunding1618", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("DocumentsDomain.NlapFundingConfig", "TotalEstimatedFundingAdult", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("DocumentsDomain.NlapFundingConfig", "TotalEstimatedFunding1618", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            DropColumn("DocumentsDomain.NlapFundingConfig", "NewStartsEstimatedFutureFundingAdult");
            DropColumn("DocumentsDomain.NlapFundingConfig", "NewStartsEstimatedFutureFunding1618");
        }
    }
}
