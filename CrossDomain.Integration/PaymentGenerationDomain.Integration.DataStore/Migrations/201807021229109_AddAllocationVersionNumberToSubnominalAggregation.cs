namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddAllocationVersionNumberToSubnominalAggregation : DbMigration
    {
        public override void Up()
        {
            AddColumn("PaymentGeneration.SubnominalAggregation", "AllocationVersionNumber", c => c.Int(nullable: false, defaultValue: 0));
        }
        
        public override void Down()
        {
            DropColumn("PaymentGeneration.SubnominalAggregation", "AllocationVersionNumber");
        }
    }
}
