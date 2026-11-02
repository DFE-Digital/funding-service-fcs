namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using Dapper;
    using ExcelTypes;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.Integration.DataStore;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;

    [TestClass]
    public class StatusSubStatusConfigWriterTests
    {
        private static readonly string connectionString = PaymentGenerationDbContext.KeyVaultValue;

        [TestMethod, TestCategory("IntegrationTest")]
        public void StatusSubStatusConfigWriter_WriteToPaaSDatabase_ShouldWriteConfigToDatabase()
        {
            // Arrange
            var initialCount = GetAll().Count;

            var statuses = new[]
            {
                new StatusSubStatusConfigType {Status = "expectedStatus1", SubStatus = "expectedSubStatus1"},
                new StatusSubStatusConfigType { Status = "expectedStatus2", SubStatus = "expectedSubStatus2"}
            };


            // Act
            StatusSubStatusConfigWriter.WriteToPaaSDatabase(statuses, WriterBehaviour.AddOrUpdate);

            // Assert
            try
            {
                var actualWritten = GetAll();

                actualWritten.Count.Should().Be(statuses.Length + initialCount);

                foreach (var expected in statuses)
                {
                    actualWritten.Should().Contain(c =>
                        c.Status == expected.Status && c.SubStatus == expected.SubStatus);
                }
            }
            finally
            {
                Delete(statuses);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void StatusSubStatusConfigWriter_WriteToPaaSDatabase_ShouldNotAddDuplicates()
        {
            // Arrange
            var initialCount = GetAll().Count;

            var statuses = new[]
            {
                new StatusSubStatusConfigType {Status = "expectedStatus1", SubStatus = "expectedSubStatus1"},
                new StatusSubStatusConfigType { Status = "expectedStatus2", SubStatus = "expectedSubStatus2"}
            };


            // Act
            StatusSubStatusConfigWriter.WriteToPaaSDatabase(statuses, WriterBehaviour.AddOrUpdate);
            StatusSubStatusConfigWriter.WriteToPaaSDatabase(statuses, WriterBehaviour.AddOrUpdate);

            // Assert
            try
            {
                var actualWritten = GetAll();


                actualWritten.Count.Should().Be(statuses.Length + initialCount);
            }
            finally
            {
                Delete(statuses);
            }
        }

        private static IReadOnlyCollection<StatusSubStatusConfigType> GetAll()
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var sql = "SELECT * FROM [FundingAllocation].[StatusSubStatusConfig]";
                return connection.Query<StatusSubStatusConfigType>(sql).ToList();
            }
        }

        private static void Delete(params StatusSubStatusConfigType[] configs)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var sql = "DELETE FROM [FundingAllocation].[StatusSubStatusConfig] where Status = @Status and SubStatus = @SubStatus";
                connection.Execute(sql, configs);
            }
        }
    }
}
