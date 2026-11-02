namespace FCT.Operations.Maintenance.Endpoint.Tests.Repositories
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Operations.Maintenance.Endpoint.Repositories;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using System.Linq;

    [TestClass]
    public class CrmReplicaRepositoryTests
    {
        private static string ConnectionString => ConfigurationManager.ConnectionStrings["CrmDatabaseConnectionString"].ConnectionString;

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmReplicaRepository_GetContractReplicationFailures_ShouldGetSpecificContractReplicationFailures()
        {
            // arrange
            const string contractId1 = "ad7df8d1-97b3-4700-8bf6-24ed2bbeaa34";
            const string contractNo1 = "TestContractNo1";
            const string contractVersion1 = "199";
            const string contractSubVersion1 = "188";
            const int deleteLogCrmVersionNumber1 = 1300;
            const int contractCrmVersionNumber1 = 1200;

            TestContractClearDown(contractId1, contractNo1, deleteLogCrmVersionNumber1);
            TestContractSetup(contractId1, contractNo1, contractVersion1, contractSubVersion1, deleteLogCrmVersionNumber1, contractCrmVersionNumber1);

            const string contractId2 = "90826e64-efd0-4d31-80aa-5a7f81308447";
            const string contractNo2 = "TestContractNo2";
            const string contractVersion2 = "299";
            const string contractSubVersion2 = "288";
            const int deleteLogCrmVersionNumber2 = 2300;
            const int contractCrmVersionNumber2 = 2200;

            TestContractClearDown(contractId2, contractNo2, deleteLogCrmVersionNumber2);
            TestContractSetup(contractId2, contractNo2, contractVersion2, contractSubVersion2, deleteLogCrmVersionNumber2, contractCrmVersionNumber2);

            var repository = new CrmReplicaRepository(new LocalConfig());

            // act
            var contractReplicationFailures = repository.GetContractReplicationFailures().Result;

            // assert
            Assert.IsTrue(contractReplicationFailures.Count >= 2, "At least 2 contract records should have returned");
            Assert.IsTrue(contractReplicationFailures.Any(c => c.ContractNumber == contractNo1),$"Contract No '{contractNo1}' was not returned");
            Assert.IsTrue(contractReplicationFailures.Any(c => c.ContractNumber == contractNo2), $"Contract No '{contractNo2}' was not returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmReplicaRepository_GetContractReplicationFailures_ShouldNotGetSpecificContractReplicationFailures()
        {
            // arrange
            const string contractId1 = "ad7df8d1-97b3-4700-8bf6-24ed2bbeaa34";
            const string contractNo1 = "TestContractNo1";
            const int deleteLogCrmVersionNumber1 = 1300;

            TestContractClearDown(contractId1, contractNo1, deleteLogCrmVersionNumber1);

            const string contractId2 = "90826e64-efd0-4d31-80aa-5a7f81308447";
            const string contractNo2 = "TestContractNo2";
            const int deleteLogCrmVersionNumber2 = 2300;

            TestContractClearDown(contractId2, contractNo2, deleteLogCrmVersionNumber2);

            var repository = new CrmReplicaRepository(new LocalConfig());

            // act
            var contractReplicationFailures = repository.GetContractReplicationFailures().Result;

            // assert
            Assert.IsFalse(contractReplicationFailures.Any(c => c.ContractNumber == contractNo1), $"Contract No '{contractNo1}' was returned");
            Assert.IsFalse(contractReplicationFailures.Any(c => c.ContractNumber == contractNo2), $"Contract No '{contractNo2}' was returned");
        }

        private static void TestContractSetup(string contractId, string contractNo, string contractVersion, string contractSubVersion, int deleteLogCrmVersionNumber, int contractCrmVersionNumber)
        {
            var sqlDeleteLogSetup = "INSERT INTO [dbo].[DeleteLog] ([EntityName], [RecordId], [SinkDeleteTime], [VersionNumber]) " +
                                    "VALUES ('sfa_contract', @contractId, GetDate(), @deleteLogCrmVersionNumber)";
            ExecuteSql(sqlDeleteLogSetup, new { contractId, deleteLogCrmVersionNumber });

            var sqlContractSetup = "INSERT INTO [dbo].[sfa_contract] ([Id], [sfa_number], [sfa_version], [sfa_subversion], [VersionNumber]) " +
                                   "VALUES (@contractId, @contractNo, @contractVersion, @contractSubVersion, @contractCrmVersionNumber)";
            ExecuteSql(sqlContractSetup, new { contractId, contractNo, contractVersion, contractSubVersion, contractCrmVersionNumber });

            var sqlGetCountOfCreatedContracts = "SELECT COUNT(1) FROM[dbo].[sfa_contract] WHERE[sfa_number] = @contractNo AND [Id] = @contractId";
            var countOfCreatedContracts = ExecuteScalarSql<int>(sqlGetCountOfCreatedContracts, new { contractId, contractNo });

            Assert.AreEqual(1, countOfCreatedContracts, $"Contract record '{contractNo}' was not created within the arrange part of the test");
        }

        private static void TestContractClearDown(string contractId, string contractNo, int deleteLogCrmVersionNumber)
        {

            var sqlDeleteLogClearDown = "DELETE FROM [dbo].[DeleteLog] WHERE [EntityName] = 'sfa_contract' AND [RecordId] = @contractId AND [VersionNumber] = @deleteLogCrmVersionNumber";
            ExecuteSql(sqlDeleteLogClearDown, new { contractId, deleteLogCrmVersionNumber });

            var sqlContractClearDown = "DELETE FROM [dbo].[sfa_contract] WHERE [sfa_number] = @contractNo AND [Id] = @contractId";
            ExecuteSql(sqlContractClearDown, new { contractNo, contractId });

            var sqlGetCountOfCreatedContracts = "SELECT COUNT(1) FROM [dbo].[sfa_contract] WHERE [sfa_number] = @contractNo AND [Id] = @contractId";
            var countOfCreatedContracts = ExecuteScalarSql<int>(sqlGetCountOfCreatedContracts, new {contractNo, contractId});

            Assert.AreEqual(0, countOfCreatedContracts, $"Contract record '{contractNo}' was not removed within the arrange part of the test");
        }

        private static void ExecuteSql(string sql, object parameter)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Execute(sql, parameter);
            }
        }

        private static T ExecuteScalarSql<T>(string sql, object parameter)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                return connection.ExecuteScalar<T>(sql, parameter);
            }
        }
    }
}