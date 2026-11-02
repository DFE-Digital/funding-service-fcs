namespace FCT.Operations.Tests.Connectivity.Repositories
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Data.SqlClient;
    using Dapper;
    using FCT.Operations.Connectivity.Repositories;
    using DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class ConnectivityRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ConnectivityRepository_Connectivity_ShouldInsert()
        {
            // arrange 
            const string serviceName = "TestServiceName";
            const bool canConnect = true;
            const string errorInfo = "ErrorInfo";
            const string supplementaryInfo = "SupplementaryInfo";

            ClearConnectivityRecord(serviceName);

            var connectivityRepository = new ConnectivityRepository();

            // act
            connectivityRepository.InsertOrUpdateConnectivity(serviceName, canConnect, errorInfo, supplementaryInfo, GetConnectionInfo()).Wait();

            var assertConnectivityRecord = GetConnectivityRecord(serviceName);

            // assert
            Assert.IsNotNull(assertConnectivityRecord);
            Assert.AreEqual(canConnect, assertConnectivityRecord.CanConnect);
            Assert.AreEqual(errorInfo, assertConnectivityRecord.ErrorInfo);
            Assert.AreEqual(supplementaryInfo, assertConnectivityRecord.SupplementaryInfo);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ConnectivityRepository_Connectivity_ShouldUpdate()
        {
            // arrange 
            const string serviceName = "TestServiceName";
            const bool canConnect = true;
            const string errorInfo = "ErrorInfo";
            const string supplementaryInfo = "SupplementaryInfo";
            const string before = "before_";

            ClearConnectivityRecord(serviceName);
            CreateConnectivityRecord(serviceName, false, before + errorInfo, before + supplementaryInfo);

            var connectivityRepository = new ConnectivityRepository();

            // act
            connectivityRepository.InsertOrUpdateConnectivity(serviceName, canConnect, errorInfo, supplementaryInfo, GetConnectionInfo()).Wait();

            var assertConnectivityRecord = GetConnectivityRecord(serviceName);

            // assert
            Assert.IsNotNull(assertConnectivityRecord);
            Assert.AreEqual(canConnect, assertConnectivityRecord.CanConnect);
            Assert.AreEqual(errorInfo, assertConnectivityRecord.ErrorInfo);
            Assert.AreEqual(supplementaryInfo, assertConnectivityRecord.SupplementaryInfo);
        }

        private static void ClearConnectivityRecord(string serviceName)
        {
            const string sql = "delete from [Operations].[Connectivity] where [ServiceName] = @serviceName";

            GetConnectionInfo().Connection.Execute(sql, new { serviceName });
        }

        private static void CreateConnectivityRecord(string serviceName, bool canConnect, string errorInfo, string supplementaryInfo)
        {
            const string sql = @"INSERT [Operations].[Connectivity]
                                    ([ServiceName]
                                    ,[CanConnect]
                                    ,[ErrorInfo]
                                    ,[SupplementaryInfo]
                                    ,[LastUpdated])
                                VALUES
                                    (@serviceName
                                    ,@canConnect
                                    ,@errorInfo
                                    ,@supplementaryInfo
                                    ,GETUTCDATE())";

            GetConnectionInfo().Connection.Execute(sql, new { serviceName, canConnect, errorInfo, supplementaryInfo });
        }

        private static Connectivity GetConnectivityRecord(string serviceName)
        {
            const string sql = @"SELECT  [ServiceName]
                                        ,[CanConnect]
                                        ,[ErrorInfo]
                                        ,[SupplementaryInfo]
                                        ,[LastUpdated]
                                        FROM [Operations].[Connectivity]
                                        WHERE [ServiceName] = @serviceName";

            return GetConnectionInfo().Connection.QueryFirst<Connectivity>(sql, new { serviceName });
        }

        private static ConnectionInfo GetConnectionInfo()
        {
            var configuration = AppConfiguration.Configuration();

            return ConnectionInfo.CreateFrom(new SqlConnection(configuration["ConnectionStrings:NServiceBus/Persistence"]));
        }
    }
}