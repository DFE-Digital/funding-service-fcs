namespace Operations.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class SessionTableCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "Operations.Session",
                c => new
                    {
                        Identifier = c.Guid(nullable: false),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"),
                    })
                .PrimaryKey(t => t.Identifier);
        }
        
        public override void Down()
        {
            DropTable("Operations.Session");
        }
    }
}
