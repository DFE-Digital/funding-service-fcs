namespace Operations.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableIntegrityChangeTracking : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "Operations.IntegrityCheckChangeTracking",
                c => new
                    {
                        Name = c.String(nullable: false, maxLength: 70),
                        CurrentVersion = c.Long(),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.Name);
            
        }
        
        public override void Down()
        {
            DropTable("Operations.IntegrityCheckChangeTracking");
        }
    }
}
