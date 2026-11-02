namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddShouldCapPaymentsColumn : DbMigration
    {
        public override void Up()
        {
            AddColumn("PolicyCache.PolicyFundingStreamPeriod", "ShouldCapPayments", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("PolicyCache.PolicyFundingStreamPeriod", "ShouldCapPayments");
        }
    }
}
