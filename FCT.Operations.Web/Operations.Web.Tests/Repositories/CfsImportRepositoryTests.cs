namespace Operations.Web.Tests.Repositories
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Web.Repositories;

    [TestClass]
    public class CfsImportRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void CfsImportInfoRepository_ShouldReturnCorrectNumberOfRows()
        {
            // arrange
            const int numRowsInPage = 10;
            var repository = new CfsImportInfoRepository();

            // act
            var rows = repository.GetCfsImportInfos(0, numRowsInPage).Result;

            // assert
            Assert.IsTrue(rows.Count == 10, "Incorrect number of rows returned");
        }
    }
}