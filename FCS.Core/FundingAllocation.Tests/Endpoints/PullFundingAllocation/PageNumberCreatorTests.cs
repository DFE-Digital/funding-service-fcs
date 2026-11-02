namespace FundingAllocation.Tests.Endpoints.PullFundingAllocation
{
    using FundingAllocation.Endpoints.PullFundingAllocation;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Collections.Generic;
    using System.Linq;

    [TestClass]
    public class PageNumberCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PageNumberCreator_ShouldReturnPages()
        {
            // arrange
            List<(int currentPage, int latestPage, int[] result)> inputAndOutput =
                new List<(int currentPage, int latestPage, int[] result)>
                {
                    (1, 1, new []{1}),
                    (1, 2, new []{1, 2}),
                    (4, 10, new []{4, 5, 6, 7, 8, 9, 10}),
                    (2, 1, new []{1}),
                };

            inputAndOutput.ForEach(i =>
            {
                // act
                var pages = PageNumberCreator.GetPageNumbers(i.currentPage, i.latestPage);

                // assert
                CollectionAssert.AreEqual(i.result, pages, $"The result is incorrect for: {i}");
            });
        }
    }
}
