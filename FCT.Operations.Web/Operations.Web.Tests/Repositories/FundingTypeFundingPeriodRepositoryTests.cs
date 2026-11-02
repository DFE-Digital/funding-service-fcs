namespace Operations.Web.Tests.Repositories
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FundingTypeFundingPeriodRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodRepository_GetLevyDefaultContractStartDate_ShouldReturnDefaultContractStartDate()
        {
            // Arrange 
            var repository = new Web.Repositories.FundingTypeFundingPeriodRepository();

            // Act
            var defaultContractStartDate = repository.GetLevyDefaultContractStartDate().Result;

            // Assert
            Assert.IsNotNull(defaultContractStartDate, "defaultContractStartDate was not returned");
        }
    }
}