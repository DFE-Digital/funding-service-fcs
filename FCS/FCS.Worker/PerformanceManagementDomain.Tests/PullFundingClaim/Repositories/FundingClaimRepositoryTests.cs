namespace PerformanceManagementDomain.Tests.PullFundingClaim.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.Entity;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.PullFundingClaim.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    [TestClass]
    public class FundingClaimRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimRepository_ShouldAddClaims()
        {
            // arrange
            const int ukprn = 12345;

            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["PerformanceManagementDbContext"].ConnectionString))
            {
                connection.Execute($"DELETE FROM PerformanceManagement.FundingClaim WHERE Ukprn = {ukprn}");
            }

            var fundingClaim = new FundingClaim("ORG12345", ukprn, 1, "FINAL", "AY", "1920", true);
            var allocation = new FundingClaimContractAllocation(fundingClaim.Id, "ALLOC-1234", "FSP-1920");
            var deliverable = new FundingClaimDeliverable(allocation.Id, 2, 100m, 200m, 300m, 400m);
            fundingClaim.Allocations = new List<FundingClaimContractAllocation> { allocation };
            allocation.Deliverables = new List<FundingClaimDeliverable> { deliverable };

            var repository = new FundingClaimRepository();
            var connectionInfo = new ConnectionInfo(null, new SqlConnection(ConfigurationManager.ConnectionStrings["PerformanceManagementDbContext"].ConnectionString));

            // act
            repository.AddFundingClaims(new[] { fundingClaim }, connectionInfo).Wait();

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                FundingClaim storedFundingClaim = context.FundingClaims
                    .Include(fc => fc.Allocations)
                    .Where(fc => fc.Ukprn == ukprn)
                    .Include(x => x.Allocations.Select(a => a.Deliverables))
                    .SingleOrDefault();

                storedFundingClaim.Should().NotBeNull("funding claim should be present in storage");
                storedFundingClaim.OrganisationIdentifier.Should().Be("ORG12345", "OrganisationIdentifier should be stored correctly");
                storedFundingClaim.Ukprn.Should().Be(ukprn, "Ukprn should be stored correctly");
                storedFundingClaim.VersionNumber.Should().Be(1, "VersionNumber should be stored correctly");
                storedFundingClaim.ClaimTypeName.Should().Be("FINAL", "ClaimTypeName should be stored correctly");
                storedFundingClaim.PeriodTypeCode.Should().Be("AY", "PeriodTypeCode should be stored correctly");
                storedFundingClaim.Period.Should().Be("1920", "Period should be stored correctly");
                storedFundingClaim.HasBeenSigned.Should().BeTrue("HasBeenSigned should be stored correctly");
                storedFundingClaim.Allocations.Should().HaveCount(1, "Allocations should be stored correctly");

                FundingClaimContractAllocation storedAllocation = storedFundingClaim.Allocations.Single();
                storedAllocation.ContractAllocationNumber.Should().Be("ALLOC-1234", "ContractAllocationNumber should be stored correctly");
                storedAllocation.FundingStreamPeriodCode.Should().Be("FSP-1920", "FundingStreamPeriodCode should be stored correctly");
                storedAllocation.Deliverables.Should().HaveCount(1, "Deliverables should be stored correctly");

                FundingClaimDeliverable storedDeliverable = storedAllocation.Deliverables.Single();
                storedDeliverable.DeliverableCode.Should().Be(2, "DeliverableCode should be stored correctly");
                storedDeliverable.ActualValue.Should().Be(100m, "ActualValue should be stored correctly");
                storedDeliverable.ForecastValue.Should().Be(200m, "ForecastValue should be stored correctly");
                storedDeliverable.AdjustmentValue.Should().Be(300m, "AdjustmentValue should be stored correctly");
                storedDeliverable.TotalDelivery.Should().Be(400m, "TotalDelivery should be stored correctly");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimRepository_ShouldGetCountOfFundingClaimsForCollection()
        {
            // arrange
            const string claimTypeName = "FINAL";
            const string period = "1920";

            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["PerformanceManagementDbContext"].ConnectionString))
            {
                connection.Execute(
                    "DELETE FROM PerformanceManagement.FundingClaim WHERE ClaimTypeName = @claimTypeName AND Period = @period",
                    new {claimTypeName, period});
            }

            var fundingClaim = new FundingClaim("ORG12345", 12345, 1, claimTypeName, "AY", period, true);
            var allocation = new FundingClaimContractAllocation(fundingClaim.Id, "ALLOC-1234", "FSP-1920");
            var deliverable = new FundingClaimDeliverable(allocation.Id, 2, 100m, 200m, 300m, 400m);
            fundingClaim.Allocations = new List<FundingClaimContractAllocation> { allocation };
            allocation.Deliverables = new List<FundingClaimDeliverable> { deliverable };

            using (var context = new PerformanceManagementDbContext())
            {
                context.FundingClaims.Add(fundingClaim);
                context.SaveChanges();
            }

            var repository = new FundingClaimRepository();
            var connectionInfo = new ConnectionInfo(null, new SqlConnection(ConfigurationManager.ConnectionStrings["PerformanceManagementDbContext"].ConnectionString));

            // act
            int fundingClaimsCountForCollection = repository.GetCountOfFundingClaimsForCollection(period, claimTypeName, connectionInfo).Result;

            // assert
            fundingClaimsCountForCollection.Should().Be(1);
        }
    }
}
