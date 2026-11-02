namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateContractAllocation : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PerformanceManagement.ContractAllocation",
                c => new
                    {
                        AllocationNumber = c.String(nullable: false, maxLength: 30),
                        StartDate = c.DateTime(nullable: false),
                        EndDate = c.DateTime(nullable: false),
                        Contract_ContractNumber = c.String(nullable: false, maxLength: 30),
                        Contract_VersionNumber = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Contract_SubVersionNumber = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Contract_ApprovalDate = c.DateTime(nullable: false),
                        Contractor_OrganisationIdentifier = c.String(nullable: false, maxLength: 20),
                        Contractor_UKPRN = c.Int(nullable: false),
                        Contractor_LegalName = c.String(nullable: false, maxLength: 100),
                        FundingType_FundingTypeCode = c.String(nullable: false, maxLength: 20),
                        FundingType_FundingTypeName = c.String(nullable: false, maxLength: 50),
                    })
                .PrimaryKey(t => t.AllocationNumber);
            
        }
        
        public override void Down()
        {
            DropTable("PerformanceManagement.ContractAllocation");
        }
    }
}
