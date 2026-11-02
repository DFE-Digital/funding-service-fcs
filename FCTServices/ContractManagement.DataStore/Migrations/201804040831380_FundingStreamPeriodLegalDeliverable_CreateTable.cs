namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;

    public partial class FundingStreamPeriodLegalDeliverable_CreateTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractManagement.FundingStreamPeriodLegalDeliverable",
                c => new
                {
                    FundingStreamPeriodCode = c.String(nullable: false, maxLength: 100),
                    DeliverableCode = c.Int(nullable: false),
                    CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => new {t.FundingStreamPeriodCode, t.DeliverableCode});
        }

        public override void Down()
        {
            DropTable("ContractManagement.FundingStreamPeriodLegalDeliverable");
        }
    }
}
