namespace AllocationDeliveryDomain.Endpoint.Tests.DataStore.Repositories
{
    using System.Configuration;
    using System.Data.Entity.Validation;
    using System.Data.SqlClient;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.AllocationDelivery.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using UnitTests.Common;

    [TestClass]
    public class ProcessedMessagesRepositoryTests
    {
        private const string MessageId = "d2afee7d-c2e3-46cb-991c-2461ce07ae90";

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessagesRepository_Add_WhenAddingFirstTime_ShouldAddToRepositoryAndReturnTrue()
        {
            // Arrange
            DeleteProcessedMessagesFromRepository(MessageId);
            ProcessedMessageRepository repository = new ProcessedMessageRepository();

            // Act
            bool wasAdded = repository.Add(MessageId,
                ConnectionInfo.CreateFrom(new SqlConnection(ConfigurationManager.ConnectionStrings["AllocationDeliveryDbContext"].ConnectionString)));

            // Assert
            Assert.IsTrue(wasAdded, "Method returned false when expected true");
            using (var context = new AllocationDeliveryDbContext())
            {
                ProcessedMessage processedMessage = context.ProcessedMessages.Find(MessageId);
                Assert.IsNotNull(MessageId, processedMessage.MessageId, "ProcessedMessage entity was not added to the database");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessagesRepository_Add_WhenAddingSecondTime_ShouldReturnFalse()
        {
            // Arrange
            DeleteProcessedMessagesFromRepository(MessageId);
            ProcessedMessageRepository repository = new ProcessedMessageRepository();

            // Act
            repository.Add(MessageId,
                ConnectionInfo.CreateFrom(new SqlConnection(ConfigurationManager.ConnectionStrings["AllocationDeliveryDbContext"].ConnectionString)));
            bool wasAdded = repository.Add(MessageId,
                ConnectionInfo.CreateFrom(new SqlConnection(ConfigurationManager.ConnectionStrings["AllocationDeliveryDbContext"].ConnectionString)));

            // Assert
            Assert.IsFalse(wasAdded);
            using (var context = new AllocationDeliveryDbContext())
            {
                ProcessedMessage processedMessage = context.ProcessedMessages.Find(MessageId);
                Assert.AreEqual(MessageId, processedMessage.MessageId);
            }
        }

        [ExpectedException(typeof(DbEntityValidationException))]
        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessagesRepository_Add_WhenFailingForOtherReasonThanDuplicateKey_ShouldRethrowException()
        {
            // Arrange
            string overLengthGuid = $"{MessageId}e";
            DeleteProcessedMessagesFromRepository(overLengthGuid);
            ProcessedMessageRepository repository = new ProcessedMessageRepository();

            // Act
            repository.Add(overLengthGuid,
                ConnectionInfo.CreateFrom(new SqlConnection(ConfigurationManager.ConnectionStrings["AllocationDeliveryDbContext"].ConnectionString)));
        }

        private static void DeleteProcessedMessagesFromRepository(string messageId)
        {
            using (var context = new AllocationDeliveryDbContext())
            {
                context.ProcessedMessages.RemoveWhere(m => m.MessageId == messageId);
                context.SaveChanges();
            }
        }
    }
}