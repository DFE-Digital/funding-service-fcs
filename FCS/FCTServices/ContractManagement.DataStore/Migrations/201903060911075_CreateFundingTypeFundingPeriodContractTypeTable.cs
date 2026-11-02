namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateFundingTypeFundingPeriodContractTypeTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractManagement.FundingTypeFundingPeriodContractType",
                c => new
                    {
                        FundingTypeCode = c.String(nullable: false, maxLength: 100),
                        FundingPeriodCode = c.String(nullable: false, maxLength: 100),
                        ContractType = c.String(nullable: false, maxLength: 100),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => new { t.FundingTypeCode, t.FundingPeriodCode, t.ContractType });
            
        }
        
        public override void Down()
        {
            DropTable("ContractManagement.FundingTypeFundingPeriodContractType");
        }
    }
}
