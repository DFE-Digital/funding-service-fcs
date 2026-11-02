namespace AllocationDeliveryDomain.Endpoint.Tests.Repository
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Repositories;
    using Dapper;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class FundingStreamPeriodRepositoryTests
    {
        private static string ConnectionString => ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString;

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodRepository_GetFundingStreamPeriod_ShouldReturnASomeFundingStreamPeriod()
        {
            // arrange
            const string fspCodeSome = "fspCodeSome";
            const string fspNameSome = "fspNameSome";

            ClearDownFsp(fspCodeSome);
            CreateFsp(fspCodeSome, fspNameSome);

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var repository = new FundingStreamPeriodRepository();
                ConnectionInfo connectionInfo = ConnectionInfo.CreateFrom(context.Database.Connection);

                // act 
                var optionalFsp = repository.GetFundingStreamPeriod(fspCodeSome, connectionInfo);

                // assert
                optionalFsp.Match(
                    some: fsp =>
                    {
                        Assert.AreEqual(fspCodeSome, fsp.Code, "The fsp code is not correct");
                        Assert.AreEqual(fspNameSome, fsp.Name, "The fsp name is not correct");
                    },
                    none: () => { Assert.Fail("We have returned Optional None when Optional Some should be returned"); });
            }

            ClearDownFsp(fspCodeSome);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodRepository_GetFundingStreamPeriod_ShouldReturnANoneFundingStreamPeriod()
        {
            // arrange
            const string fspCodeNone = "fspCodeNone";

            ClearDownFsp(fspCodeNone);

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var repository = new FundingStreamPeriodRepository();
                ConnectionInfo connectionInfo = ConnectionInfo.CreateFrom(context.Database.Connection);

                // act 
                var optionalFsp = repository.GetFundingStreamPeriod(fspCodeNone, connectionInfo);

                // assert
                optionalFsp.Match(
                    some: fsp =>
                    {
                        Assert.Fail("We have returned Optional Some when Optional None should be returned");
                    },
                    none: () => {});
            }
        }

        private static void ClearDownFsp(string fspCode)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"  DELETE FROM [MonitoringDeliverables].[FundingStreamPeriod]
                                          WHERE [Code] = @fspCode";

                connection.Execute(sql, new { fspCode });
            }
        }

        private static void CreateFsp(string fspCode, string fspName)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"INSERT INTO [MonitoringDeliverables].[FundingStreamPeriod]
                                           ([Code],[Name], [ProcessFutureActuals],[PersistCurrentActualsState]
                                           ,[ZeroiseMissingActuals],[PaymentMethod],[ActivityCloseDate]
                                           ,[MultiCollectionReturns])
                                     VALUES
                                           (@fspCode, @fspName, 0, 0, 0, 4, NULL, 0)";

                connection.Execute(sql, new { fspCode, fspName });
            }
        }
    }
}