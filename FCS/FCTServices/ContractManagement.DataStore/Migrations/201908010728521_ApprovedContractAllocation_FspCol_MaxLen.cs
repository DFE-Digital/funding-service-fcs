namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ApprovedContractAllocation_FspCol_MaxLen : DbMigration
    {
        public override void Up()
        {
            AlterColumn("ContractManagement.ApprovedContractAllocation", "FundingStreamPeriodCode", c => c.String(maxLength: 100));
        }
        
        public override void Down()
        {
            AlterColumn("ContractManagement.ApprovedContractAllocation", "FundingStreamPeriodCode", c => c.String());
        }
    }
}
