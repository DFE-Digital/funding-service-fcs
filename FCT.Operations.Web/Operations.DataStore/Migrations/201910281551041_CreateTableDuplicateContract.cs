namespace Operations.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableDuplicateContract : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "Operations.DuplicateContract",
                c => new
                    {
                        ContractNumber = c.String(nullable: false, maxLength: 30),
                        Version = c.Int(nullable: false),
                        SubVersion = c.Int(nullable: false),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => new { t.ContractNumber, t.Version, t.SubVersion });
        }
        
        public override void Down()
        {
            DropTable("Operations.DuplicateContract");
        }
    }
}
