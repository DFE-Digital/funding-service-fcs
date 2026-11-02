namespace PerformanceManagementDomain.Tests.PullFundingClaim
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.PullFundingClaim.Extensions;
    using PerformanceManagementDomain.PullFundingClaim.Services;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;

    [TestClass]
    public class FundingClaimsApiAdapterExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimsApiAdapterExtensions_GetNumberOfPagesRequired_ShouldReturnTheCorrectNumber()
        {
            // arrange
            var apiAdapter = new FundingClaimsApiStubAdapter(null, new EnvironmentContext());
            List<(int totalRows, int pagesExpected)> testParameters = new List<(int, int)> { (11, 2), (7, 1), (132, 14) };
            testParameters.ForEach(testParam =>
            {
                // act
                var numberOfPagesRequired = apiAdapter.GetNumberOfPagesRequired(testParam.totalRows);

                // assert
                Assert.AreEqual(testParam.pagesExpected, numberOfPagesRequired, $"we have not got the expected number of pages when the total rows was:{testParam.totalRows}");
            });
            
        }
    }
}
