namespace ContractManagement.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AllowNullablePlannedValueEnvelopeColumns : DbMigration
    {
        public override void Up()
        {
            AlterColumn("ContractManagement.ApprovedContractAllocation", "PlannedValueEnvelope1", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("ContractManagement.ApprovedContractAllocation", "PlannedValueEnvelope2", c => c.Decimal(precision: 18, scale: 2));
            Sql("UPDATE ContractManagement.ApprovedContractAllocation SET PlannedValueEnvelope1 = NULL, PlannedValueEnvelope2 = NULL");
        }
        
        public override void Down()
        {
            AlterColumn("ContractManagement.ApprovedContractAllocation", "PlannedValueEnvelope2", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("ContractManagement.ApprovedContractAllocation", "PlannedValueEnvelope1", c => c.Decimal(nullable: false, precision: 18, scale: 2));
        }
    }
}
