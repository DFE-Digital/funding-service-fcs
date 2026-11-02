namespace Operations.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateDataFixHistoryTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "Operations.DataFixHistory",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Release = c.String(nullable: false, maxLength: 10),
                        StoryNumber = c.Int(nullable: false),
                        Name = c.String(nullable: false, maxLength: 100),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.Id);
            
        }
        
        public override void Down()
        {
            DropTable("Operations.DataFixHistory");
        }
    }
}
