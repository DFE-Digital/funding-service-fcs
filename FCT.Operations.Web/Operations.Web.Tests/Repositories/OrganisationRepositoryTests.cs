namespace Operations.Web.Tests.Repositories
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Configuration;
    using Dapper;
    using System.Data.SqlClient;

    [TestClass]
    public class OrganisationRepositoryTests
    {
        private static string ConnectionString => ConfigurationManager.ConnectionStrings["organisationDomainDatabase"].ConnectionString;

        [TestMethod, TestCategory("IntegrationTest")]
        public void OrganisationRepository_GetOrganisationInfo_ShouldReturnAnOrganisationInfo()
        {
            // Arrange 
            const string ukprn = "123456781";
            const string tradingName = "tradingName";

            RemoveOrganisation(ukprn);
            AddOrganisation(ukprn, tradingName);

            var repository = new Web.Repositories.OrganisationRepository();

            // Act
            var optionalOrganisationInfo = repository.GetOrganisationInfo(ukprn).Result;

            // Assert
            optionalOrganisationInfo.Match(
                Some: orgInfo =>
                {
                    Assert.AreEqual(tradingName, orgInfo.TradingName, "The tradingName is not correct");
                    Assert.AreEqual(ukprn, orgInfo.Ukprn, "The ukprn is not correct");
                },
                None: () =>
                {
                    Assert.Fail("We have not returned anything");
                });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void OrganisationRepository_GetOrganisationInfo_ShouldReturnAnEmptyDto()
        {
            // Arrange 
            const string ukprn = "123456781";

            RemoveOrganisation(ukprn);

            var repository = new Web.Repositories.OrganisationRepository();

            // Act
            var optionalOrganisationInfo = repository.GetOrganisationInfo(ukprn).Result;

            // Assert
            optionalOrganisationInfo.Match(
                Some: orgInfo => { Assert.Fail("The organisationInfo should not have been returned"); },
                None: () => { });
        }

        public void AddOrganisation(string ukprn, string tradingName)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"INSERT INTO[Organisation].[Organisation]
                                        ([Ukprn]
                                        ,[Upin]
                                        ,[SequenceNumber]
                                        ,[TradingName]
                                        ,[HasUkrlpBeenCalledSuccessfully])
                                    VALUES
                                        (@ukprn, @upin, 1, @tradingName, 1)";

                connection.Execute(sql, new { ukprn, upin = ukprn, tradingName});
            }
        }

        public void RemoveOrganisation(string ukprn)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"DELETE FROM [Organisation].[Organisation] WHERE Ukprn = @ukprn";

                connection.Execute(sql, new { ukprn });
            }
        }
    }
}