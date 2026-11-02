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
    public class FundingStreamPeriodRepositoryTechnicalExplorationTests
    {
        private static string ConnectionString => ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString;

        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingStreamPeriodRepository_GetFundingStreamPeriod_ShouldUseCacheWhenReturningASomeFundingStreamPeriod()
        {
            // arrange
            const string fspCodeNone = "fspCodeNone";
            ClearDownFsp(fspCodeNone);

            const string fspCodeSome = "fspCodeSome";
            const string fspNameSome = "fspNameSome";
            ClearDownFsp(fspCodeSome);
            CreateFsp(fspCodeSome, fspNameSome);

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var repository = new FundingStreamPeriodRepository();
                ConnectionInfo connectionInfo = ConnectionInfo.CreateFrom(context.Database.Connection);

                var optionalFspFirstNoneCall = repository.GetFundingStreamPeriod(fspCodeNone, connectionInfo);

                // act & assert
                var optionalFspFirstCall = repository.GetFundingStreamPeriod(fspCodeSome, connectionInfo);
                var optionalFspCacheCall = repository.GetFundingStreamPeriod(fspCodeSome, connectionInfo);
            }

            ClearDownFsp(fspCodeSome);  // this is here to prevent config extract compare diffs
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingStreamPeriodRepository_GetFundingStreamPeriod_ShouldUseCacheWhenReturningANoneFundingStreamPeriod()
        {
            // arrange
            const string fspCodeNone = "fspCodeNone";
            ClearDownFsp(fspCodeNone);

            const string fspCodeSome = "fspCodeSome";
            const string fspNameSome = "fspNameSome";
            ClearDownFsp(fspCodeSome);
            CreateFsp(fspCodeSome, fspNameSome);

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var repository = new FundingStreamPeriodRepository();
                ConnectionInfo connectionInfo = ConnectionInfo.CreateFrom(context.Database.Connection);

                var optionalFspFirstSomeCall = repository.GetFundingStreamPeriod(fspCodeSome, connectionInfo);

                // act & assert
                var optionalFspFirstNoneCall = repository.GetFundingStreamPeriod(fspCodeNone, connectionInfo);
                var optionalFspCacheNoneCall = repository.GetFundingStreamPeriod(fspCodeNone, connectionInfo);
            }

            ClearDownFsp(fspCodeSome);  // this is here to prevent config extract compare diffs
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