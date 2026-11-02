namespace ContractRequestDomain.Cfs.Tests.Feed
{
    using Cfs.Feed.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class AtomPageTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AtomPage_GetPageNumber_ShouldReturnExpectedPageNumber()
        {
            // arrange
            AtomPage atomPage1 = new AtomPage
            {
                Link = new[]
                {
                    new AtomLink
                    {
                        Href = "https://pp-api-calculate-funding.education.gov.uk/api/v1/allocations/notifications?pageRef=1",
                        Rel = "self"
                    }
                }
            };

            AtomPage atomPage36 = new AtomPage
            {
                Link = new[]
                {
                    new AtomLink
                    {
                        Href = "https://pp-api-calculate-funding.education.gov.uk/api/v1/allocations/notifications?pageRef=36",
                        Rel = "self"
                    }
                }
            };

            Assert.AreEqual(1, atomPage1.GetPageNumber(), "Incorrect page number returned");
            Assert.AreEqual(36, atomPage36.GetPageNumber(), "Incorrect page number returned");
        }
    }
}
