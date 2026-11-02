namespace ContractRequestDomain.Tests.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Repositories;

    [TestClass]
    public class ProcessedMessageRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessagesRepository_WhenMessageWasNotPreviouslyProcessed_ShouldAddToRepositoryAndReturnTrue()
        {
            const string messageId = "9F1EB453-BDFA-4D26-A592-77C67E33B953";

            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            // arrange
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute("DELETE FROM ContractManagement.ProcessedMessage WHERE MessageId = @messageId", new { messageId });
            }

            var repositoryConnection = new SqlConnection(connectionString);
            repositoryConnection.Open();
            ProcessedMessageRepository repository = new ProcessedMessageRepository(repositoryConnection);

            // act
            bool isSuccess = repository.Add(messageId);

            // assert
            isSuccess.Should().BeTrue("repository should return true when Message Id was not previously processed");

            using (var connection = new SqlConnection(connectionString))
            {
                int rowCount = connection.ExecuteScalar<int>("SELECT COUNT(*) FROM ContractManagement.ProcessedMessage WHERE MessageId = @messageId", new { messageId });
                rowCount.Should().Be(1, "repository should store row in database when Message Id was not previously processed");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessagesRepository_WhenMessageWasPreviouslyProcessed_ShouldReturnFalse()
        {
            const string messageId = "1B518E83-42FA-457D-8FBC-3D1D1AF04FCA";

            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            // arrange
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute("DELETE FROM ContractManagement.ProcessedMessage WHERE MessageId = @messageId", new { messageId });
                connection.Execute("INSERT INTO ContractManagement.ProcessedMessage (MessageId) VALUES (@messageId)", new { messageId });
            }

            var repositoryConnection = new SqlConnection(connectionString);
            repositoryConnection.Open();
            ProcessedMessageRepository repository = new ProcessedMessageRepository(repositoryConnection);

            // act
            bool isSuccess = repository.Add(messageId);

            // assert
            isSuccess.Should().BeFalse("repository should return false when Message Id was previously processed");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessagesRepository_WhenFailingForReasonOtherThanDuplicateKey_ShouldRethrowException()
        {
            const string overLengthMessageId = "INVALID-GUID-STRING-WITH-EXCESSIVE-LENGTH";

            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            // arrange
            var repositoryConnection = new SqlConnection(connectionString);
            repositoryConnection.Open();
            ProcessedMessageRepository repository = new ProcessedMessageRepository(repositoryConnection);

            // act
            Action act = () => repository.Add(overLengthMessageId);

            // assert
            act.Should()
                .Throw<SqlException>()
                .WithMessage("*String or binary data would be truncated*");
        }
    }
}
