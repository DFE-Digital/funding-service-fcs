namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Repositories
{
    using System.Data.Entity.Validation;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
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
            ProcessedMessageRepository repository = new ProcessedMessageRepository(new ContractManagementDbContext());

            // Act
            bool wasAdded = repository.Add(MessageId);

            // Assert
            Assert.IsTrue(wasAdded, "Method returned false when expected true");
            using (var context = new ContractManagementDbContext())
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
            ProcessedMessageRepository repository = new ProcessedMessageRepository(new ContractManagementDbContext());

            // Act
            repository.Add(MessageId);
            bool wasAdded = repository.Add(MessageId);

            // Assert
            Assert.IsFalse(wasAdded);
            using (var context = new ContractManagementDbContext())
            {
                ProcessedMessage processedMessage = context.ProcessedMessages.Find(MessageId);
                Assert.AreEqual(MessageId, processedMessage.MessageId);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessagesRepository_Add_WhenFailingForOtherReasonThanDuplicateKey_ShouldRethrowException()
        {
            // Arrange
            string overLengthGuid = $"{MessageId}e";
            DeleteProcessedMessagesFromRepository(overLengthGuid);

            var repository = new ProcessedMessageRepository(new ContractManagementDbContext());

            // Act & Assert
            Assert.ThrowsExactly<DbEntityValidationException>(() =>
            {
                repository.Add(overLengthGuid);
            });
        }


        private static void DeleteProcessedMessagesFromRepository(string messageId)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.ProcessedMessages.RemoveWhere(m => m.MessageId == messageId);
                context.SaveChanges();
            }
        }
    }
}
