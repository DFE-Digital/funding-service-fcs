namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableFspGroup : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "DocumentsDomain.FSPGroup",
                c => new
                    {
                        FSPGroupCode = c.String(nullable: false, maxLength: 50),
                        ContractDocumentDisplayName = c.String(nullable: false, maxLength: 100),
                        DisplayOrder = c.Int(nullable: false),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.FSPGroupCode);
            
        }
        
        public override void Down()
        {
            DropTable("DocumentsDomain.FSPGroup");
        }
    }
}
