namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AlteredOrderOfFundingClaimIndex : DbMigration
    {
        public override void Up()
        {
            DropIndex("PerformanceManagement.FundingClaim", "IX_FundingClaimNaturalKey");
            CreateIndex("PerformanceManagement.FundingClaim", new[] { "ClaimTypeName", "Period", "PeriodTypeCode", "VersionNumber", "OrganisationIdentifier" }, unique: true, name: "IX_FundingClaimNaturalKey");
        }
        
        public override void Down()
        {
            DropIndex("PerformanceManagement.FundingClaim", "IX_FundingClaimNaturalKey");
            CreateIndex("PerformanceManagement.FundingClaim", new[] { "OrganisationIdentifier", "VersionNumber", "ClaimTypeName", "PeriodTypeCode", "Period" }, unique: true, name: "IX_FundingClaimNaturalKey");
        }
    }
}
