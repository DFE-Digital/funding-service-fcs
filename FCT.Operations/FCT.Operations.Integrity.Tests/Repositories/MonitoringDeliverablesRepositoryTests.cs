namespace FCT.Operations.Integrity.Tests.Repositories
{
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Operations.Integrity.Repositories;

    [TestClass]
    public class MonitoringDeliverablesRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesRepository_GetMultipleCollectionGroupId_ShouldReturnSomeWhenAppropriate()
        {
            // arrange
            var connectionString = ConfigurationManager.ConnectionStrings["NServiceBus/Persistence"].ConnectionString;
            SqlConnection connection = new SqlConnection(connectionString);
            MonitoringDeliverablesRepository repository = new MonitoringDeliverablesRepository(connection);

            // act
            var resultOption = repository.GetMultipleCollectionGroupId("APPS1819", "APPS", "APPS16");

            // assert
            resultOption.Match(Some: id => id.Should().Be(1),
                None: () => Assert.Fail("We should have returned an Id"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesRepository_GetMultipleCollectionGroupId_ShouldReturnNoneWhenAppropriate()
        {
            // arrange
            var connectionString = ConfigurationManager.ConnectionStrings["NServiceBus/Persistence"].ConnectionString;
            SqlConnection connection = new SqlConnection(connectionString);
            MonitoringDeliverablesRepository repository = new MonitoringDeliverablesRepository(connection);

            // act
            var resultOption = repository.GetMultipleCollectionGroupId("APPS1718", "APPS", "APPS16");

            // assert
            resultOption.Match(Some:id => Assert.Fail("We should have not return an id"),
                None: () => { });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesRepository_GetCollectionReturns_ShouldReturnCorrectRows()
        {
            // arrange
            var connectionString = ConfigurationManager.ConnectionStrings["NServiceBus/Persistence"].ConnectionString;
            SqlConnection connection = new SqlConnection(connectionString);
            MonitoringDeliverablesRepository repository = new MonitoringDeliverablesRepository(connection);

            // act
            var collectionReturns = repository.GetCollectionReturns(10, "APPS", "APPS25");

            // assert
            collectionReturns.Count.Should().Be(1);
            collectionReturns.Single().CollectionReturnCode.Should().Be("APPS25");
            collectionReturns.Single().CollectionType.Should().Be("APPS");
        }
    }
}
