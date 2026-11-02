namespace ContractManagement.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddCdaExtractTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractManagement.CdaExtract",
                c => new
                    {
                        ExtractName = c.String(nullable: false, maxLength: 100),
                        ReportingCloseDate = c.DateTime(),
                    })
                .PrimaryKey(t => t.ExtractName);
        }
        
        public override void Down()
        {
            DropTable("ContractManagement.CdaExtract");
        }
    }
}
