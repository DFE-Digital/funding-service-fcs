namespace Operations.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableDeployedConfigVersion : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "Operations.DeployedConfigVersion",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Version = c.String(nullable: false, maxLength: 30),
                        Checksum = c.Binary(nullable: false, maxLength: 16),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.Id);
            
        }
        
        public override void Down()
        {
            DropTable("Operations.DeployedConfigVersion");
        }
    }
}
