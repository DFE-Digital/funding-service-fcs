namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;

    [TestClass]
    public class FundingStreamPeriodQueryRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodQueryRepository_GetPayOnProfileFundingStreamPeriodCodes_ShouldReturnCorrectFSPCodes()
        {
            // arrange
            var fspCodes = new List<string>
            {
                "16-18TRN1718",  // POP
                "16-18TRN1819",  // POP
                "1619LR1718",    // NON POP
                "1619LR1819"     // NON POP
            };

            var repository = new FundingStreamPeriodQueryRepository();

            using (var context = new PerformanceManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // Act
                var assertPoPFspCodes = repository.GetPayOnProfileFundingStreamPeriodCodes(fspCodes, connectionInfo).Result;

                // Assert
                Assert.AreEqual(2, assertPoPFspCodes.Count, "Incorrect number of FSP codes returned");

                Assert.IsTrue( assertPoPFspCodes.Contains("1619LR1718"), "FSP code '1619LR1718' was incorrectly not returned");
                Assert.IsTrue(assertPoPFspCodes.Contains("1619LR1819"), "FSP code '1619LR1819' was incorrectly not returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodQueryRepository_GetPayOnProfileFundingStreamPeriodCodes_ShouldReturnNoFSPCodes()
        {
            // arrange
            var fspCodes = new List<string>
            {
                "16-18TRN1718", // NON POP
                "16-18TRN1819"  // NON POP
            };

            var repository = new FundingStreamPeriodQueryRepository();

            using (var context = new PerformanceManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // Act
                var assertPoPFspCodes = repository.GetPayOnProfileFundingStreamPeriodCodes(fspCodes, connectionInfo).Result;

                // Assert
                Assert.AreEqual(0, assertPoPFspCodes.Count, "Incorrect number of FSP codes returned");
            }
        }
    }
}