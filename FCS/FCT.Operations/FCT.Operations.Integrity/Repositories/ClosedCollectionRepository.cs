namespace SFA.FCT.Operations.Integrity.Repositories
{
    using Dapper;
    using System;
    using System.Data.SqlClient;
    using FCS.Worker.Common;

    public class ClosedCollectionRepository
    {
        private readonly IFcsConfiguration _configuration;

        public ClosedCollectionRepository(IFcsConfiguration configuration)
        {
            _configuration = configuration;
        }

        private string ConnectionString => _configuration["ConnectionStrings:MonitoringDeliverablesDbContext"];

        public DateTime GetLastClosedTime(string collectionType)
        {
            using (var sqlConnection = new SqlConnection(ConnectionString))
            {
                return sqlConnection.ExecuteScalar<DateTime>("sp_Operation_GetLastClosedTime @collectionType", new { collectionType });
            }
        }

        public string GetLatestCollectionCodeForCollectionType(string collectionType)
        {
            using (var sqlConnection = new SqlConnection(ConnectionString))
            {
                return sqlConnection.ExecuteScalar<string>("sp_Operation_GetLatestCollectionCodeForCollectionType @collectionType", new { collectionType });
            }
        }

        public bool IsCollectionReturnPresent(string collectionType, string collectionReturnCode)
        {
            using (var sqlConnection = new SqlConnection(ConnectionString))
            {
                return sqlConnection.ExecuteScalar<int>("sp_Operation_IsCollectionReturnPresent @collectionType,@collectionReturnCode", new { collectionType, collectionReturnCode }) == 1;
            }
        }

        public bool WasCollectionPulledInTheLast6Hours(string collectionType)
        {
            using (var sqlConnection = new SqlConnection(ConnectionString))
            {
                return sqlConnection.ExecuteScalar<int>("dbo.sp_Operation_HasCollectionPulledInTheLast6Hours @collectionType", new { collectionType }) == 1;
            }
        }

        public bool HasCollectionBeenPulledWithinDuration(string collectionType, TimeSpan timeSpan)
        {
            double secondsToRemove = timeSpan.TotalSeconds;

            using (var sqlConnection = new SqlConnection(ConnectionString))
            {
                return sqlConnection.ExecuteScalar<int>("dbo.sp_Operation_HasCollectionBeenPulledWithinDuration @collectionType,@secondsToRemove", new { collectionType, secondsToRemove }) == 1;
            }
        }
    }
}