namespace FCT.Operations.Integrity.Tests.Repositories
{
    using System.Collections.Generic;
    using SFA.FCT.Operations.Integrity.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using SFA.FCT.Operations.Integrity.DTOs;
    using System.Linq;

    [TestClass]
    public class DuplicateContractRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void DuplicateContractRepository_GetDuplicatedContracts_ShouldReturnAListOfDuplicateContractNumbers()
        {
            // Arrange 
            var connectionString = ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"TRUNCATE TABLE [operations].[DuplicateContract]
                                     INSERT INTO [Operations].[DuplicateContract] ([ContractNumber],[Version],[SubVersion],[NumDuplicateAllocations], [NumDuplicateContracts]) VALUES ('ContractNumber1', 1, 0, 0, 1)
                                     INSERT INTO [Operations].[DuplicateContract] ([ContractNumber],[Version],[SubVersion], [NumDuplicateAllocations], [NumDuplicateContracts]) VALUES ('ContractNumber2', 1, 0, 0, 1)";

                connection.Execute(sql);
            }

            // Act
            var duplicateContracts = new DuplicateContractRepository(new LocalConfig()).GetDuplicatedContracts();

            // Assert
            Assert.AreEqual(2, duplicateContracts.Count, "Incorrect number of duplicate contracts returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DuplicateContractRepository_GetDuplicatedContracts_ShouldReturnAnEmptyList()
        {
            // Arrange 
            var connectionString = ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"TRUNCATE TABLE [operations].[DuplicateContract]";
                connection.Execute(sql);
            }

            // Act
            var duplicateContracts = new DuplicateContractRepository(new LocalConfig()).GetDuplicatedContracts();

            // Assert
            Assert.AreEqual(0, duplicateContracts.Count, "Incorrect number of duplicate contracts returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DuplicateContractRepository_RefreshDuplicatedContracts_ShouldUpdateTableRows()
        {
            // Arrange 
            const string assertContractNumber = "ContractNumber8";
            var connectionString = ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"TRUNCATE TABLE [operations].[DuplicateContract]
                                     INSERT INTO [Operations].[DuplicateContract] ([ContractNumber],[Version],[SubVersion], [NumDuplicateAllocations], [NumDuplicateContracts]) VALUES ('ContractNumber1', 1, 0, 0, 1)
                                     INSERT INTO [Operations].[DuplicateContract] ([ContractNumber],[Version],[SubVersion], [NumDuplicateAllocations], [NumDuplicateContracts]) VALUES ('ContractNumber2', 1, 0, 0, 1)";
                connection.Execute(sql);
            }

            var newDuplicatedContracts = new List<DuplicateContract> {new DuplicateContract(assertContractNumber, 1, 0, 0, 1)};
            var repository = new DuplicateContractRepository(new LocalConfig());

            // Act
            repository.RefreshDuplicatedContracts(newDuplicatedContracts);

            // Assert
            using (var connection = new SqlConnection(connectionString))
            {
                const string sqlQuery = @"SELECT [ContractNumber]
                                                ,[Version]
                                                ,[SubVersion]
                                                ,[CreatedDate]
                                          FROM [Operations].[DuplicateContract]";

                var assertDuplicateContractTableRows =  connection.Query(sqlQuery).ToList();

                Assert.AreEqual(1, assertDuplicateContractTableRows.Count, "Incorrect number of rows in updated table");
                Assert.AreEqual(assertContractNumber, assertDuplicateContractTableRows.First().ContractNumber, 
                    "Incorrect ContractNumber in updated table");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DuplicateContractRepository_RefreshDuplicatedContracts_ShouldUpdateTableLeavingNoRowsWhenProvidedListIsEmpty()
        {
            // Arrange 
            var connectionString = ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"TRUNCATE TABLE [operations].[DuplicateContract]
                                     INSERT INTO [Operations].[DuplicateContract] ([ContractNumber],[Version],[SubVersion], [NumDuplicateAllocations], [NumDuplicateContracts]) VALUES ('ContractNumber1', 1, 0, 0, 1)
                                     INSERT INTO [Operations].[DuplicateContract] ([ContractNumber],[Version],[SubVersion], [NumDuplicateAllocations], [NumDuplicateContracts]) VALUES ('ContractNumber2', 1, 0, 0, 1)";
                connection.Execute(sql);
            }

            var repository = new DuplicateContractRepository(new LocalConfig());

            // Act
            repository.RefreshDuplicatedContracts(new List<DuplicateContract>());

            // Assert
            using (var connection = new SqlConnection(connectionString))
            {
                const string sqlQuery = @"SELECT [ContractNumber]
                                                ,[Version]
                                                ,[SubVersion]
                                                ,[CreatedDate]
                                          FROM [Operations].[DuplicateContract]";

                var assertDuplicateContractTableRows = connection.Query(sqlQuery).ToList();

                Assert.AreEqual(0, assertDuplicateContractTableRows.Count, "Incorrect number of rows in updated table");
            }
        }
    }
}