namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class ModifySummarisedActualIndexes : DbMigration
    {
        public override void Up()
        {
            Sql("DELETE FROM MonitoringDeliverables.SummarisedActual");

            DropIndex("MonitoringDeliverables.SummarisedActual", "IX_SummarisedActual_Actuals_Group");
            DropIndex("MonitoringDeliverables.SummarisedActual", "IX_SummarisedActual_Natural_Key");
            CreateIndex("MonitoringDeliverables.SummarisedActual", new[] { "CollectionType", "CollectionReturnCode", "OrganisationId", "FundingStreamPeriodCode", "UopCode" }, name: "IX_SummarisedActual_Actuals_Group");
            CreateIndex("MonitoringDeliverables.SummarisedActual", new[] { "CollectionType", "CollectionReturnCode", "OrganisationId", "FundingStreamPeriodCode", "UopCode", "ContractAllocationNumber", "Period", "DeliverableCode" }, unique: true, name: "IX_SummarisedActual_Natural_Key");
        }
        
        public override void Down()
        {
            DropIndex("MonitoringDeliverables.SummarisedActual", "IX_SummarisedActual_Natural_Key");
            DropIndex("MonitoringDeliverables.SummarisedActual", "IX_SummarisedActual_Actuals_Group");
            CreateIndex("MonitoringDeliverables.SummarisedActual", new[] { "CollectionType", "CollectionReturnCode", "OrganisationId", "FundingStreamPeriodCode", "UopCode", "Period", "DeliverableCode" }, unique: true, name: "IX_SummarisedActual_Natural_Key");
            CreateIndex("MonitoringDeliverables.SummarisedActual", new[] { "CollectionType", "CollectionReturnCode", "OrganisationId", "FundingStreamPeriodCode" }, name: "IX_SummarisedActual_Actuals_Group");
        }
    }
}
