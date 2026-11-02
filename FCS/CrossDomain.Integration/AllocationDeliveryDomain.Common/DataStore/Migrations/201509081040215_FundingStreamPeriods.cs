namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    using System.IO;
    using System.Linq;

    public partial class FundingStreamPeriods : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "MonitoringDeliverables.FundingStreamPeriod",
                c => new
                    {
                        Code = c.String(nullable: false, maxLength: 20),
                        Name = c.String(nullable: false, maxLength: 100),
                        ProcessFutureActuals = c.Boolean(nullable: false),
                        PersistCurrentActualsState = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => t.Code);
        }
        
        public override void Down()
        {
            DropTable("MonitoringDeliverables.FundingStreamPeriod");
        }
    }
}
