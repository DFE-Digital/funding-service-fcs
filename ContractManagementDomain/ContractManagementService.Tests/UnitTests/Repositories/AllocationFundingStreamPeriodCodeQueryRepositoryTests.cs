using SFA.FCT.CrossDomain.Integration.Common.Repositories;
using global::ContractManagementService.Repositories;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using SFA.FCS.Worker.Common;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;

namespace ContractManagementService.Tests.UnitTests.Repositories
{
    [TestClass, TestCategory("UnitTest")]
    public class AllocationFundingStreamPeriodCodeQueryRepositoryTests
    {
        [TestMethod]
        public async Task GetFundingStreamPeriodCodesAsync_UsesAllocationConfigQueryAndReturnsCodes()
        {
            const string periodCode = "APC";
            var fundingStreamCodes = new[] { "LOANS", "ALLC" };
            IEnumerable<string> expectedCodes = ["CODE1", "CODE2"];
            var configuration = new Mock<IFcsConfiguration>();
            configuration
                .Setup(config => config["ConnectionStrings:AllocationDeliveryDBContext"])
                .Returns("Server=mockServer;Database=MockDb");

            string capturedSql = null;
            object capturedParameters = null;
            var queryExecutor = new Mock<IDapperQueryExecutor>();
            queryExecutor
                .Setup(executor => executor.QueryAsync<string>(
                    It.IsAny<IDbConnection>(),
                    It.IsAny<string>(),
                    It.IsAny<object>()))
                .Callback<IDbConnection, string, object>((_, sql, parameters) => { capturedSql = sql; capturedParameters = parameters; })
                .ReturnsAsync(expectedCodes);

            var repository = new AllocationFundingStreamPeriodCodeQueryRepository(
                configuration.Object,
                queryExecutor.Object);

            var result = await repository.GetFundingStreamPeriodCodesAsync(fundingStreamCodes, periodCode);

            CollectionAssert.AreEqual(expectedCodes.ToArray(), result.ToArray());
            Assert.IsTrue(capturedSql.Contains(@"SELECT DISTINCT alc.FspCode AS FspCode
                    FROM [FundingAllocation].[AllocationLineConfig] AS alc
                    INNER JOIN [FundingAllocation].[AllocationFundingStreamConfig] AS afs 
                        ON alc.FundingStreamCode = afs.AllocationFundingStreamCode AND alc.PeriodId = afs.AllocationPeriodId 
                    WHERE 
                            afs.AllocationFundingStreamCode IN @allocationFundingStreamCodes
                        AND afs.AllocationPeriodId = @allocationPeriodCode
                ORDER BY FspCode"));

            var codesParameter = capturedParameters.GetType().GetProperty("allocationFundingStreamCodes").GetValue(capturedParameters) as IEnumerable<string>;
            var periodParameter = capturedParameters.GetType().GetProperty("allocationPeriodCode").GetValue(capturedParameters) as string;

            CollectionAssert.AreEqual(fundingStreamCodes, codesParameter.ToArray());
            Assert.AreEqual(periodCode, periodParameter);
        }
    }
}
