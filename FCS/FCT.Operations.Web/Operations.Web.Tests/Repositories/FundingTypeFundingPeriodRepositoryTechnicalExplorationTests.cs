namespace Operations.Web.Tests.Repositories
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FundingTypeFundingPeriodRepositoryTechnicalExplorationTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingTypeFundingPeriodRepository_GetLevyDefaultContractStartDate_ShouldUseCacheWhenCalledTwice()
        {
            // Arrange 
            var repository = new Web.Repositories.FundingTypeFundingPeriodRepository();
            var defaultContractStartDateFirst = repository.GetLevyDefaultContractStartDate().Result;

            // Act & Assert
            var defaultContractStartDateSecond = repository.GetLevyDefaultContractStartDate().Result;
        }
    }
}