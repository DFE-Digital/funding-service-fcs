namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class UpdateToNaturalKeyForFundingClaim : DbMigration
    {
        public override void Up()
        {
            DropIndex("PerformanceManagement.FundingClaim", "IX_FundingClaimNaturalKey");
            CreateIndex("PerformanceManagement.FundingClaim", new[] { "OrganisationIdentifier", "VersionNumber", "ClaimTypeName", "PeriodTypeCode", "Period" }, unique: true, name: "IX_FundingClaimNaturalKey");
        }
        
        public override void Down()
        {
            DropIndex("PerformanceManagement.FundingClaim", "IX_FundingClaimNaturalKey");
            CreateIndex("PerformanceManagement.FundingClaim", new[] { "OrganisationIdentifier", "VersionNumber", "ClaimTypeName", "PeriodTypeCode" }, unique: true, name: "IX_FundingClaimNaturalKey");
        }
    }
}
