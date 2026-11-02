namespace SFA.FCT.ContractRequestDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableAllocationNotification : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractRequest.AllocationNotification",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        AllocationId = c.String(nullable: false, maxLength: 100),
                        VersionNumber = c.Int(nullable: false),
                        Ukprn = c.Int(nullable: false),
                        Status = c.Int(nullable: false),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.Id)
                .Index(t => new { t.AllocationId, t.VersionNumber }, unique: true, name: "IX_AllocationNotification_AllocationVersion");
            
        }
        
        public override void Down()
        {
            DropIndex("ContractRequest.AllocationNotification", "IX_AllocationNotification_AllocationVersion");
            DropTable("ContractRequest.AllocationNotification");
        }
    }
}
