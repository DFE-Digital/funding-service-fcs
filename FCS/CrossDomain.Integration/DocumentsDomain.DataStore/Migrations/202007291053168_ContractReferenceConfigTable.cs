namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ContractReferenceConfigTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "DocumentsDomain.ContractReferenceConfig",
                c => new
                    {
                        Ukprn = c.Int(nullable: false),
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 50),
                        FinancialEnvelope1Funding = c.Decimal(nullable: false, precision: 18, scale: 2),
                        FinancialEnvelope2Funding = c.Decimal(nullable: false, precision: 18, scale: 2),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => new { t.Ukprn, t.FundingStreamPeriodCode });
            
        }
        
        public override void Down()
        {
            DropTable("DocumentsDomain.ContractReferenceConfig");
        }
    }
}
