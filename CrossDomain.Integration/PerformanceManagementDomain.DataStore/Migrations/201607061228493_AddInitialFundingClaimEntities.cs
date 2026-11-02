namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddInitialFundingClaimEntities : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PerformanceManagement.FundingClaimContractAllocation",
                c => new
                    {
                        Id = c.Guid(nullable: false),
                        FundingClaimId = c.Guid(nullable: false),
                        ContractAllocationNumber = c.String(nullable: false, maxLength: 20),
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 20),
                    })
                .PrimaryKey(t => t.Id)
                .ForeignKey("PerformanceManagement.FundingClaim", t => t.FundingClaimId, cascadeDelete: true)
                .Index(t => new { t.FundingClaimId, t.ContractAllocationNumber }, unique: true, name: "IX_FundingClaimAllocationNaturalKey");
            
            CreateTable(
                "PerformanceManagement.FundingClaim",
                c => new
                    {
                        Id = c.Guid(nullable: false),
                        OrganisationIdentifier = c.String(nullable: false, maxLength: 10),
                        Ukprn = c.Int(nullable: false),
                        VersionNumber = c.Int(nullable: false),
                        ClaimTypeName = c.String(nullable: false, maxLength: 20),
                        PeriodTypeCode = c.String(nullable: false, maxLength: 10),
                        Period = c.String(nullable: false, maxLength: 4),
                        HasBeenSigned = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => t.Id)
                .Index(t => new { t.OrganisationIdentifier, t.VersionNumber, t.ClaimTypeName, t.PeriodTypeCode }, unique: true, name: "IX_FundingClaimNaturalKey");
            
            CreateTable(
                "PerformanceManagement.FundingClaimDeliverable",
                c => new
                    {
                        ContractAllocationId = c.Guid(nullable: false),
                        DeliverableCode = c.Int(nullable: false),
                        ActualValue = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ForecastValue = c.Decimal(nullable: false, precision: 18, scale: 2),
                        AdjustmentValue = c.Decimal(nullable: false, precision: 18, scale: 2),
                    })
                .PrimaryKey(t => new { t.ContractAllocationId, t.DeliverableCode })
                .ForeignKey("PerformanceManagement.FundingClaimContractAllocation", t => t.ContractAllocationId, cascadeDelete: true)
                .Index(t => t.ContractAllocationId);
            
        }
        
        public override void Down()
        {
            DropForeignKey("PerformanceManagement.FundingClaimDeliverable", "ContractAllocationId", "PerformanceManagement.FundingClaimContractAllocation");
            DropForeignKey("PerformanceManagement.FundingClaimContractAllocation", "FundingClaimId", "PerformanceManagement.FundingClaim");
            DropIndex("PerformanceManagement.FundingClaimDeliverable", new[] { "ContractAllocationId" });
            DropIndex("PerformanceManagement.FundingClaim", "IX_FundingClaimNaturalKey");
            DropIndex("PerformanceManagement.FundingClaimContractAllocation", "IX_FundingClaimAllocationNaturalKey");
            DropTable("PerformanceManagement.FundingClaimDeliverable");
            DropTable("PerformanceManagement.FundingClaim");
            DropTable("PerformanceManagement.FundingClaimContractAllocation");
        }
    }
}
