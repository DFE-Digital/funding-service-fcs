namespace SFA.FCT.ContractManagementService.Test.Integration.Repositories
{
    using System.Linq;
    using System.Threading.Tasks;
    using global::ContractManagementService.Repositories;
    using global::ContractManagementService.Tests;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractManagementService.Test.Utils;
    using SFA.FCT.CrossDomain.Integration.Common.Repositories;

    [TestClass]
    public class AllocationFundingStreamPeriodCodeQueryRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public async Task GetFundingStreamPeriodCodesAsync_ReturnsExpectedAsfCodesForAllocationPeriod()
        {
            FundingAllocationConfigSeeder.EnsureAsfAllocationPeriod2526Exists();

            var configuration = new AppConfiguration();
            var repository = new AllocationFundingStreamPeriodCodeQueryRepository(
                configuration,
                new DapperQueryExecutor());

            var fundingStreamPeriodCodes = await repository.GetFundingStreamPeriodCodesAsync(
                new[] { "ASFC", "ASFG", "ASCA" },
                "AY-2526");

            var expected = new[]
            {
                "ASF2023-AS2526",
                "ASF2023-FCFJ2526",
                "ASFC-ASCL2526",
                "ASFC-FCFJ2526"
            };
            var actual = fundingStreamPeriodCodes.ToArray();

            CollectionAssert.IsSubsetOf(
                expected,
                actual,
                $"Missing: [{string.Join(", ", expected.Except(actual))}]. Actual ({actual.Length}): [{string.Join(", ", actual)}]");
        }
    }
}
