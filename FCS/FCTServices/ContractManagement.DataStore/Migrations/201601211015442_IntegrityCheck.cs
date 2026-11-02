namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateIntegrityCheck : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractManagement.IntegrityCheck",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        CheckerType = c.String(nullable: false, maxLength: 50),
                        StartDate = c.DateTime(nullable: false),
                        FinishDate = c.DateTime(),
                        Status = c.String(nullable: false, maxLength: 20),
                        Outcome = c.String(maxLength: 20),
                        Link = c.String(nullable: false, maxLength: 250),
                    })
                .PrimaryKey(t => t.Id);
            
        }
        
        public override void Down()
        {
            DropTable("ContractManagement.IntegrityCheck");
        }
    }
}
