namespace SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CrossDomainIntegrationOverrideDateDataStore : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "OverrideDate.OverrideDate",
                c => new
                    {
                        SystemOverrideDate = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.SystemOverrideDate);
            
        }
        
        public override void Down()
        {
            DropTable("OverrideDate.OverrideDate");
        }
    }
}
