namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateMonthEndHistory : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractManagement.MonthEndHistory",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        StartTime = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"),
                        EndTime = c.DateTime(),
                    })
                .PrimaryKey(t => t.Id);
            
        }
        
        public override void Down()
        {
            DropTable("ContractManagement.MonthEndHistory");
        }
    }
}
