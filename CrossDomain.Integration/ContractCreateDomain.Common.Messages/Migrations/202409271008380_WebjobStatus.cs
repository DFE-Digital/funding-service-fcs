namespace SFA.FCT.ContractRequestDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class WebjobStatus : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractRequest.WebjobStatus",
                c => new
                {
                    Id = c.Int(nullable: false, identity: true),
                    Webjobname = c.String(nullable: false, maxLength: 100),
                    Enabled = c.Boolean(nullable: false),
                    CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.Id);                

        }

        public override void Down()
        {
           DropTable("ContractRequest.WebjobStatus");
        }
    }
}
