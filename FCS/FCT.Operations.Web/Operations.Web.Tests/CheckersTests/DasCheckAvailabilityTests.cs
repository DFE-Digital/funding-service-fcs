namespace Operations.Web.Tests.CheckersTests
{
    using Checkers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Web.Repositories;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;

    [TestClass]
    public class DasCheckAvailabilityTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void DasCheckAvailability_ShouldReturnTrueIsAvailable()
        {
            // arrange
            RemoveDasConnectivity();
            AddDasConnectivity(1);
            var dasCheckAvailability = new DasCheckAvailability(new ConnectivityRepository());

            // act
            var result = dasCheckAvailability.GetCheckResult().GetAwaiter().GetResult();

            // assert
            Assert.IsTrue(result.IsAvailable);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DasCheckAvailability_ShouldReturnFalseIsAvailable()
        {
            // arrange
            RemoveDasConnectivity();
            AddDasConnectivity(0);
            var dasCheckAvailability = new DasCheckAvailability(new ConnectivityRepository());

            // act
            var result = dasCheckAvailability.GetCheckResult().GetAwaiter().GetResult();

            // assert
            Assert.IsFalse(result.IsAvailable);
        }

        private static void RemoveDasConnectivity()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"DELETE FROM [Operations].[Connectivity] WHERE ServiceName = 'DAS'";

                connection.Execute(sql);
            }
        }

        private static void AddDasConnectivity(int canConnect)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"INSERT [Operations].[Connectivity]
                                           ([ServiceName]
                                           ,[CanConnect]
                                           ,[ErrorInfo]
                                           ,[SupplementaryInfo]
                                           ,[LastUpdated]
                                           ,[CreatedDate])
                                     VALUES
                                           ('DAS', @canConnect, 'ErrorInfo', 'SupplementaryInfo', GETDATE(), GETDATE())";

                connection.Execute(sql, param: new { canConnect });
            }
        }
    }
}