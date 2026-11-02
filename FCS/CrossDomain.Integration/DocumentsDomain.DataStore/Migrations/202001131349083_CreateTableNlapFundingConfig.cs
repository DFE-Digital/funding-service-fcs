namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableNlapFundingConfig : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "DocumentsDomain.NlapFundingConfig",
                c => new
                    {
                        Ukprn = c.Int(nullable: false),
                        NewStarts2021Funding1618 = c.Decimal(nullable: false, precision: 18, scale: 2),
                        NewStarts2021FundingAdult = c.Decimal(nullable: false, precision: 18, scale: 2),
                        TotalEstimatedFunding1618 = c.Decimal(nullable: false, precision: 18, scale: 2),
                        TotalEstimatedFundingAdult = c.Decimal(nullable: false, precision: 18, scale: 2),
                    })
                .PrimaryKey(t => t.Ukprn);
            
        }
        
        public override void Down()
        {
            DropTable("DocumentsDomain.NlapFundingConfig");
        }
    }
}
